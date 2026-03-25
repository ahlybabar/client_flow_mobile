import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/mock_data.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _isBoardView = false;
  String _filter = 'all';

  List<Map<String, dynamic>> get _filteredTasks {
    return MockData.tasks.where((t) {
      if (_filter == 'all') return true;
      if (_filter == 'overdue') return t['overdue'] == true;
      if (_filter == 'completed') return t['status'] == 'Completed';
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(_isBoardView ? Icons.list : Icons.view_column_outlined),
            onPressed: () => setState(() => _isBoardView = !_isBoardView),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _chip('All', 'all', isDark),
                const SizedBox(width: 8),
                _chip('Overdue', 'overdue', isDark),
                const SizedBox(width: 8),
                _chip('Completed', 'completed', isDark),
              ],
            ),
          ),
          Expanded(child: _isBoardView ? _boardView(isDark) : _listView(isDark)),
        ],
      ),
    );
  }

  Widget _chip(String label, String value, bool isDark) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : (isDark ? AppColors.darkCardBg : AppColors.cardBg),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border)),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }

  Widget _listView(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredTasks.length,
      itemBuilder: (ctx, i) {
        final t = _filteredTasks[i];
        return GestureDetector(
          onTap: () => _showTaskDetail(context, t, isDark),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: t['overdue'] == true ? AppColors.danger.withValues(alpha: 0.3) : (isDark ? AppColors.darkBorder : AppColors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(t['task'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    StatusBadge.priority(t['priority'] as String),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.folder_outlined, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(t['project'] as String, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
                    AvatarCircle(initials: t['assignee'] as String, size: 22, bgColor: AppColors.primary.withValues(alpha: 0.15)),
                    const SizedBox(width: 6),
                    Text(t['assigneeName'] as String, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 13, color: t['overdue'] == true ? AppColors.danger : AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(t['due'] as String, style: TextStyle(fontSize: 12, color: t['overdue'] == true ? AppColors.danger : AppColors.textMuted, fontWeight: t['overdue'] == true ? FontWeight.w600 : FontWeight.normal)),
                    if (t['overdue'] == true) ...[const SizedBox(width: 6), Text('OVERDUE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.danger))],
                    const Spacer(),
                    _statusDot(t['status'] as String),
                    const SizedBox(width: 4),
                    Text(t['status'] as String, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _boardView(bool isDark) {
    final columns = ['To Do', 'In Progress', 'Review', 'Completed'];
    final columnColors = [AppColors.textSecondary, AppColors.primary, AppColors.warning, AppColors.success];
    return PageView.builder(
      itemCount: columns.length,
      controller: PageController(viewportFraction: 0.85),
      itemBuilder: (ctx, i) {
        final colTasks = MockData.tasks.where((t) => t['status'] == columns[i]).toList();
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : AppColors.scaffoldBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                ),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: columnColors[i], shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(columns[i], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.hoverBg, borderRadius: BorderRadius.circular(10)),
                      child: Text('${colTasks.length}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  children: colTasks.map((t) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkScaffoldBg : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t['task'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(t['project'] as String, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            const Spacer(),
                            StatusBadge.priority(t['priority'] as String),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            AvatarCircle(initials: t['assignee'] as String, size: 20, bgColor: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(t['due'] as String, style: TextStyle(fontSize: 11, color: t['overdue'] == true ? AppColors.danger : AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusDot(String status) {
    Color c = AppColors.textMuted;
    switch (status) {
      case 'In Progress': c = AppColors.primary; break;
      case 'Review': c = AppColors.warning; break;
      case 'Completed': c = AppColors.success; break;
    }
    return Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
  }

  void _showTaskDetail(BuildContext context, Map<String, dynamic> task, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (ctx, sc) => ListView(
          controller: sc,
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: Text(task['task'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
              StatusBadge.priority(task['priority'] as String),
            ]),
            const SizedBox(height: 12),
            _detailRow(Icons.folder_outlined, 'Project', task['project'] as String),
            _detailRow(Icons.person_outline, 'Assignee', task['assigneeName'] as String),
            _detailRow(Icons.calendar_today_outlined, 'Due Date', task['due'] as String),
            _detailRow(Icons.flag_outlined, 'Status', task['status'] as String),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text('Description', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text('Complete the ${task['task'].toString().toLowerCase()} as per the project specifications and guidelines.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 16),
            Text('Subtasks', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            _subtaskItem('Research & wireframing', true),
            _subtaskItem('Initial design', true),
            _subtaskItem('Client review', false),
            _subtaskItem('Final adjustments', false),
            const SizedBox(height: 16),
            Text('Comments', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            _commentItem('John Doe', 'Looking good! Let\'s review this tomorrow.', '2 hours ago'),
            _commentItem('Sarah Kim', 'Updated the mockups based on feedback.', '1 day ago'),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Text('$label:', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _subtaskItem(String text, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Icon(done ? Icons.check_circle : Icons.radio_button_unchecked, size: 20, color: done ? AppColors.success : AppColors.textMuted),
        const SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 13, decoration: done ? TextDecoration.lineThrough : null, color: done ? AppColors.textMuted : null)),
      ]),
    );
  }

  Widget _commentItem(String author, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AvatarCircle(initials: author.substring(0, 2).toUpperCase(), size: 28, bgColor: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(author, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Text(time, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ]),
          const SizedBox(height: 3),
          Text(text, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ])),
      ]),
    );
  }
}
