import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/common_widgets.dart';

class ClientDetailScreen extends StatelessWidget {
  final Map<String, dynamic> client;
  const ClientDetailScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(client['company'] as String),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  AvatarCircle(initials: client['company'].toString().substring(0, 2).toUpperCase(), size: 56, bgColor: Colors.white.withValues(alpha: 0.2)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(client['company'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(client['contact'] as String, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 2),
                        Text('Client since ${client['since']}', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contact info
            _card(isDark, 'Contact Information', [
              _infoRow(Icons.email_outlined, 'Email', client['email'] as String),
              _infoRow(Icons.phone_outlined, 'Phone', client['phone'] as String),
              _infoRow(Icons.location_on_outlined, 'Address', client['address'] as String),
            ]),
            const SizedBox(height: 12),

            // Financial summary
            Text('Financial Summary', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                _finTile('Total Invoiced', client['totalInvoiced'] as String, AppColors.primary, isDark),
                const SizedBox(width: 8),
                _finTile('Paid', client['totalPaid'] as String, AppColors.success, isDark),
                const SizedBox(width: 8),
                _finTile('Outstanding', client['outstanding'] as String, client['outstanding'] == '\$0' ? AppColors.textMuted : AppColors.warning, isDark),
              ],
            ),
            const SizedBox(height: 16),

            // Projects
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Projects', style: Theme.of(context).textTheme.titleMedium),
                      Text('${client['projects']} total', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (client['projects'] == 0)
                    Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('No projects yet', style: TextStyle(color: AppColors.textMuted))))
                  else
                    ...[
                      _projectItem('Website Redesign', 'In Progress', 0.75, isDark),
                      const SizedBox(height: 8),
                      _projectItem('Brand Identity', 'Completed', 1.0, isDark),
                    ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Activity
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Activity', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _activityItem('Invoice INV-0042 paid', '\$2,500', '2 days ago', Icons.check_circle_outline, AppColors.success),
                  _activityItem('Project updated', 'Website Redesign · 75%', '1 week ago', Icons.folder_outlined, AppColors.primary),
                  _activityItem('Client created', 'Account opened', '${client['since']}', Icons.person_add_outlined, AppColors.info),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _card(bool isDark, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
        ],
      ),
    );
  }

  Widget _finTile(String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: AppColors.textMuted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _projectItem(String name, String status, double progress, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkScaffoldBg : AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
              StatusBadge(label: status, color: progress >= 1.0 ? AppColors.success : AppColors.primary, bgColor: progress >= 1.0 ? AppColors.successLight : AppColors.primaryLight),
            ],
          ),
          const SizedBox(height: 8),
          ProgressBar(progress: progress, color: progress >= 1.0 ? AppColors.success : AppColors.primary),
          const SizedBox(height: 4),
          Text('${(progress * 100).toInt()}% complete', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _activityItem(String title, String subtitle, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text(subtitle, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ])),
          Text(time, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
