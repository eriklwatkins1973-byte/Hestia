-- Hestia Database Schema
-- Migration 001: Initial Schema
-- Multi-tenant homelessness resource directory

-- Enable required extensions
create extension if not exists "uuid-ossp";
create extension if not exists "postgis";

-- ============================================================
-- TENANT / STATE CONFIGURATION (Multi-Tenant)
-- ============================================================

create table public.tenant_configs (
  id            uuid primary key default uuid_generate_v4(),
  state_code    text not null unique,         -- e.g. "TX", "CA"
  state_name    text not null,                -- e.g. "Texas"
  primary_color text not null default '#1976D2',
  accent_color  text not null default '#FF9800',
  logo_url      text,
  support_email text,
  resource_categories text[] not null default array[
    'shelter','food','healthcare','mental_health',
    'substance_use','employment','legal','transportation'
  ],
  is_active     boolean not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

comment on table public.tenant_configs is
  'Per-state branding and configuration for the multi-tenant UI.';

-- ============================================================
-- GEOGRAPHY: STATES & COUNTIES
-- ============================================================

create table public.states (
  id         uuid primary key default uuid_generate_v4(),
  code       text not null unique,   -- 2-letter abbreviation
  name       text not null,
  created_at timestamptz not null default now()
);

comment on table public.states is 'US states reference table.';

create table public.counties (
  id         uuid primary key default uuid_generate_v4(),
  state_id   uuid not null references public.states(id) on delete cascade,
  name       text not null,
  fips_code  text unique,             -- 5-digit FIPS code
  created_at timestamptz not null default now(),
  unique (state_id, name)
);

comment on table public.counties is 'US counties reference table.';

create index idx_counties_state_id on public.counties(state_id);

-- ============================================================
-- RESOURCES
-- ============================================================

create type public.resource_status as enum ('active', 'inactive', 'unverified');

create table public.resources (
  id              uuid primary key default uuid_generate_v4(),
  state_id        uuid not null references public.states(id) on delete cascade,
  county_id       uuid references public.counties(id) on delete set null,
  name            text not null,
  category        text not null,          -- maps to tenant_configs.resource_categories
  sub_category    text,
  description     text,
  address_line1   text,
  address_line2   text,
  city            text,
  zip_code        text,
  phone           text,
  website         text,
  email           text,
  latitude        double precision,
  longitude       double precision,
  status          public.resource_status not null default 'unverified',

  -- Operating hours stored as JSONB for flexibility
  -- e.g. {"monday": {"open": "08:00", "close": "17:00"}, ...}
  hours           jsonb,

  -- Meal schedule for churches / non-profits (community powered)
  -- e.g. [{"day": "Wednesday", "time": "18:00", "description": "Hot dinner"}]
  meal_schedules  jsonb,

  -- Offline-first: last time the record was verified by a human
  last_verified_at timestamptz,
  last_verified_by uuid,                  -- references auth.users

  -- Tenant isolation: resources belong to one state
  -- Row Level Security uses state_id to enforce this
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

comment on table public.resources is
  'Homelessness resources (shelters, food programs, healthcare, etc.) indexed by state and county.';

create index idx_resources_state_id    on public.resources(state_id);
create index idx_resources_county_id   on public.resources(county_id);
create index idx_resources_category    on public.resources(category);
create index idx_resources_status      on public.resources(status);

-- Geo index for proximity searches
create index idx_resources_geo on public.resources(latitude, longitude)
  where latitude is not null and longitude is not null;

-- Full-text search index
create index idx_resources_fts on public.resources
  using gin(to_tsvector('english', coalesce(name,'') || ' ' || coalesce(description,'')));

-- ============================================================
-- OFFLINE SYNC SUPPORT
-- ============================================================

-- Tracks which resource records have changed so mobile clients can
-- perform incremental sync instead of downloading everything.
create table public.sync_checkpoints (
  id          uuid primary key default uuid_generate_v4(),
  state_code  text not null,
  table_name  text not null default 'resources',
  last_sync   timestamptz not null default now(),
  record_count integer,
  unique (state_code, table_name)
);

comment on table public.sync_checkpoints is
  'Tracks the latest sync timestamp per state so mobile clients can do incremental updates.';

-- ============================================================
-- AUTOMATIC updated_at TRIGGER
-- ============================================================

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger trg_resources_updated_at
  before update on public.resources
  for each row execute procedure public.set_updated_at();

create trigger trg_tenant_configs_updated_at
  before update on public.tenant_configs
  for each row execute procedure public.set_updated_at();

-- ============================================================
-- ROW LEVEL SECURITY (Multi-Tenant Isolation)
-- ============================================================

alter table public.tenant_configs  enable row level security;
alter table public.states          enable row level security;
alter table public.counties        enable row level security;
alter table public.resources       enable row level security;

-- Public read access for all authenticated and anonymous users
create policy "Public read tenant_configs"
  on public.tenant_configs for select using (true);

create policy "Public read states"
  on public.states for select using (true);

create policy "Public read counties"
  on public.counties for select using (true);

create policy "Public read active resources"
  on public.resources for select
  using (status = 'active');

-- State admins (identified by a custom JWT claim) can manage their own state data
create policy "State admin manages own resources"
  on public.resources for all
  using (
    state_id = (
      select id from public.states
      where code = (auth.jwt() ->> 'state_code')
    )
  )
  with check (
    state_id = (
      select id from public.states
      where code = (auth.jwt() ->> 'state_code')
    )
  );

create policy "State admin manages own tenant_config"
  on public.tenant_configs for update
  using (state_code = (auth.jwt() ->> 'state_code'))
  with check (state_code = (auth.jwt() ->> 'state_code'));
