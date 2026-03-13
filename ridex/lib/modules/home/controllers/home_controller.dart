import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController staggerController;
  late final AnimationController ambientController;

  final RxInt selectedCategory = 0.obs;
  final RxInt activeNavIndex = 0.obs;

  final categories = const [
    HomeCategory(icon: Icons.fastfood_rounded, label: 'طعام'),
    HomeCategory(icon: Icons.local_grocery_store_rounded, label: 'ماركت'),
    HomeCategory(icon: Icons.local_offer_rounded, label: 'عروض'),
    HomeCategory(icon: Icons.coffee_rounded, label: 'مشروبات'),
  ];

  final featuredRestaurants = const [
    FeaturedRestaurant(
      imagePath: 'assets/image/image2.png',
      title: 'Blaban',
      subtitle: 'حلويات وآيس كريم',
      delivery: '15-25 دقيقة',
      rating: 4.9,
      badge: 'الأكثر طلباً',
      badgeColor: Color(0xFFFF6B35),
    ),
    FeaturedRestaurant(
      imagePath: 'assets/image/image3.png',
      title: 'عوايد',
      subtitle: 'مخبوزات ومعجنات',
      delivery: '15-20 دقيقة',
      rating: 4.7,
      badge: 'جديد',
      badgeColor: Color(0xFF20B05C),
    ),
  ];

  final offerRestaurants = const [
    OfferRestaurant(
      title: 'ميدان الشام',
      subtitle: 'سوري',
      imagePath: 'assets/image/image1.png',
    ),
    OfferRestaurant(
      title: 'أبو يونس',
      subtitle: 'مشويات',
      imagePath: 'assets/image/image2.png',
    ),
    OfferRestaurant(
      title: 'مطعم عواد',
      subtitle: 'مأكولات',
      imagePath: 'assets/image/image3.png',
    ),
    OfferRestaurant(
      title: 'عم صلاح',
      subtitle: 'مأكولات',
      imagePath: 'assets/image/image2.png',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);
  }

  void goToLogin() => Get.toNamed('/login');

  void selectCategory(int index) {
    selectedCategory.value = index;
    goToLogin();
  }

  void selectNav(int index) {
    activeNavIndex.value = index;
    if (index != 0) {
      goToLogin();
    }
  }

  Animation<double> fade(double start, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: staggerController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> slide(
    double start,
    double end, {
    Offset from = const Offset(0, 0.18),
  }) {
    return Tween<Offset>(begin: from, end: Offset.zero).animate(
      CurvedAnimation(
        parent: staggerController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  Animation<double> breathe({
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: ambientController, curve: curve),
    );
  }

  @override
  void onClose() {
    staggerController.dispose();
    ambientController.dispose();
    super.onClose();
  }
}

class HomeCategory {
  final IconData icon;
  final String label;

  const HomeCategory({
    required this.icon,
    required this.label,
  });
}

class FeaturedRestaurant {
  final String imagePath;
  final String title;
  final String subtitle;
  final String delivery;
  final double rating;
  final String badge;
  final Color badgeColor;

  const FeaturedRestaurant({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.delivery,
    required this.rating,
    required this.badge,
    required this.badgeColor,
  });
}

class OfferRestaurant {
  final String title;
  final String subtitle;
  final String imagePath;

  const OfferRestaurant({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}
