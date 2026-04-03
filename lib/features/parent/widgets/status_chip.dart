import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

/// Enum for attendance statuses
enum AttendanceStatus {
  checkedIn,
  inClass,
  atHome,
  checkedOut,
}

/// A small UI badge for displaying status
class StatusChip extends StatelessWidget {
  final AttendanceStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;
    String label;

    switch (status) {
      case AttendanceStatus.checkedIn:
        label = 'Checked In';
        color = AppColors.success;
        bgColor = AppColors.successLight;
        break;
      case AttendanceStatus.inClass:
        label = 'In Class';
        color = AppColors.success;
        bgColor = AppColors.successLight;
        break;
      case AttendanceStatus.atHome:
        label = 'At Home';
        color = AppColors.danger;
        bgColor = AppColors.dangerLight;
        break;
      case AttendanceStatus.checkedOut:
        label = 'Checked Out';
        color = AppColors.danger;
        bgColor = AppColors.dangerLight;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}