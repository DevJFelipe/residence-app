import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// A shared header bar used across screens.
///
/// Handles safe area padding automatically and
/// supports an optional title, leading widget,
/// trailing actions, and bottom divider.
class AppHeader extends StatelessWidget {
  /// Optional title text centered in the header.
  final String? title;

  /// Optional leading widget, typically a back button.
  final Widget? leading;

  /// Optional list of trailing action widgets.
  final List<Widget>? actions;

  /// Whether to show a bottom divider line.
  final bool showDivider;

  /// Background color of the header.
  /// Defaults to the app background with blur.
  final Color? backgroundColor;

  const AppHeader({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.showDivider = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding =
        MediaQuery.of(context).padding.top;
    final bgColor = backgroundColor ??
        AppColors.background.withValues(alpha: 0.8);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: Container(
          padding: EdgeInsets.only(top: topPadding),
          decoration: BoxDecoration(
            color: bgColor,
            border: showDivider
                ? const Border(
                    bottom: BorderSide(
                      color: AppColors.divider,
                    ),
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              17,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(
                    width: AppSpacing.lg,
                  ),
                ],
                if (title != null)
                  Expanded(
                    child: Text(
                      title!,
                      style: GoogleFonts.publicSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 28 / 18,
                        color: AppColors.textDark,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                if (actions != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!
                        .map(
                          (a) => Padding(
                            padding:
                                const EdgeInsets.only(
                              left: AppSpacing.sm,
                            ),
                            child: a,
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
