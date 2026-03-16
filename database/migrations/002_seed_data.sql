-- Migration 002: Seed Data
-- Sample tenant configurations and reference data

-- ============================================================
-- STATES (all 50 US states + DC)
-- ============================================================

insert into public.states (code, name) values
  ('AL', 'Alabama'), ('AK', 'Alaska'), ('AZ', 'Arizona'), ('AR', 'Arkansas'),
  ('CA', 'California'), ('CO', 'Colorado'), ('CT', 'Connecticut'), ('DE', 'Delaware'),
  ('DC', 'District of Columbia'), ('FL', 'Florida'), ('GA', 'Georgia'), ('HI', 'Hawaii'),
  ('ID', 'Idaho'), ('IL', 'Illinois'), ('IN', 'Indiana'), ('IA', 'Iowa'),
  ('KS', 'Kansas'), ('KY', 'Kentucky'), ('LA', 'Louisiana'), ('ME', 'Maine'),
  ('MD', 'Maryland'), ('MA', 'Massachusetts'), ('MI', 'Michigan'), ('MN', 'Minnesota'),
  ('MS', 'Mississippi'), ('MO', 'Missouri'), ('MT', 'Montana'), ('NE', 'Nebraska'),
  ('NV', 'Nevada'), ('NH', 'New Hampshire'), ('NJ', 'New Jersey'), ('NM', 'New Mexico'),
  ('NY', 'New York'), ('NC', 'North Carolina'), ('ND', 'North Dakota'), ('OH', 'Ohio'),
  ('OK', 'Oklahoma'), ('OR', 'Oregon'), ('PA', 'Pennsylvania'), ('RI', 'Rhode Island'),
  ('SC', 'South Carolina'), ('SD', 'South Dakota'), ('TN', 'Tennessee'), ('TX', 'Texas'),
  ('UT', 'Utah'), ('VT', 'Vermont'), ('VA', 'Virginia'), ('WA', 'Washington'),
  ('WV', 'West Virginia'), ('WI', 'Wisconsin'), ('WY', 'Wyoming')
on conflict (code) do nothing;

-- ============================================================
-- SAMPLE TENANT CONFIGURATIONS
-- ============================================================

insert into public.tenant_configs
  (state_code, state_name, primary_color, accent_color, support_email, resource_categories)
values
  (
    'TX', 'Texas',
    '#BF5700', '#333F48',
    'support-tx@hestia.app',
    array['shelter','food','healthcare','mental_health','substance_use',
          'employment','legal','transportation','church_meal']
  ),
  (
    'CA', 'California',
    '#003DA5', '#FDB913',
    'support-ca@hestia.app',
    array['shelter','food','healthcare','mental_health','substance_use',
          'employment','legal','transportation','clothing']
  ),
  (
    'NY', 'New York',
    '#003087', '#E31837',
    'support-ny@hestia.app',
    array['shelter','food','healthcare','mental_health','substance_use',
          'employment','legal','transportation','drop_in_center']
  )
on conflict (state_code) do nothing;

-- ============================================================
-- SAMPLE COUNTIES (Texas - for demo)
-- ============================================================

with tx as (select id from public.states where code = 'TX')
insert into public.counties (state_id, name, fips_code)
select tx.id, county.name, county.fips
from tx,
  (values
    ('Harris County',   '48201'),
    ('Dallas County',   '48113'),
    ('Tarrant County',  '48439'),
    ('Bexar County',    '48029'),
    ('Travis County',   '48453'),
    ('Collin County',   '48085'),
    ('Denton County',   '48121'),
    ('El Paso County',  '48141'),
    ('Fort Bend County','48157'),
    ('Montgomery County','48339')
  ) as county(name, fips)
on conflict (state_id, name) do nothing;

-- ============================================================
-- SAMPLE RESOURCES (Harris County, TX - for demo)
-- ============================================================

with harris as (
  select c.id as county_id, s.id as state_id
  from public.counties c
  join public.states s on s.id = c.state_id
  where s.code = 'TX' and c.name = 'Harris County'
)
insert into public.resources
  (state_id, county_id, name, category, sub_category, description,
   address_line1, city, zip_code, phone, website,
   latitude, longitude, status,
   hours, meal_schedules, last_verified_at)
