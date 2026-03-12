import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../controllers/login_controller.dart';

class LoginFormCard extends GetView<LoginController> {
  const LoginFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          controller.stagger(
            1,
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'بيانات الحساب',
                      style: TextStyle(
                        color: Color(0xFF0F1D14),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'البريد الإلكتروني وكلمة المرور',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.4),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          controller.stagger(
            2,
            Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.black.withValues(alpha: 0.08)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'أدخل بياناتك',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.3),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: Colors.black.withValues(alpha: 0.08)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          controller.stagger(
            3,
            PremiumInput(
              controller: controller.emailController,
              label: 'البريد الإلكتروني',
              hint: 'example@ridex.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 14),
          controller.stagger(
            4,
            Obx(
              () => PremiumInput(
                controller: controller.passwordController,
                label: 'كلمة المرور',
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                obscure: controller.obscure.value,
                suffixIcon: GestureDetector(
                  onTap: controller.toggleObscure,
                  child: Icon(
                    controller.obscure.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.black.withValues(alpha: 0.35),
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          controller.stagger(
            4,
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                ),
                child: const Text('نسيت كلمة المرور؟'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          controller.stagger(
            5,
            Obx(
              () => LoginButton(
                loading: controller.loading.value,
                onLogin: controller.handleLogin,
              ),
            ),
          ),
          const SizedBox(height: 12),
          controller.stagger(
            6,
            OutlinedButton(
              onPressed: controller.backToRoot,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF3D4D44),
                minimumSize: const Size.fromHeight(52),
                side: BorderSide(color: Colors.black.withValues(alpha: 0.10)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_rounded, size: 16),
                  SizedBox(width: 6),
                  Text('العودة', style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumInput extends StatefulWidget {
  const PremiumInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  @override
  State<PremiumInput> createState() => _PremiumInputState();
}

class _PremiumInputState extends State<PremiumInput>
    with SingleTickerProviderStateMixin {
  late final AnimationController focusController;
  late final Animation<double> borderOpacity;
  late final Animation<double> iconScale;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    borderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: focusController, curve: Curves.easeOut),
    );
    iconScale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: focusController, curve: Curves.easeOut),
    );
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        focusController.forward();
      } else {
        focusController.reverse();
      }
    });
  }

  @override
  void dispose() {
    focusController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Color(0xFF0F1D14),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: focusController,
          builder: (_, _) {
            return Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F9F7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Color.lerp(
                    const Color(0xFFE3EBE6),
                    AppColors.primary,
                    borderOpacity.value,
                  )!,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Transform.scale(
                    scale: iconScale.value,
                    child: Icon(
                      widget.icon,
                      color: Color.lerp(
                        Colors.black.withValues(alpha: 0.3),
                        AppColors.primary,
                        borderOpacity.value,
                      ),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: focusNode,
                      obscureText: widget.obscure,
                      keyboardType: widget.keyboardType,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(
                          color: Colors.black.withValues(alpha: 0.28),
                        ),
                      ),
                    ),
                  ),
                  if (widget.suffixIcon != null) ...[
                    widget.suffixIcon!,
                    const SizedBox(width: 14),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class LoginButton extends StatefulWidget {
  const LoginButton({
    super.key,
    required this.loading,
    required this.onLogin,
  });

  final bool loading;
  final Future<void> Function() onLogin;

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController pressController;
  late final Animation<double> scale;

  @override
  void initState() {
    super.initState();
    pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    scale = Tween<double>(begin: 1.0, end: 0.96).animate(pressController);
  }

  @override
  void dispose() {
    pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => pressController.forward(),
      onTapUp: (_) async {
        pressController.reverse();
        await widget.onLogin();
      },
      onTapCancel: () => pressController.reverse(),
      child: AnimatedBuilder(
        animation: scale,
        builder: (_, child) =>
            Transform.scale(scale: scale.value, child: child),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
