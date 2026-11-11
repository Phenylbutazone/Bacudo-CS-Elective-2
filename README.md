# cs_elective_2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Authentication (Supabase + Google)

The app requires sign-in (email/password or **Sign in with Google**) via Supabase.

1. Copy `.env.example` to `.env` and set `SUPABASE_URL` and `SUPABASE_ANON_KEY`
   (Supabase Dashboard → Project Settings → API Keys). `.env` is gitignored.
2. Enable Google: Supabase Dashboard → Authentication → Sign In / Providers → Google,
   and paste the Client ID/Secret of a Google Cloud OAuth client (type "Web application")
   whose Authorized redirect URI is `https://<project-ref>.supabase.co/auth/v1/callback`.
3. Supabase Dashboard → Authentication → URL Configuration → Redirect URLs, add:
   - `io.supabase.cselective2://login-callback/` (Android / iOS deep link)
   - your web origin, e.g. `http://localhost:3000` (run with `flutter run -d chrome --web-port 3000`)
