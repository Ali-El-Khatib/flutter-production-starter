import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Form component for user login credentials.
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.initialEmail,
  });

  final void Function(String email, String password) onSubmit;
  final bool isLoading;
  final String? initialEmail;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
        text: widget.initialEmail ?? 'developer@example.com');
    _passwordController = TextEditingController(text: 'secret123');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmitted() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          AppSpacing.gapV16,
          AppTextField(
            controller: _passwordController,
            label: 'Password',
            hintText: '••••••••',
            isPassword: true,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSubmitted(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          AppSpacing.gapV24,
          AppButton(
            text: 'Sign In',
            isLoading: widget.isLoading,
            onPressed: _handleSubmitted,
          ),
        ],
      ),
    );
  }
}
