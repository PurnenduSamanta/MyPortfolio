import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/core/constants/app_gradients.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';
import 'package:my_portfolio/data/model/app_item.dart';
import 'package:my_portfolio/data/repository/app_repository.dart';
import 'package:my_portfolio/services/contact_service.dart';

class MainDesktopLayout extends StatefulWidget {
  final Widget content;
  final bool showingStartup;

  const MainDesktopLayout({
    super.key,
    required this.content,
    required this.showingStartup,
  });

  @override
  State<MainDesktopLayout> createState() => _MainDesktopLayoutState();
}

class _MainDesktopLayoutState extends State<MainDesktopLayout> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _contactService = ContactService();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitContactForm() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    setState(() => _isSubmitting = true);

    try {
      final result = await _contactService.submitContactForm(
        name: name,
        email: email,
        message: message,
      );

      if (!mounted) {
        return;
      }

      if (result.isSuccess) {
        _formKey.currentState?.reset();
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message)));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message)));
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not send the message. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final desktopColumnHeight =
        MediaQuery.of(
          context,
        ).size.height.clamp(500.0, AppSizes.phoneHeight + 40) -
        40;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? AppGradients.desktopBackgroundDark
                : AppGradients.desktopBackgroundLight,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _BackgroundOrbs(isDark: isDark),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWideDesktop = constraints.maxWidth >= 1180;

                  if (!isWideDesktop) {
                    return Center(
                      child: MainPhoneFrame(
                        isDark: isDark,
                        content: widget.content,
                        showingStartup: widget.showingStartup,
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    child: Builder(
                      builder: (context) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: desktopColumnHeight,
                                child: _DesktopIntroPanel(isDark: isDark),
                              ),
                            ),
                            const SizedBox(width: 28),
                            SizedBox(
                              height: desktopColumnHeight,
                              child: MainPhoneFrame(
                                isDark: isDark,
                                content: widget.content,
                                showingStartup: widget.showingStartup,
                                frameHeight: desktopColumnHeight,
                              ),
                            ),
                            const SizedBox(width: 28),
                            Expanded(
                              child: SizedBox(
                                height: desktopColumnHeight,
                                child: _DesktopContactPanel(
                                  isDark: isDark,
                                  formKey: _formKey,
                                  nameController: _nameController,
                                  emailController: _emailController,
                                  messageController: _messageController,
                                  isSubmitting: _isSubmitting,
                                  onSubmit: _submitContactForm,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopIntroPanel extends StatefulWidget {
  final bool isDark;

  const _DesktopIntroPanel({required this.isDark});

  @override
  State<_DesktopIntroPanel> createState() => _DesktopIntroPanelState();
}

class _DesktopIntroPanelState extends State<_DesktopIntroPanel> {
  final AppRepository _repository = AppRepository();

  String _greeting(DateTime now) {
    final hour = now.hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isDark = widget.isDark;
    final panelColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.72);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.42);
    final mutedColor = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;
    final titleColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: panelColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.08),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 760;
              final headingSize = compact ? 34.0 : 40.0;
              final bodySize = compact ? 14.0 : 15.0;
              final gapSmall = compact ? 6.0 : 8.0;
              final gapMedium = compact ? 14.0 : 18.0;
              final gapLarge = compact ? 18.0 : 24.0;

              return FutureBuilder<List<AppItem>>(
                future: _repository.getApps(),
                builder: (context, snapshot) {
                  final apps = snapshot.data ?? const <AppItem>[];
                  final about =
                      apps
                          .cast<AppItem?>()
                          .firstWhere(
                            (app) => app != null && app.about.trim().isNotEmpty,
                            orElse: () => null,
                          )
                          ?.about ??
                      'I build Flutter products that balance usable architecture, clean interaction design, and production-ready execution, with more than 3 years of hands-on experience across mobile and web.';
                  final techIcons = _uniqueTechIcons(apps);

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_greeting(now)},',
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: compact ? 16 : 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: gapSmall),
                        Text(
                          'I am Purnendu Samanta.',
                          style: TextStyle(
                            color: titleColor,
                            height: 1.05,
                            fontSize: headingSize,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: gapMedium),
                        Text(
                          about,
                          style: TextStyle(
                            color: mutedColor,
                            height: 1.6,
                            fontSize: bodySize,
                          ),
                        ),
                        SizedBox(height: gapLarge),
                        Text(
                          'Tech Stack',
                          style: TextStyle(
                            color: titleColor,
                            fontSize: compact ? 22 : 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: techIcons
                              .map(
                                (iconUrl) => _TechIconBadge(iconUrl: iconUrl),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

List<String> _uniqueTechIcons(List<AppItem> apps) {
  final seen = <String>{};
  final result = <String>[];

  for (final app in apps) {
    for (final techIcon in app.techIconUrls) {
      final normalized = techIcon.trim();
      if (normalized.isEmpty) continue;
      if (seen.add(normalized.toLowerCase())) {
        result.add(normalized);
      }
    }
  }

  if (result.isNotEmpty) {
    return result;
  }

  return const [
    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/android/android-original.svg',
    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kotlin/kotlin-original.svg',
    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg',
    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg',
    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg',
    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/github/github-original.svg',
    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/firebase/firebase-plain.svg',
    'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/gradle/gradle-original.svg',
  ];
}

class _TechIconBadge extends StatelessWidget {
  final String iconUrl;

  const _TechIconBadge({required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSvg = iconUrl.toLowerCase().contains('.svg');

    return Container(
      width: 54,
      height: 54,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.64),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.10)
              : Colors.white.withValues(alpha: 0.34),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: isSvg
            ? SvgPicture.network(
                iconUrl,
                fit: BoxFit.contain,
                placeholderBuilder: (context) => const SizedBox.shrink(),
              )
            : Image.network(
                iconUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.memory_outlined,
                    color: isDark
                        ? AppColors.accentCyanSoft
                        : AppColors.accentBlueDeep,
                    size: 22,
                  );
                },
              ),
      ),
    );
  }
}

class _DesktopContactPanel extends StatelessWidget {
  final bool isDark;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final bool isSubmitting;
  final Future<void> Function() onSubmit;

  const _DesktopContactPanel({
    required this.isDark,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.messageController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final required = _validateRequired(value, 'Email');
    if (required != null) {
      return required;
    }

    final email = value!.trim();
    final looksValid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    if (!looksValid) {
      return 'Enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final panelColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.76);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white.withValues(alpha: 0.42);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: panelColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.08),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact me',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkOnSurface
                        : AppColors.lightOnSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),
                _ContactField(
                  controller: nameController,
                  label: 'Your name',
                  validator: (value) => _validateRequired(value, 'Name'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                _ContactField(
                  controller: emailController,
                  label: 'Your email',
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: _ContactField(
                    controller: messageController,
                    label: 'Your message',
                    validator: (value) => _validateRequired(value, 'Message'),
                    maxLines: null,
                    expands: true,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isSubmitting ? null : onSubmit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: isDark
                          ? AppColors.accentBlueSoft
                          : AppColors.accentBlueDeep,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      isSubmitting ? 'Sending...' : 'Send',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final bool expands;

  const _ContactField({
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      expands: expands,
      maxLines: maxLines,
      minLines: expands ? null : 1,
      style: TextStyle(
        color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: expands || (maxLines ?? 1) > 1,
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.80),
        labelStyle: TextStyle(
          color: isDark
              ? AppColors.darkOnSurfaceVariant
              : AppColors.lightOnSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.10)
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.10)
                : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark ? AppColors.accentCyanSoft : AppColors.accentBlueDeep,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

class _BackgroundOrbs extends StatefulWidget {
  final bool isDark;

  const _BackgroundOrbs({required this.isDark});

  @override
  State<_BackgroundOrbs> createState() => _BackgroundOrbsState();
}

class _BackgroundOrbsState extends State<_BackgroundOrbs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.backgroundLoop,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _OrbPainter(
            progress: _controller.value,
            isDark: widget.isDark,
          ),
        );
      },
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _OrbPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = (isDark ? AppColors.lightPrimary : AppColors.darkPrimary)
        .withValues(alpha: isDark ? 0.08 : 0.12);
    final x1 = size.width * 0.2 + math.sin(progress * 2 * math.pi) * 40;
    final y1 = size.height * 0.3 + math.cos(progress * 2 * math.pi) * 30;
    canvas.drawCircle(Offset(x1, y1), 120, paint);

    paint.color =
        (isDark ? AppColors.accentVioletSoft : AppColors.accentVioletPastel)
            .withValues(alpha: isDark ? 0.06 : 0.10);
    final x2 = size.width * 0.8 + math.cos(progress * 2 * math.pi + 1) * 50;
    final y2 = size.height * 0.6 + math.sin(progress * 2 * math.pi + 1) * 40;
    canvas.drawCircle(Offset(x2, y2), 150, paint);

    paint.color = (isDark ? AppColors.accentCyan : AppColors.accentCyanSoft)
        .withValues(alpha: isDark ? 0.05 : 0.08);
    final x3 = size.width * 0.5 + math.sin(progress * 2 * math.pi + 2.5) * 35;
    final y3 = size.height * 0.8 + math.cos(progress * 2 * math.pi + 2.5) * 25;
    canvas.drawCircle(Offset(x3, y3), 100, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class MainPhoneFrame extends StatelessWidget {
  final bool isDark;
  final Widget content;
  final bool showingStartup;
  final double? frameHeight;

  const MainPhoneFrame({
    super.key,
    required this.isDark,
    required this.content,
    required this.showingStartup,
    this.frameHeight,
  });

  static const _frameRadius = 44.0;
  static const _innerRadius = 42.0;
  static const _frameThickness = 3.0;

  @override
  Widget build(BuildContext context) {
    // Silver metallic frame colors
    final frameColor = isDark
        ? const Color(0xFF8A8D96)
        : const Color(0xFFC0C4CC);
    final frameHighlight = isDark
        ? const Color(0xFFAEB1B9)
        : const Color(0xFFE2E4E8);
    final frameShadowColor = isDark
        ? const Color(0xFF3A3D45)
        : const Color(0xFF8F929A);

    // Responsive height: max 780, but shrinks on smaller screens
    final viewportHeight = MediaQuery.of(context).size.height;
    final phoneHeight =
        frameHeight ??
        (viewportHeight.clamp(500.0, AppSizes.phoneHeight + 40) - 40);

    return SizedBox(
      // Extra width for side buttons
      width: AppSizes.phoneWidth + 20,
      height: phoneHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // === LEFT SIDE BUTTONS (Volume Up + Down) ===
          // Volume Up
          Positioned(
            left: 0,
            top: 160,
            child: _SideButton(
              isDark: isDark,
              height: 44,
              isLeft: true,
              frameColor: frameColor,
            ),
          ),
          // Volume Down
          Positioned(
            left: 0,
            top: 216,
            child: _SideButton(
              isDark: isDark,
              height: 44,
              isLeft: true,
              frameColor: frameColor,
            ),
          ),

          // === RIGHT SIDE BUTTON (Power) ===
          Positioned(
            right: 0,
            top: 190,
            child: _SideButton(
              isDark: isDark,
              height: 52,
              isLeft: false,
              frameColor: frameColor,
            ),
          ),

          // === PHONE BODY ===
          Center(
            child: Container(
              width: AppSizes.phoneWidth,
              height: phoneHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_frameRadius),
                // Metallic frame gradient (simulates edge bevel)
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    frameHighlight,
                    frameColor,
                    frameColor,
                    frameShadowColor,
                  ],
                  stops: const [0.0, 0.15, 0.85, 1.0],
                ),
                boxShadow: [
                  // Primary glow
                  BoxShadow(
                    color:
                        (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.12),
                    blurRadius: 80,
                    spreadRadius: 8,
                  ),
                  // Bottom drop shadow (3D lift)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.22),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                  // Tight shadow for depth
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  // Left edge highlight
                  BoxShadow(
                    color: (isDark ? Colors.white : Colors.white).withValues(
                      alpha: isDark ? 0.04 : 0.12,
                    ),
                    blurRadius: 2,
                    offset: const Offset(-1, 0),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(_frameThickness),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_innerRadius),
                  color: isDark
                      ? AppColors.darkBackground
                      : AppColors.lightBackground,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_innerRadius),
                  child: Stack(
                    children: [
                      // Screen content
                      AnimatedSwitcher(
                        duration: AppDurations.transition,
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: KeyedSubtree(
                          key: ValueKey<bool>(showingStartup),
                          child: content,
                        ),
                      ),

                      // Speaker Grill (top bezel)
                      Positioned(
                        top: 2,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 56,
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.7)
                                  : Colors.black.withValues(alpha: 0.15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  10,
                                  (i) => Container(
                                    width: 1.5,
                                    height: 5,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1.2,
                                    ),
                                    color: isDark
                                        ? Colors.grey.shade900.withValues(
                                            alpha: 0.6,
                                          )
                                        : Colors.black.withValues(alpha: 0.08),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Dynamic Island (Notch) — clean pill, no camera
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: AppSpacing.lg),
                            width: 100,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                            ),
                          ),
                        ),
                      ),

                      // Top left screen reflection (3D shine)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_innerRadius),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withValues(
                                    alpha: isDark ? 0.02 : 0.06,
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Side button widget for volume and power buttons
class _SideButton extends StatelessWidget {
  final bool isDark;
  final double height;
  final bool isLeft;
  final Color frameColor;

  const _SideButton({
    required this.isDark,
    required this.height,
    required this.isLeft,
    required this.frameColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = 4.0;
    // Offset to overlap with the phone frame edge
    final edgeOffset = isLeft ? 7.0 : 7.0;

    return Transform.translate(
      offset: Offset(isLeft ? edgeOffset : -edgeOffset, 0),
      child: Container(
        width: buttonWidth,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(2.5) : Radius.zero,
            right: isLeft ? Radius.zero : const Radius.circular(2.5),
          ),
          gradient: LinearGradient(
            begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            colors: [
              isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.5),
              frameColor,
              isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.1),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
              blurRadius: 3,
              offset: Offset(isLeft ? -1 : 1, 1),
            ),
          ],
        ),
      ),
    );
  }
}
