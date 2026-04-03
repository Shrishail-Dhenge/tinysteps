import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';

enum AttendanceStatus {
  checkedIn,
  checkedOut,
  absent,
  atHome,
}

class StatusChip extends StatelessWidget {
  final AttendanceStatus status;

  const StatusChip({super.key, required this.status});

  Color get bgColor {
    switch (status) {
      case AttendanceStatus.checkedIn:
        return AppColors.successLight;
      case AttendanceStatus.checkedOut:
        return AppColors.accentLight;
      case AttendanceStatus.absent:
        return AppColors.dangerLight;
      case AttendanceStatus.atHome:
        return AppColors.warningLight; // add a color for "At Home"
    }
  }

  Color get textColor {
    switch (status) {
      case AttendanceStatus.checkedIn:
        return AppColors.success;
      case AttendanceStatus.checkedOut:
        return AppColors.accent;
      case AttendanceStatus.absent:
        return AppColors.danger;
      case AttendanceStatus.atHome:
        return AppColors.warning; // add a text color for "At Home"
    }
  }

  String get label {
    switch (status) {
      case AttendanceStatus.checkedIn:
        return "Checked In";
      case AttendanceStatus.checkedOut:
        return "Checked Out";
      case AttendanceStatus.absent:
        return "Absent";
      case AttendanceStatus.atHome:
        return "At Home"; // add label for "At Home"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.chipRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(color: textColor),
      ),
    );
  }
}