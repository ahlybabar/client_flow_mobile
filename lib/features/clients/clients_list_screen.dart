import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/common_widgets.dart';
import '../../data/mock_data.dart';
import 'client_detail_screen.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({super.key});

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  String _search = '';
  String _filter = 'all';

  List<Map<String, dynamic>> get _filteredClients {
    return MockData.clients.where((c) {
      final matchesSearch = c['company'].toString().toLowerCase().contains(_search.toLowerCase()) ||
          c['contact'].toString().toLowerCase().contains(_search.toLowerCase());
      final matchesFilter = _filter == 'all' || c['status'] == _filter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {
            showSearch(context: context, delegate: _ClientSearchDelegate(MockData.clients));
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _filterChip('All', 'all', isDark),
                const SizedBox(width: 8),
                _filterChip('Active', 'active', isDark),
                const SizedBox(width: 8),
                _filterChip('Inactive', 'inactive', isDark),
              ],
            ),
          ),
          // Client list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredClients.length,
              itemBuilder: (ctx, i) {
                final c = _filteredClients[i];
                return _clientCard(context, c, isDark);
              },
            ),
          ),
        ],
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

  Widget _clientCard(BuildContext context, Map<String, dynamic> client, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ClientDetailScreen(client: client))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        ),
        child: Row(
          children: [
            AvatarCircle(initials: client['company'].toString().substring(0, 2).toUpperCase(), size: 44, bgColor: AppColors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(client['company'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                      client['status'] == 'active' ? StatusBadge.active() : StatusBadge.inactive(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(client['contact'] as String, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.folder_outlined, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text('${client['projects']} projects', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(width: 12),
                      Icon(Icons.email_outlined, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(child: Text(client['email'] as String, style: TextStyle(fontSize: 12, color: AppColors.textMuted), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _ClientSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> clients;
  _ClientSearchDelegate(this.clients);

  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final results = clients.where((c) =>
      c['company'].toString().toLowerCase().contains(query.toLowerCase()) ||
      c['contact'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (ctx, i) {
        final c = results[i];
        return ListTile(
          leading: AvatarCircle(initials: c['company'].toString().substring(0, 2).toUpperCase(), size: 40),
          title: Text(c['company'] as String),
          subtitle: Text(c['contact'] as String),
          onTap: () {
            close(context, c['company'] as String);
            Navigator.push(context, MaterialPageRoute(builder: (_) => ClientDetailScreen(client: c)));
          },
        );
      },
    );
  }
}
