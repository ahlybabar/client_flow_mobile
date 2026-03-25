import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? bgColor;

  const StatusBadge({
    super.key,
    required this.label,
    this.color,
    this.bgColor,
  });

  factory StatusBadge.active() => StatusBadge(label: 'Active', color: AppColors.success, bgColor: AppColors.successLight);
  factory StatusBadge.inactive() => StatusBadge(label: 'Inactive', color: AppColors.textMuted, bgColor: AppColors.hoverBg);
  factory StatusBadge.inProgress() => StatusBadge(label: 'In Progress', color: AppColors.primary, bgColor: AppColors.primaryLight);
  factory StatusBadge.completed() => StatusBadge(label: 'Completed', color: AppColors.success, bgColor: AppColors.successLight);
  factory StatusBadge.planning() => StatusBadge(label: 'Planning', color: AppColors.textSecondary, bgColor: AppColors.hoverBg);
  factory StatusBadge.review() => StatusBadge(label: 'Review', color: Color(0xFFD97706), bgColor: AppColors.warningLight);
  factory StatusBadge.paid() => StatusBadge(label: 'Paid', color: AppColors.success, bgColor: AppColors.successLight);
  factory StatusBadge.unpaid() => StatusBadge(label: 'Unpaid', color: Color(0xFFD97706), bgColor: AppColors.warningLight);
  factory StatusBadge.overdue() => StatusBadge(label: 'Overdue', color: AppColors.danger, bgColor: AppColors.dangerLight);
  factory StatusBadge.healthy() => StatusBadge(label: 'Healthy', color: AppColors.success, bgColor: AppColors.successLight);
  factory StatusBadge.atRisk() => StatusBadge(label: 'At Risk', color: AppColors.warning, bgColor: AppColors.warningLight);
  factory StatusBadge.critical() => StatusBadge(label: 'Critical', color: AppColors.danger, bgColor: AppColors.dangerLight);

  factory StatusBadge.priority(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return StatusBadge(label: priority, color: AppColors.danger, bgColor: AppColors.dangerLight);
      case 'high':
        return StatusBadge(label: priority, color: AppColors.danger, bgColor: AppColors.dangerLight);
      case 'medium':
        return StatusBadge(label: priority, color: AppColors.warning, bgColor: AppColors.warningLight);
      default:
        return StatusBadge(label: priority, color: AppColors.textSecondary, bgColor: AppColors.hoverBg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.hoverBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.textSecondary,
        ),
      ),
    );
  }
}
