import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';

class NotificationPanel extends StatefulWidget {
  final VoidCallback onClose;
  final String resumeLink;

  const NotificationPanel({
    super.key,
    required this.onClose,
    required this.resumeLink,
  });

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  double _closeDragDistance = 0;
  bool _closeDragTriggered = false;

  void _onDragStart(DragStartDetails details) {
    _closeDragDistance = 0;
    _closeDragTriggered = false;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_closeDragTriggered) return;
    final delta = details.primaryDelta ?? 0;
    if (delta >= 0) return;

    _closeDragDistance += -delta;
    if (_closeDragDistance >= 24) {
      _closeDragTriggered = true;
      widget.onClose();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    _closeDragDistance = 0;
    _closeDragTriggered = false;
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime date) {
    return '${_months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onVerticalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          // Background Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: (isDark ? Colors.black : Colors.white).withValues(
                  alpha: 0.2,
                ),
              ),
            ),
          ),

          // Panel Content
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header / Drag Indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white : Colors.black)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Highlights (Dynamic Signals)
                  _buildQuickHighlights(isDark),

                  const SizedBox(height: 24),

                  // Micro-storytelling
                  _buildMicroStory(isDark),

                  const SizedBox(height: 24),

                  // Resume Notification
                  _buildResumeNotification(isDark),

                  const SizedBox(height: 24),

                  // Close Button (Subtle)
                  Center(
                    child: IconButton(
                      onPressed: widget.onClose,
                      icon: Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOnSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickHighlights(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSignalIcon(Icons.wifi, "WiFi Connected", isDark),
        _buildSignalIcon(Icons.bluetooth, "Bluetooth Off", isDark),
        _buildSignalIcon(Icons.notifications_active, "Priority Only", isDark),
        _buildSignalIcon(Icons.battery_full, "98% Charged", isDark),
      ],
    );
  }

  Widget _buildSignalIcon(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                .withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.split(' ').first,
          style: TextStyle(
            fontSize: 10,
            color: isDark
                ? AppColors.darkOnSurfaceVariant
                : AppColors.lightOnSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildMicroStory(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                "Daily Pulse",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkOnSurface
                      : AppColors.lightOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Building the future of web experiences one pixel at a time. Currently exploring the intersection of AI and Creative Coding.",
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeNotification(bool isDark) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(widget.resumeLink);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF6366F1).withValues(alpha: 0.2),
                    const Color(0xFF818CF8).withValues(alpha: 0.1),
                  ]
                : [
                    const Color(0xFF6366F1).withValues(alpha: 0.1),
                    const Color(0xFF818CF8).withValues(alpha: 0.05),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                .withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.description_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "View Portfolio Resume",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark
                          ? AppColors.darkOnSurface
                          : AppColors.lightOnSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Last updated: ${_formatDate(DateTime.now())}",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
