import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;
  final TextEditingController controller;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSearchBar : AppColors.lightSearchBar,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
            width: 0.5,
          ),
        ),
        child: TextField(
          controller: controller,
          onChanged: onSearch,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search projects...',
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(
                Icons.search_rounded,
                color: isDark
                    ? AppColors.darkOnSurfaceVariant
                    : AppColors.lightOnSurfaceVariant,
                size: 20,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 44),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark
                            ? AppColors.darkOnSurfaceVariant
                            : AppColors.lightOnSurfaceVariant,
                        size: 18,
                      ),
                      onPressed: () {
                        controller.clear();
                        onSearch('');
                      },
                    )
                  : Icon(
                      Icons.mic_none_rounded,
                      color: isDark
                          ? AppColors.darkOnSurfaceVariant
                          : AppColors.lightOnSurfaceVariant,
                      size: 20,
                    ),
            ),
            suffixIconConstraints: const BoxConstraints(minWidth: 44),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
