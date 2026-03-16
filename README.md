# Hestia 🏠
Hestia is an open-source, multi-tenant mobile application designed to centralize and simplify access to homelessness resources. Named after the Greek goddess of the hearth and home, Hestia empowers states and counties to provide a unified directory of shelters, meal programs, and community support.

[![CI](https://github.com/eriklwatkins1973-byte/Hestia/actions/workflows/ci.yml/badge.svg)](https://github.com/eriklwatkins1973-byte/Hestia/actions/workflows/ci.yml)

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 📍 **Hyper-Local** | Filter resources by **state and county** to find exactly what's available nearby |
| 🎨 **Multi-Tenant** | Each state customizes the interface with its own **branding, colors, and resource categories** |
| ⛪ **Community Powered** | Special focus on **meal schedules from churches and local non-profits** |
| 📱 **Offline First** | Hive-backed local cache ensures users can access critical info even with **no connectivity** |
| 🔒 **Secure** | Supabase Row Level Security ensures each state admin only manages their own data |

---

## 🗺️ Project Vision

Homelessness resources are often fragmented across dozens of websites and PDF flyers. Hestia provides a single source of truth that is:

- **Scalable** — One codebase that serves all 50 states
- **Accessible** — A simple, high-contrast UI for users in crisis
- **Collaborative** — A platform where state admins and local volunteers can keep data fresh

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile App | Flutter (iOS, Android & Web) |
| Backend / Database | Supabase (PostgreSQL + Row Level Security) |
| Local Cache | Hive (offline-first) |
| State Management | Riverpod |
| Navigation | GoRouter |
| CI/CD | GitHub Actions |

---

## 📁 Repository Structure

```
hestia/
├── mobile_app/          # Flutter application (iOS, Android, Web)
│   ├── lib/
│   │   ├── models/      # Resource, StateInfo, County, TenantConfig
│   │   ├── screens/     # HomeScreen, ResourceListScreen, ResourceDetailScreen
│   │   ├── services/    # SupabaseService (online), OfflineCacheService (Hive)
│   │   ├── widgets/     # ResourceCard, OfflineBanner
│   │   └── theme/       # Dynamic multi-tenant theme builder
│   └── test/            # Unit tests
├── backend/
│   └── functions/       # Supabase Edge Functions (Deno/TypeScript)
│       ├── get-resources/       # Paginated resource query w/ state/county filter
│       └── get-tenant-config/   # Per-state branding config
├── database/
│   └── migrations/      # PostgreSQL schema + seed data
├── assets/
│   └── themes/          # Per-state branding assets (colors, logos)
└── docs/                # Technical documentation & API reference
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.19
- A [Supabase](https://supabase.com) project

### Database Setup

```bash
# Apply migrations in order
psql "$DATABASE_URL" -f database/migrations/001_initial_schema.sql
psql "$DATABASE_URL" -f database/migrations/002_seed_data.sql
```

### Running the Mobile App

```bash
cd mobile_app
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

### Running Tests

```bash
cd mobile_app
flutter test test/unit_test.dart
```

### Deploying Edge Functions

```bash
supabase functions deploy get-resources --project-ref <your-ref>
supabase functions deploy get-tenant-config --project-ref <your-ref>
```

---

## 🌐 API Reference

See [`docs/technical_documentation.md`](docs/technical_documentation.md) for the full API reference.

**Edge function endpoints:**

| Endpoint | Description |
|----------|-------------|
| `GET /get-resources?state_code=TX&county_id=...&category=food` | Filtered, paginated resource list |
| `GET /get-tenant-config?state_code=TX` | State branding & category config |

---

## 🤝 Contributing

We welcome contributors of all skill levels! Whether you are a coder, a data researcher, or a UI designer, we need your help.

1. Check the [Issues](../../issues) tab for open tasks.
2. Fork the repository.
3. Create a feature branch: `git checkout -b feature/NewResourceCategory`
4. Submit a Pull Request.

### Adding a New State

1. Insert a row into the `states` table.
2. Insert a row into `tenant_configs` with branding colors and categories.
3. Add county data to `counties`.
4. Add resource data to `resources`.
5. Optionally, add logo/splash assets under `assets/themes/<STATE_CODE>/`.

---

## ⚖️ License

This project is licensed under the [MIT License](LICENSE).

---

## 🙏 Acknowledgments

- Inspired by the need for better resource coordination in local communities.
- Built with love for the [211](https://www.211.org/) and [Open Referral](https://openreferral.org/) standards.
