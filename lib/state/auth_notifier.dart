import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Deep link Supabase redirects back to after the Google OAuth flow on
/// mobile/desktop. Must match the Android intent-filter, the iOS
/// `CFBundleURLSchemes` entry, and an allowed Redirect URL in
/// Supabase Dashboard → Authentication → URL Configuration.
const String kAuthRedirectUrl = 'io.supabase.cselective2://login-callback/';

/// Initializes Supabase from `.env`. Call once before `runApp`.
Future<void> initSupabase() async {
  await dotenv.load(fileName: '.env');

  final url = dotenv.maybeGet('SUPABASE_URL');
  final anonKey = dotenv.maybeGet('SUPABASE_ANON_KEY');
  if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
    throw StateError(
      'Missing SUPABASE_URL / SUPABASE_ANON_KEY. '
      'Copy .env.example to .env and fill in your Supabase project values.',
    );
  }

  await Supabase.initialize(url: url, publishableKey: anonKey);
}

/// Exposes the Supabase session as a [ChangeNotifier] so go_router can
/// re-run its redirect whenever the user signs in or out.
class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._auth) {
    _subscription = _auth.onAuthStateChange.listen(
      (_) => notifyListeners(),
      onError: (Object error) {
        // Errors from the OAuth callback (e.g. user cancelled consent).
        lastError = error is AuthException ? error.message : '$error';
        notifyListeners();
      },
    );
  }

  final GoTrueClient _auth;
  late final StreamSubscription<AuthState> _subscription;

  /// Most recent error surfaced by the auth state stream, if any.
  String? lastError;

  bool get isSignedIn => _auth.currentSession != null;

  User? get user => _auth.currentUser;

  /// Starts the Google OAuth flow. On web this redirects the page; on
  /// mobile it opens the browser and returns via [kAuthRedirectUrl].
  Future<void> signInWithGoogle() async {
    lastError = null;
    await _auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : kAuthRedirectUrl,
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    lastError = null;
    await _auth.signInWithPassword(email: email, password: password);
  }

  /// Returns `true` if a session was created immediately, `false` if the
  /// project requires email confirmation first.
  Future<bool> signUpWithEmail(String email, String password) async {
    lastError = null;
    final res = await _auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: kIsWeb ? null : kAuthRedirectUrl,
    );
    return res.session != null;
  }

  Future<void> signOut() => _auth.signOut();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// App-wide auth state. Created in `main()` after [initSupabase].
late final AuthNotifier authNotifier;
