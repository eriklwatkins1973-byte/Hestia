# Hestia
Hestia is an open-source, multi-tenant mobile application designed to centralize and simplify access to homelessness resources. Named after the Greek goddess of the hearth and home, Hestia empowers states and counties to provide a unified directory of shelters, meal programs, and community support.


🚀 Getting Started
Follow these steps to deploy your own instance of the Hestia platform.

1. Prerequisites
Flutter SDK: ^3.0.0

Supabase Account: A free or professional project at supabase.com.

Git: To clone and manage the repository.

2. Environment Setup
Clone the repository and create a .env file in the root directory to connect your Flutter frontend to the Supabase backend:

# Example .env file
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-public-anon-key

3. Database Initialization
Navigate to the supabase/ folder in this repo and run the following scripts in your Supabase SQL Editor in this order:

tables.sql: Creates the states, counties, and resources tables.

auth_setup.sql: Sets up the caseworker roles.

rls_policies.sql: Enables Row Level Security to ensure data isolation between counties.

4. Running the App
Once your environment variables are set and the database is migrated, run the following commands:

flutter pub get
flutter run

🛠️ Configuration for New Jurisdictions
To add a new state or county to your instance:

Insert a new record into the states table.

The application will automatically detect the state_id and apply the corresponding branding and resource filters.

