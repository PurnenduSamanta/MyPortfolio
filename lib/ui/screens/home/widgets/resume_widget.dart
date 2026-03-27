import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';

class ResumeWidget extends StatefulWidget {
  final String resumeLink;
  final String? profileImageUrl;

  const ResumeWidget({
    super.key,
    required this.resumeLink,
    this.profileImageUrl,
  });

  @override
  State<ResumeWidget> createState() => _ResumeWidgetState();
}

class _ResumeWidgetState extends State<ResumeWidget>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _pressScale;

  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      duration: AppDurations.fast,
      vsync: this,
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );

    // Fake progress bar that loops slowly
    _progressController = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat();

    // Pulse animation for the "now playing" bars
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _progressController.repeat();
        _pulseController.repeat(reverse: true);
      } else {
        _progressController.stop();
        _pulseController.stop();
      }
    });
  }

  Future<void> _openResume() async {
    final uri = Uri.parse(widget.resumeLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
    final onSurface =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final onSurfaceVariant = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;
    final surface = isDark
        ? AppColors.darkSurface.withValues(alpha: 0.85)
        : AppColors.lightSurface.withValues(alpha: 0.92);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.page,
        vertical: AppSpacing.xs,
      ),
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          _openResume();
        },
        onTapCancel: () => _pressController.reverse(),
        child: AnimatedBuilder(
          animation: _pressScale,
          builder: (context, child) =>
              Transform.scale(scale: _pressScale.value, child: child),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(AppRadius.xxl),
              border: Border.all(
                color: primary.withValues(alpha: 0.12),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row: album art + track info + controls
                Row(
                  children: [
                    // Album Art (Profile Image)
                    _buildAlbumArt(isDark, primary),

                    const SizedBox(width: AppSpacing.lg),

                    // Track Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              // Now Playing indicator
                              AnimatedBuilder(
                                animation: _pulseAnim,
                                builder: (context, _) => _NowPlayingBars(
                                  color: primary,
                                  amplitude: _isPlaying ? _pulseAnim.value : 0.3,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                _isPlaying ? 'Now Playing' : 'Paused',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: primary.withValues(alpha: 0.85),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Purnendu Samanta',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: onSurface,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Android Developer · Resume',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: onSurfaceVariant,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Playback Controls
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildControlButton(
                          icon: Icons.skip_previous_rounded,
                          size: 22,
                          color: onSurfaceVariant,
                          onTap: () {},
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _buildPlayPauseButton(isDark, primary),
                        const SizedBox(width: AppSpacing.xs),
                        _buildControlButton(
                          icon: Icons.skip_next_rounded,
                          size: 22,
                          color: onSurfaceVariant,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Progress bar
                _buildProgressBar(isDark, primary, onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumArt(bool isDark, Color primary) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.accentIndigo, AppColors.accentViolet]
              : [AppColors.lightPrimary, AppColors.accentVioletSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: widget.profileImageUrl != null &&
                widget.profileImageUrl!.isNotEmpty
            ? Image.network(
                widget.profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, _, _) => const Icon(
                  Icons.description_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              )
            : const Icon(
                Icons.description_rounded,
                color: Colors.white,
                size: 24,
              ),
      ),
    );
  }

  Widget _buildPlayPauseButton(bool isDark, Color primary) {
    return GestureDetector(
      onTap: _togglePlay,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary,
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required double size,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 28,
        height: 28,
        child: Icon(icon, size: size, color: color),
      ),
    );
  }

  Widget _buildProgressBar(
    bool isDark,
    Color primary,
    Color secondaryColor,
  ) {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, _) {
        final progress = _progressController.value;
        final elapsed = (progress * 3.5).toStringAsFixed(0);
        return Column(
          children: [
            // Progress track
            SizedBox(
              height: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Stack(
                  children: [
                    // Background track
                    Container(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                    // Filled track
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primary, primary.withValues(alpha: 0.7)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            // Time labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0:$elapsed',
                  style: TextStyle(fontSize: 9.5, color: secondaryColor),
                ),
                Text(
                  '3:30',
                  style: TextStyle(fontSize: 9.5, color: secondaryColor),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Animated "Now Playing" equalizer bars
class _NowPlayingBars extends StatelessWidget {
  final Color color;
  final double amplitude;

  const _NowPlayingBars({required this.color, required this.amplitude});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(3, (i) {
        // Each bar has a slightly different height factor
        final heights = [0.6, 1.0, 0.75];
        final h = 10.0 * heights[i] * (0.3 + amplitude * 0.7);
        return Container(
          width: 2.2,
          height: math.max(h, 3.0),
          margin: const EdgeInsets.symmetric(horizontal: 0.8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}
