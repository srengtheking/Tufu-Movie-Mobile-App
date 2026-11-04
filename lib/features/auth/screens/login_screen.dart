import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_buttons.dart';
import '../../../widgets/section_title.dart';
import '../providers/auth_provider.dart';
import '../validators.dart';
import 'auth_scaffold.dart';

class LoginScreen extends StatefulWidget {
  /// Pre-fills the email, e.g. right after creating an account.
  final String? initialEmail;

  const LoginScreen({super.key, this.initialEmail});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _passwordFocus.requestFocus(),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    if (auth.isLoading) return;
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }
    FocusScope.of(context).unfocus();
    // On success the router guard moves us to Home.
    await auth.login(_emailController.text.trim(), _passwordController.text);
  }

  void _toRegister() {
    context.read<AuthProvider>().clearError();
    context.push('/register');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final p = context.palette;

    return AuthScaffold(
      title: 'Sign in',
      children: [
        Form(
          key: _formKey,
          autovalidateMode: _autovalidate,
          onChanged: auth.clearError,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LabeledField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: AuthValidators.email,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                const SizedBox(height: 20),
                LabeledField(
                  label: 'Password',
                  hint: 'Password',
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscure: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: AuthValidators.loginPassword,
                  onSubmitted: (_) => _submit(),
                  suffix: PasswordVisibilityButton(
                    obscured: _obscurePassword,
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ],
            ),
          ),
        ),
        AuthErrorBanner(message: auth.errorMessage),
        const SizedBox(height: 24),
        PrimaryButton(
          label: 'Sign in',
          loading: auth.isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password reset is coming soon.')),
              );
            },
            child: Text(
              'Forgot password?',
              style: TextStyle(color: p.link, fontSize: 15),
            ),
          ),
        ),
        AuthSwitchText(
          prompt: 'New to Tufu?',
          action: 'Sign up',
          onTap: _toRegister,
        ),
      ],
    );
  }
}
