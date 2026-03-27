import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import 'add_edit_project_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Map<String, dynamic> project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = project['progress'] as double;
    final healthColor = _healthColor(project['health'] as String);

    // Get related tasks
    final projectTasks = MockData.tasks.where((t) => t['project'] == project['name']).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(project['name'] as String),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => AddEditProjectScreen(project: project),
              ));
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Project?'),
                    content: Text('Are you sure you want to delete "${project['name']}"?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          MockData.projects.remove(project);
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                        },
                        child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'delete', child: Row(children: [
                Icon(Icons.delete_outline, size: 20, color: AppColors.danger),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: AppColors.danger)),
              ])),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(project['name'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white))),
                  _healthBadgeWhite(project['health'] as String),
                ]),
                const SizedBox(height: 6),
                Text(project['client'] as String, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.calendar_today_outlined, size: 13, color: Colors.white.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text('Deadline: ${project['deadline']}', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                  const Spacer(),
                  Text(project['budget'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ]),
                const SizedBox(height: 14),
                // Progress
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(children: [
                    Row(children: [
                      Text('Progress', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                      const Spacer(),
                      Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                    ]),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(children: [
                      Text('${project['tasksDone']}/${project['tasksTotal']} tasks completed', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
                    ]),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // Status & Team
            Row(children: [
              Expanded(child: _infoCard('Status', project['status'] as String, Icons.flag_outlined, isDark)),
              const SizedBox(width: 10),
              Expanded(child: _infoCard('Team', '${(project['team'] as List).length} members', Icons.group_outlined, isDark)),
            ]),
            const SizedBox(height: 16),

            // Team members
            _sectionCard('Team Members', isDark, Column(
              children: (project['team'] as List<String>).map((t) {
                final member = MockData.team.firstWhere(
                  (m) => m['name'].toString().split(' ').map((s) => s[0]).join() == t,
                  orElse: () => {'name': t, 'role': 'Staff', 'email': ''},
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    AvatarCircle(initials: t, size: 36, bgColor: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(member['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      Text(member['role'] as String, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ])),
                  ]),
                );
              }).toList(),
            )),
            const SizedBox(height: 12),

            // Tasks
            _sectionCard('Tasks (${projectTasks.length})', isDark, Column(
              children: projectTasks.isEmpty
                ? [Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('No tasks yet', style: TextStyle(color: AppColors.textMuted)),
                  )]
                : projectTasks.map((t) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkScaffoldBg : AppColors.scaffoldBg,
                      borderRadius: BorderRadius.circular(8),
                      border: t['overdue'] == true ? Border.all(color: AppColors.danger.withValues(alpha: 0.3)) : null,
                    ),
                    child: Row(children: [
                      Icon(
                        t['status'] == 'Completed' ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 20,
                        color: t['status'] == 'Completed' ? AppColors.success : AppColors.textMuted,
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(t['task'] as String, style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500,
                          decoration: t['status'] == 'Completed' ? TextDecoration.lineThrough : null,
                        )),
                        Row(children: [
                          Text('${t['assigneeName']} · ${t['due']}', style: TextStyle(fontSize: 11, color: t['overdue'] == true ? AppColors.danger : AppColors.textMuted)),
                        ]),
                      ])),
                      StatusBadge.priority(t['priority'] as String),
                    ]),
                  )).toList(),
            )),
            const SizedBox(height: 12),

            // Milestones timeline
            _sectionCard('Milestones', isDark, Column(
              children: [
                _milestone('Project Kickoff', 'Completed', true, isDark),
                _milestone('Design Phase', 'Completed', true, isDark),
                _milestone('Development Sprint 1', progress >= 0.5 ? 'Completed' : 'In Progress', progress >= 0.5, isDark),
                _milestone('Development Sprint 2', progress >= 0.75 ? 'Completed' : (progress >= 0.5 ? 'In Progress' : 'Upcoming'), progress >= 0.75, isDark),
                _milestone('QA & Testing', progress >= 0.9 ? 'In Progress' : 'Upcoming', progress >= 1.0, isDark),
                _milestone('Delivery', progress >= 1.0 ? 'Completed' : 'Upcoming', progress >= 1.0, isDark),
              ],
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(String title, bool isDark, Widget content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        content,
      ]),
    );
  }

  Widget _infoCard(String label, String value, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ]),
    );
  }

  Widget _milestone(String title, String status, bool done, bool isDark) {
    final color = done ? AppColors.success : (status == 'In Progress' ? AppColors.primary : AppColors.textMuted);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: done ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: done ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            if (title != 'Delivery')
              Expanded(child: Container(width: 2, color: done ? color.withValues(alpha: 0.3) : AppColors.border)),
          ]),
          const SizedBox(width: 12),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: done ? null : AppColors.textMuted)),
              Text(status, style: TextStyle(fontSize: 11, color: color)),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _healthBadgeWhite(String health) {
    Color bg;
    String label;
    switch (health) {
      case 'healthy': bg = AppColors.success; label = 'Healthy'; break;
      case 'at-risk': bg = AppColors.warning; label = 'At Risk'; break;
      default: bg = AppColors.danger; label = 'Critical';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
    );
  }

  Color _healthColor(String health) {
    switch (health) {
      case 'healthy': return AppColors.success;
      case 'at-risk': return AppColors.warning;
      default: return AppColors.danger;
    }
  }
}
