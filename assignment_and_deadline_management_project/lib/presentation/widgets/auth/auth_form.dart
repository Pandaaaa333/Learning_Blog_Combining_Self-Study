import 'package:flutter/material.dart';
import 'package:fe_admin_web/presentation/screens/admin_layout_screen.dart';
import 'package:fe_admin_web/presentation/widgets/auth/auth_fields.dart';
import 'package:fe_admin_web/presentation/widgets/auth/auth_header.dart';
import 'package:fe_admin_web/presentation/widgets/auth/submit_button.dart';
import 'package:provider/provider.dart';
import 'package:fe_admin_web/data/providers/auth_provider.dart';

class AuthForm extends StatefulWidget {
  final bool isLogin;
  final VoidCallback toggleForm;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.toggleForm,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (widget.isLogin) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.login(
          _emailController.text,
          _passwordController.text,
        );

        if (success && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminLayoutScreen()),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(authProvider.error ?? 'Login failed')),
          );
        }
      } else {
        // Implement register later if needed or mock it
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminLayoutScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthHeader(isLogin: widget.isLogin),
                const SizedBox(height: 32),
                AuthFields(
                  isLogin: widget.isLogin,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                const SizedBox(height: 8),
                SizedBox(height: widget.isLogin ? 16 : 32),
                SubmitButton(
                  isLogin: widget.isLogin,
                  onSubmit: _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
