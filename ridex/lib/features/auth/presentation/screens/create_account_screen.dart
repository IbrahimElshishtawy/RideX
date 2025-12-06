// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  bool agreeTerms = false;
  bool showPassword = false;
  bool showConfirm = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // -------- Title --------
                Center(
                  child: Text(
                    "Create an Account",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                Center(
                  child: Text(
                    "Join now to start your ride.",
                    style: theme.textTheme.bodyMedium,
                  ),
                ),

                const SizedBox(height: 26),

                // -------- Full Name --------
                _buildTextField(
                  controller: name,
                  label: "Enter your full name",
                ),

                const SizedBox(height: 16),

                // -------- Email --------
                _buildTextField(
                  controller: email,
                  label: "Enter your email address",
                ),

                const SizedBox(height: 16),

                // -------- Password --------
                _buildTextField(
                  controller: password,
                  label: "Create a password",
                  isPassword: true,
                  show: showPassword,
                  toggle: () {
                    setState(() => showPassword = !showPassword);
                  },
                ),

                const SizedBox(height: 16),

                // -------- Confirm Password --------
                _buildTextField(
                  controller: confirm,
                  label: "Re-enter your password",
                  isPassword: true,
                  show: showConfirm,
                  toggle: () {
                    setState(() => showConfirm = !showConfirm);
                  },
                ),

                const SizedBox(height: 18),

                // -------- Terms Row --------
                InkWell(
                  onTap: () {
                    setState(() => agreeTerms = !agreeTerms);
                  },
                  child: Row(
                    children: [
                      Icon(
                        agreeTerms ? Icons.check_circle : Icons.circle_outlined,
                        color: agreeTerms
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: [
                              const TextSpan(text: "I agree to the Terms & "),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // -------- OR Divider --------
                Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 1, color: theme.dividerColor),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(
                      child: Divider(thickness: 1, color: theme.dividerColor),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Center(
                  child: Text(
                    "SIGN UP With",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // -------- Social Buttons --------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Image.asset("assets/icon/google.png"),
                    ),
                    const SizedBox(width: 22),
                    // Facebook
                    SizedBox(
                      width: 44,
                      height: 44,
                      child: Image.asset("assets/icon/facebook.png"),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // -------- Sign Up Button --------
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!agreeTerms) return;
                      context.go("/verify");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Widget Builder ----------------

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool show = false,
    VoidCallback? toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !show : false,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(show ? Icons.visibility : Icons.visibility_off),
                onPressed: toggle,
              )
            : null,
      ),
    );
  }
}
