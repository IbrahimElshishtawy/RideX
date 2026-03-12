import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/home_sections.dart';

class HomePreviewScreen extends GetView<HomeController> {
  const HomePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F6F8),
          body: Column(
            children: [
              HomeHeader(onSearchTap: controller.goToLogin),
              const Expanded(child: HomeContent()),
            ],
          ),
          bottomNavigationBar: const HomeBottomNav(),
        ),
      ),
    );
  }
}