select
  h.state_id, h.county_id,
  r.name, r.category, r.sub_category, r.description,
  r.address, r.city, r.zip, r.phone, r.website,
  r.lat, r.lon, 'active'::public.resource_status,
  r.hours::jsonb, r.meals::jsonb, now()
from harris h,
  (values
    (
      'Star of Hope Mission',
      'shelter', 'emergency_shelter',
      'Emergency shelter and rehabilitation programs for men, women, and families.',
      '6897 Ardmore St', 'Houston', '77054', '(713) 748-0700',
      'https://www.sohmission.org',
      29.6907, -95.4095,
      '{"monday":{"open":"08:00","close":"22:00"},"tuesday":{"open":"08:00","close":"22:00"},"wednesday":{"open":"08:00","close":"22:00"},"thursday":{"open":"08:00","close":"22:00"},"friday":{"open":"08:00","close":"22:00"},"saturday":{"open":"08:00","close":"22:00"},"sunday":{"open":"08:00","close":"22:00"}}',
      '[]'
    ),
    (
      'Houston Food Bank',
      'food', 'food_pantry',
      'Largest food bank in the US, distributing millions of meals annually.',
      '535 Portwall St', 'Houston', '77029', '(713) 223-3700',
      'https://www.houstonfoodbank.org',
      29.7604, -95.3109,
      '{"monday":{"open":"08:00","close":"17:00"},"tuesday":{"open":"08:00","close":"17:00"},"wednesday":{"open":"08:00","close":"17:00"},"thursday":{"open":"08:00","close":"17:00"},"friday":{"open":"08:00","close":"17:00"},"saturday":{"open":"08:00","close":"12:00"},"sunday":null}',
      '[]'
    ),
    (
      'Chapelwood United Methodist — Community Meals',
      'food', 'church_meal',
      'Weekly hot meal open to anyone in need. No ID required.',
      '11140 Greenbay St', 'Houston', '77024', '(713) 465-3467',
      'https://www.chapelwood.org',
      29.7732, -95.5044,
      '{"wednesday":{"open":"17:30","close":"19:00"}}',
      '[{"day":"Wednesday","time":"18:00","description":"Hot dinner served – all welcome, no ID required"}]'
    ),
    (
      'The Beacon — Christ Church Houston',
      'food', 'church_meal',
      'Daily lunch service and resource navigation for people experiencing homelessness.',
      '3300 Main St', 'Houston', '77002', '(713) 526-6665',
      'https://www.cchouston.org/beacon',
      29.7467, -95.3718,
      '{"monday":{"open":"10:00","close":"14:00"},"tuesday":{"open":"10:00","close":"14:00"},"wednesday":{"open":"10:00","close":"14:00"},"thursday":{"open":"10:00","close":"14:00"},"friday":{"open":"10:00","close":"14:00"}}',
      '[{"day":"Monday","time":"12:00","description":"Free lunch"},{"day":"Tuesday","time":"12:00","description":"Free lunch"},{"day":"Wednesday","time":"12:00","description":"Free lunch"},{"day":"Thursday","time":"12:00","description":"Free lunch"},{"day":"Friday","time":"12:00","description":"Free lunch"}]'
    ),
    (
      'Harris Center for Mental Health',
      'mental_health', 'crisis_line',
      '24/7 mental health crisis services and outpatient programs.',
      '9401 SW Freeway', 'Houston', '77074', '(713) 970-7000',
      'https://www.harriscenteronline.org',
      29.6884, -95.5255,
      '{"monday":{"open":"00:00","close":"23:59"},"tuesday":{"open":"00:00","close":"23:59"},"wednesday":{"open":"00:00","close":"23:59"},"thursday":{"open":"00:00","close":"23:59"},"friday":{"open":"00:00","close":"23:59"},"saturday":{"open":"00:00","close":"23:59"},"sunday":{"open":"00:00","close":"23:59"}}',
      '[]'
    )
  ) as r(name, category, sub_category, description, address, city, zip, phone, website, lat, lon, hours, meals)
on conflict do nothing;
