import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Presentation form widget for handling email and password input.
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isLoading;
  final void Function(String email, String password) onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(text: 'developer@antigravity.dev');
  final _passwordController = TextEditingController(text: 'Password123!');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _emailController.text.trim(),
        _passwordController.text.trim(),
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
            label: 'Email Address',
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
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
            prefixIcon: const Icon(Icons.lock_outline),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          AppSpacing.gapV24,
          AppButton(
            text: 'Sign In',
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _handleSubmit,
          ),
        ],
      ),
    );
  }
}
