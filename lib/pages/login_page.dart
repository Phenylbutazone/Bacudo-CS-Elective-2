import 'package:cs_elective_2/state/auth_notifier.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Sign in / sign up with email + password, or with Google via Supabase OAuth.
/// Successful sign-in is picked up by [authNotifier]; the router then
/// redirects away from `/login` automatically.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = false;
  bool _loading = false;
  String? _error;
  String? _info;

  @override
  void initState() {
    super.initState();
    authNotifier.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    authNotifier.removeListener(_onAuthChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Surfaces errors from the OAuth redirect (e.g. cancelled consent).
  void _onAuthChanged() {
    final err = authNotifier.lastError;
    if (err != null && mounted) {
      setState(() {
        _error = err;
        _loading = false;
      });
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _loading = true;
      _error = null;
      _info = null;
    });
    try {
      await action();
    } on AuthException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Something went wrong: $e';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await _run(() async {
      if (_isSignUp) {
        final signedIn = await authNotifier.signUpWithEmail(email, password);
        if (!signedIn) {
          _info = 'Check your inbox to confirm your email, then sign in.';
        }
      } else {
        await authNotifier.signInWithEmail(email, password);
      }
    });
  }

  Future<void> _signInWithGoogle() => _run(authNotifier.signInWithGoogle);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WiredScaffold(
      appBar: WiredAppBar(title: _isSignUp ? 'Sign Up' : 'Sign In'),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: WiredPanel(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Present yourself to the wired.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const WiredOrnament(),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: _loading ? null : _signInWithGoogle,
                      icon: const Text(
                        'G',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      label: const Text('Sign in with Google'),
                    ),
                    const WiredDivider(label: '— or —'),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      enabled: !_loading,
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      enabled: !_loading,
                      onFieldSubmitted: (_) => _submitEmail(),
                      validator: (v) => (v == null || v.length < 6)
                          ? 'At least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _loading ? null : _submitEmail,
                      child: _loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isSignUp ? 'Create account' : 'Sign in'),
                    ),
                    TextButton(
                      onPressed: _loading
                          ? null
                          : () => setState(() {
                                _isSignUp = !_isSignUp;
                                _error = null;
                                _info = null;
                              }),
                      child: Text(
                        _isSignUp
                            ? '[Have an account? Sign in]'
                            : '[New here? Create an account]',
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.error),
                      ),
                    ],
                    if (_info != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _info!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
