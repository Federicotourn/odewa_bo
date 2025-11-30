// ignore_for_file: avoid_print

import 'package:odewa_bo/constants/app_theme.dart';
import 'package:odewa_bo/constants/controllers.dart';
import 'package:odewa_bo/controllers/logged_user_controller.dart';
import 'package:odewa_bo/pages/authentication/services/auth_service.dart';
import 'package:odewa_bo/services/token_validation_service.dart';
import 'package:odewa_bo/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/responsiveness.dart';
import '../routing/routes.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    late final LoggedUserController loggedUserController;
    try {
      loggedUserController = Get.find<LoggedUserController>();
    } catch (e) {
      loggedUserController = Get.put(LoggedUserController());
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primary, AppTheme.primaryLight],
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            // bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header moderno con logo
            Container(
              width: Get.width,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(
                      "assets/logotipo-paytonic.png",
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Footer moderno con información del usuario
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.white.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => Text(
                                loggedUserController.user.value?.firstName ??
                                    "Usuario",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Obx(
                              () => Text(
                                loggedUserController.user.value?.lastName ??
                                    "Rol",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menú de navegación
            Expanded(
              child: Obx(() {
                if (loggedUserController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }

                final userPermissions = loggedUserController.userPermissions;
                final isClient = loggedUserController.isClient;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListView(
                    children: [
                      const SizedBox(height: 8),
                      ...sideMenuItems
                          .where(
                            (item) =>
                                item.route != authenticationPageRoute &&
                                // Ocultar empresas si el usuario es client
                                !(isClient &&
                                    item.route == companiesPageRoute) &&
                                (item.requiredPermissions == null ||
                                    item.requiredPermissions!.any(
                                      (perm) => userPermissions.contains(perm),
                                    )),
                          )
                          .map(
                            (item) => _ModernMenuItem(
                              item: item,
                              isActive: menuController.isActive(item.name),
                              hasWarning: false,
                              warningCount: 0,
                              onTap: () {
                                if (!menuController.isActive(item.name)) {
                                  menuController.changeActiveItemTo(item.name);
                                  if (ResponsiveWidget.isSmallScreen(context)) {
                                    Get.back();
                                  }
                                  navigationController.navigateTo(item.route);
                                }
                              },
                            ),
                          ),

                      const SizedBox(height: 16),

                      // Separador elegante
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botón de cerrar sesión
                      _ModernLogoutButton(
                        onTap: () async {
                          try {
                            final authService = Get.find<AuthService>();
                            loading(context);
                            // El método logout ya limpia todo
                            await authService.logout();
                            // Cerrar el menú lateral si está abierto
                            if (ResponsiveWidget.isSmallScreen(context)) {
                              Get.back();
                            }
                            // Redirigir al login (ya se hace en logout, pero por si acaso)
                            Get.offAllNamed(authenticationPageRoute);
                          } catch (e) {
                            // Si hay error, usar el método de fuerza del token service
                            final tokenService =
                                Get.find<TokenValidationService>();
                            await tokenService.logout();
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget moderno para elementos del menú
class _ModernMenuItem extends StatefulWidget {
  final dynamic item;
  final bool isActive;
  final bool hasWarning;
  final int warningCount;
  final VoidCallback onTap;

  const _ModernMenuItem({
    required this.item,
    required this.isActive,
    required this.hasWarning,
    required this.warningCount,
    required this.onTap,
  });

  @override
  State<_ModernMenuItem> createState() => _ModernMenuItemState();
}

class _ModernMenuItemState extends State<_ModernMenuItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _animationController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _animationController.reverse();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                        widget.isActive
                            ? LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.1),
                              ],
                            )
                            : _isHovered
                            ? LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.05),
                              ],
                            )
                            : null,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        widget.isActive
                            ? Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            )
                            : null,
                    boxShadow:
                        widget.isActive
                            ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : null,
                  ),
                  child: Row(
                    children: [
                      menuController.returnIconFor(widget.item.name),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.item.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight:
                                widget.isActive
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                          ),
                        ),
                      ),
                      if (widget.hasWarning) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade500,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '${widget.warningCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget moderno para el botón de cerrar sesión
class _ModernLogoutButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ModernLogoutButton({required this.onTap});

  @override
  State<_ModernLogoutButton> createState() => _ModernLogoutButtonState();
}

class _ModernLogoutButtonState extends State<_ModernLogoutButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _animationController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _animationController.reverse();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient:
                        _isHovered
                            ? LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.red.withValues(alpha: 0.2),
                                Colors.red.withValues(alpha: 0.1),
                              ],
                            )
                            : LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.05),
                              ],
                            ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          _isHovered
                              ? Colors.red.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color:
                            _isHovered
                                ? Colors.red.shade300
                                : Colors.white.withValues(alpha: 0.8),
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            color:
                                _isHovered
                                    ? Colors.red.shade300
                                    : Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
