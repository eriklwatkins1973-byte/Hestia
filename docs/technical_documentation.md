# Hestia — Technical Documentation

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Database Schema](#database-schema)
3. [Multi-Tenant Design](#multi-tenant-design)
4. [API Reference](#api-reference)
5. [Offline-First Strategy](#offline-first-strategy)
6. [Mobile App](#mobile-app)
7. [Contributing Data](#contributing-data)

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Mobile App                       │
│  iOS  │  Android  │  Web                                     │
│                                                             │
│  HomeScreen ──► ResourceListScreen ──► ResourceDetailScreen │
│  (state/county filter)  (category filter)   (contact/hours) │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTPS / Supabase Realtime
┌────────────────────────▼────────────────────────────────────┐
│                   Supabase Backend                           │
│                                                             │
│  ┌─────────────────┐   ┌────────────────────────────────┐  │
│  │  Edge Functions  │   │  PostgreSQL (RLS-secured)      │  │
│  │  get-resources   │   │  states / counties / resources  │  │
│  │  get-tenant-cfg  │   │  tenant_configs / sync_check   │  │
│  └─────────────────┘   └────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

**Key design decisions:**

- **Row Level Security (RLS)** ensures that state admins can only modify
  data belonging to their own state, identified by a `state_code` JWT claim.
- **Edge Functions** add a thin, cacheable API layer on top of the database
  with pagination and incremental-sync support.
- **Hive** (local key-value store) caches all data on-device so the app
  remains fully functional without internet access.

---

## Database Schema

See [`database/migrations/001_initial_schema.sql`](../database/migrations/001_initial_schema.sql)
for the full schema.

### Core Tables

| Table | Purpose |
|-------|---------|
| `states` | US states reference (code, name) |
| `counties` | US counties, linked to states |
| `resources` | The primary resource directory |
| `tenant_configs` | Per-state branding and feature flags |
| `sync_checkpoints` | Offline sync watermark tracking |

### `resources` Key Columns

| Column | Type | Description |
|--------|------|-------------|
| `state_id` | UUID | FK → states. Used for RLS isolation. |
| `county_id` | UUID? | FK → counties. Optional hyper-local filter. |
| `category` | text | e.g. `shelter`, `food`, `church_meal` |
| `hours` | jsonb | `{"monday": {"open": "08:00", "close": "22:00"}, ...}` |
| `meal_schedules` | jsonb | `[{"day": "Wednesday", "time": "18:00", "description": "..."}]` |
| `status` | enum | `active` \| `inactive` \| `unverified` |

---

## Multi-Tenant Design

Each state is an isolated tenant:

1. **Database**: RLS policies restrict writes to the tenant's own rows.
   State admins receive a JWT that includes a `state_code` claim.
2. **Branding**: `tenant_configs` stores `primary_color`, `accent_color`,
   `logo_url`, and the list of enabled `resource_categories`.
3. **Mobile App**: On startup the app reads `tenant_configs` for the selected
   state and rebuilds the Flutter `ThemeData` with the tenant's colours.

### Adding a New State

1. Insert a row into `states`.
2. Insert a row into `tenant_configs` with the desired branding.
3. Add county data to `counties`.
4. Add resource data to `resources`.
5. (Optional) Add logo/splash assets to `assets/themes/<STATE_CODE>/`.

---

## API Reference

Base URL: `https://<project>.supabase.co/functions/v1`

### `GET /get-resources`

Returns paginated active resources for a state.

**Query Parameters**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `state_code` | ✅ | 2-letter state code (e.g. `TX`) |
| `county_id` | ❌ | UUID — filter to a single county |
| `category` | ❌ | Category slug (e.g. `shelter`, `food`) |
| `updated_after` | ❌ | ISO-8601 timestamp — incremental sync |
| `page` | ❌ | Page number (default: 1) |
| `page_size` | ❌ | Records per page (default: 50, max: 200) |

**Response**

```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Star of Hope Mission",
      "category": "shelter",
      "city": "Houston",
      "phone": "(713) 748-0700",
      "hours": { "monday": { "open": "08:00", "close": "22:00" } },
      "meal_schedules": [],
      ...
    }
  ],
  "meta": {
    "page": 1,
    "page_size": 50,
    "total": 142,
    "state_code": "TX"
  }
}
```

---

### `GET /get-tenant-config`

Returns branding and category configuration for a state.

**Query Parameters**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `state_code` | ✅ | 2-letter state code |

**Response**

```json
{
  "data": {
    "state_code": "TX",
    "state_name": "Texas",
    "primary_color": "#BF5700",
    "accent_color": "#333F48",
    "logo_url": null,
    "support_email": "support-tx@hestia.app",
    "resource_categories": ["shelter", "food", "church_meal", ...]
  }
}
```

---

## Offline-First Strategy

The app uses a **cache-then-network** pattern:

1. On first load: fetch from Supabase and store in Hive boxes.
2. On subsequent loads: serve from Hive immediately, then refresh in the background.
3. When offline: serve from Hive only, and display a red banner.
4. Incremental sync: pass `updated_after` equal to the last sync timestamp to
   fetch only changed records.

### Hive Boxes

| Box | Contents |
|-----|----------|
| `resources` | `Resource` typed objects |
| `states` | Raw JSON maps |
| `counties` | Raw JSON maps |
| `tenant_configs` | Raw JSON maps |
| `meta` | Sync timestamps (`last_sync_<STATE_CODE>`) |

---

## Mobile App

### Structure

```
mobile_app/lib/
├── main.dart               # Entry point, initialises Hive & Supabase
├── router.dart             # GoRouter configuration
├── models/
│   ├── resource.dart       # Resource data model (Hive-typed)
│   ├── location.dart       # StateInfo and County models
│   └── tenant_config.dart  # Per-state branding model
├── services/
│   ├── supabase_service.dart   # All Supabase queries + Riverpod providers
│   └── offline_cache_service.dart  # Hive read/write helpers
├── screens/
│   ├── home_screen.dart        # State & county picker
│   ├── resource_list_screen.dart   # Filtered resource list
│   └── resource_detail_screen.dart # Full resource detail
├── widgets/
│   ├── resource_card.dart      # Summary card widget
│   └── offline_banner.dart     # Offline status indicator
└── theme/
    └── app_theme.dart          # Dynamic theme builder + category metadata
```

### Running Locally

```bash
cd mobile_app
flutter pub get

# Set environment variables (or use --dart-define)
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

### Running Tests

```bash
cd mobile_app
flutter test test/unit_test.dart
```

---

## Contributing Data

See the main [README](../README.md) for contribution guidelines.

To add or update resource data for your county:

1. Use the Supabase dashboard (ask your state admin for access), or
2. Submit a CSV following the [Open Referral HSDS standard](https://openreferral.org/),
   and open a GitHub issue requesting an import.

### Resource Categories

| Slug | Label |
|------|-------|
| `shelter` | Shelter |
| `food` | Food |
| `church_meal` | Church Meal |
| `healthcare` | Healthcare |
| `mental_health` | Mental Health |
| `substance_use` | Substance Use |
| `employment` | Employment |
| `legal` | Legal Aid |
| `transportation` | Transportation |
| `clothing` | Clothing |
| `drop_in_center` | Drop-In Center |
