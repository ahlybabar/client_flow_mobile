import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/common_widgets.dart';
import '../../core/widgets/animated_list_item.dart';
import '../../data/mock_data.dart';
import 'project_detail_screen.dart';
import 'add_edit_project_screen.dart';

class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  String _filter = 'all';
  String _search = '';

  List<Map<String, dynamic>> get _filteredProjects {
    return MockData.projects.where((p) {
      final matchesSearch = p['name'].toString().toLowerCase().contains(_search.toLowerCase()) ||
          p['client'].toString().toLowerCase().contains(_search.toLowerCase());
      if (_filter == 'all') return matchesSearch;
      if (_filter == 'active') return matchesSearch && p['status'] == 'In Progress';
      if (_filter == 'on-hold') return matchesSearch && p['status'] == 'Planning';
      if (_filter == 'completed') return matchesSearch && p['status'] == 'Completed';
      return matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: _ProjectSearchDelegate(MockData.projects));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'projects_fab',
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditProjectScreen()),
          );
          if (result != null && result is Map<String, dynamic>) {
            setState(() => MockData.projects.add(result));
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Health summary row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(children: [
              _healthChip('Healthy', MockData.projects.where((p) => p['health'] == 'healthy').length.toString(), AppColors.success, isDark),
              const SizedBox(width: 8),
              _healthChip('At Risk', MockData.projects.where((p) => p['health'] == 'at-risk').length.toString(), AppColors.warning, isDark),
              const SizedBox(width: 8),
              _healthChip('Critical', MockData.projects.where((p) => p['health'] == 'critical').length.toString(), AppColors.danger, isDark),
            ]),
          ),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              _filterChip('All', 'all', isDark),
              const SizedBox(width: 8),
              _filterChip('Active', 'active', isDark),
              const SizedBox(width: 8),
              _filterChip('Planning', 'on-hold', isDark),
              const SizedBox(width: 8),
              _filterChip('Completed', 'completed', isDark),
            ]),
          ),
          // Project list
          Expanded(
            child: _filteredProjects.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.folder_off_outlined, size: 48, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    Text('No projects found', style: TextStyle(color: AppColors.textMuted)),
                  ]))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredProjects.length,
                    itemBuilder: (ctx, i) => AnimatedListItem(
                      index: i,
                      child: _projectCard(context, _filteredProjects[i], isDark),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _healthChip(String label, String count, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(children: [
          Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: color)),
        ]),
      ),
    );
  }

  Widget _filterChip(String label, String value, bool isDark) {
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

  Widget _projectCard(BuildContext context, Map<String, dynamic> p, bool isDark) {
    return ScaleTap(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: p))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(p['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
            _healthBadge(p['health'] as String),
          ]),
          const SizedBox(height: 4),
          Text(p['client'] as String, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          ProgressBar(progress: (p['progress'] as double), color: _healthColor(p['health'] as String)),
          const SizedBox(height: 6),
          Row(children: [
            Text('${((p['progress'] as double) * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _healthColor(p['health'] as String))),
            const Spacer(),
            Text('${p['tasksDone']}/${p['tasksTotal']} tasks', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(width: 12),
            Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(p['deadline'] as String, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            ...(p['team'] as List<String>).take(3).map((t) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: AvatarCircle(initials: t, size: 24, bgColor: AppColors.primary),
            )),
            if ((p['team'] as List<String>).length > 3)
              Text('+${(p['team'] as List<String>).length - 3}', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            const Spacer(),
            Text(p['budget'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
        ]),
      ),
    );
  }

  Widget _healthBadge(String health) {
    switch (health) {
      case 'healthy': return StatusBadge.healthy();
      case 'at-risk': return StatusBadge.atRisk();
      default: return StatusBadge.critical();
    }
  }

  Color _healthColor(String health) {
    switch (health) {
      case 'healthy': return AppColors.success;
      case 'at-risk': return AppColors.warning;
      default: return AppColors.danger;
    }
  }
}

class _ProjectSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> projects;
  _ProjectSearchDelegate(this.projects);

  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final results = projects.where((p) =>
        p['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
        p['client'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (ctx, i) {
        final p = results[i];
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.folder, size: 20, color: AppColors.primary),
          ),
          title: Text(p['name'] as String),
          subtitle: Text(p['client'] as String),
          trailing: Text('${((p['progress'] as double) * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
          onTap: () {
            close(context, p['name'] as String);
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: p)));
          },
        );
      },
    );
  }
}
