import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../widgets/app_buttons.dart';
import '../../../widgets/section_title.dart';
import '../providers/auth_provider.dart';
import '../validators.dart';
import 'auth_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
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

    final email = _emailController.text.trim();
    final result = await auth.register(
      _nameController.text.trim(),
      email,
      _passwordController.text,
    );
    if (!mounted) return;

    // signedIn: the router guard moves us to Home.
    if (result == RegisterResult.createdOnly) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created. Please sign in.')),
      );
      context.go(
        Uri(path: '/login', queryParameters: {'email': email}).toString(),
      );
    }
  }

  void _toLogin() {
    context.read<AuthProvider>().clearError();
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return AuthScaffold(
      title: 'Create account',
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
                  label: 'Name',
                  hint: 'Your name',
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.name],
                  validator: AuthValidators.name,
                  onSubmitted: (_) => _emailFocus.requestFocus(),
                ),
                const SizedBox(height: 20),
                LabeledField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: AuthValidators.email,
                  onSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                const SizedBox(height: 20),
                LabeledField(
                  label: 'Password',
                  hint: 'At least 8 characters',
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscure: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: AuthValidators.newPassword,
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
          label: 'Create account',
          loading: auth.isLoading,
          onPressed: _submit,
        ),
        const SizedBox(height: 20),
        AuthSwitchText(
          prompt: 'Already have an account?',
          action: 'Sign in',
          onTap: _toLogin,
        ),
      ],
    );
  }
}
