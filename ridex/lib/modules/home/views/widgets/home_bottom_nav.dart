import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../controllers/home_controller.dart';

class HomeBottomNav extends GetView<HomeController> {
  const HomeBottomNav({super.key});

  static const _items = [
    _NavItem(
      icon: Icons.home_rounded,
      iconOutlined: Icons.home_outlined,
      label: 'الرئيسية',
    ),
    _NavItem(
      icon: Icons.search_rounded,
      iconOutlined: Icons.search_outlined,
      label: 'استكشاف',
    ),
    _NavItem(
      icon: Icons.shopping_bag_rounded,
      iconOutlined: Icons.shopping_bag_outlined,
      label: 'طلباتي',
      badge: 3,
    ),
    _NavItem(
      icon: Icons.person_rounded,
      iconOutlined: Icons.person_outline_rounded,
      label: 'حسابي',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 40,
            offset: const Offset(0, -12),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Thin top indicator bar ──
            Obx(() {
              final active = controller.activeNavIndex.value;
              return _TopIndicator(
                activeIndex: active,
                itemCount: _items.length,
              );
            }),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Obx(() {
                final active = controller.activeNavIndex.value;
                return Row(
                  children: List.generate(_items.length, (i) {
                    return Expanded(
                      child: _NavTile(
                        item: _items[i],
                        isActive: i == active,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          controller.selectNav(i);
                        },
                      ),
                    );
                  }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
//  TOP SLIDING INDICATOR
// ══════════════════════════════════════════════
class _TopIndicator extends StatelessWidget {
  final int activeIndex;
  final int itemCount;

  const _TopIndicator({required this.activeIndex, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final segW = constraints.maxWidth / itemCount;
        final indicatorW = 28.0;
        final targetX = segW * activeIndex + (segW - indicatorW) / 2;

        return SizedBox(
          height: 3,
          child: Stack(
            children: [
              // Track
              Container(color: const Color(0xFFF0F4F2)),
              // Moving pill
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: targetX,
                top: 0,
                bottom: 0,
                child: Container(
                  width: indicatorW,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════
//  SINGLE NAV TILE
// ══════════════════════════════════════════════
class _NavTile extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.82,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.82,
          end: 1.10,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.10,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_ctrl);

    _bounceAnim = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.1, 0.55, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void didUpdateWidget(_NavTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, widget.isActive ? _bounceAnim.value : 0),
          child: Transform.scale(
            scale: widget.isActive ? _scaleAnim.value : 1.0,
            child: child,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon container ──
            AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              width: widget.isActive ? 52 : 44,
              height: widget.isActive ? 40 : 36,
              decoration: BoxDecoration(
                color: widget.isActive
                    ? AppColors.primary.withValues(alpha: 0.11)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Icon
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Icon(
                      widget.isActive
                          ? widget.item.icon
                          : widget.item.iconOutlined,
                      key: ValueKey(widget.isActive),
                      color: widget.isActive
                          ? AppColors.primary
                          : Colors.black.withValues(alpha: 0.28),
                      size: 22,
                    ),
                  ),

                  // Badge
                  if (widget.item.badge != null && widget.item.badge! > 0)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 17,
                        height: 17,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFF6B35,
                              ).withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.item.badge}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 3),

            // ── Label ──
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 230),
              style: TextStyle(
                color: widget.isActive
                    ? AppColors.primary
                    : Colors.black.withValues(alpha: 0.28),
                fontSize: widget.isActive ? 11.5 : 10.5,
                fontWeight: widget.isActive ? FontWeight.w800 : FontWeight.w500,
                height: 1,
              ),
              child: Text(widget.item.label),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
//  DATA CLASS
// ══════════════════════════════════════════════
class _NavItem {
  final IconData icon;
  final IconData iconOutlined;
  final String label;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.iconOutlined,
    required this.label,
    this.badge,
  });
}
