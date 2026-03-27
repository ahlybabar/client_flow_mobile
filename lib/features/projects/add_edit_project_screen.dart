import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';

class AddEditProjectScreen extends StatefulWidget {
  final Map<String, dynamic>? project;
  const AddEditProjectScreen({super.key, this.project});

  @override
  State<AddEditProjectScreen> createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _budgetController;
  String _selectedClient = '';
  String _selectedStatus = 'Planning';
  String _selectedHealth = 'healthy';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  bool get isEditing => widget.project != null;

  final _statuses = ['Planning', 'In Progress', 'Review', 'Completed'];
  final _healthOptions = ['healthy', 'at-risk', 'critical'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?['name'] ?? '');
    _budgetController = TextEditingController(text: widget.project?['budget']?.toString().replaceAll('\$', '').replaceAll(',', '') ?? '');
    _selectedClient = widget.project?['client'] ?? (MockData.clients.isNotEmpty ? MockData.clients[0]['company'] as String : '');
    _selectedStatus = widget.project?['status'] ?? 'Planning';
    _selectedHealth = widget.project?['health'] ?? 'healthy';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Project' : 'New Project'),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(isEditing ? 'Update' : 'Create', style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Project Name
            _label('Project Name'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Enter project name'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Project name is required' : null,
            ),
            const SizedBox(height: 16),

            // Client
            _label('Client'),
            DropdownButtonFormField<String>(
              value: _selectedClient.isNotEmpty ? _selectedClient : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppColors.darkScaffoldBg : AppColors.cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
              ),
              items: MockData.clients.map((c) => DropdownMenuItem<String>(
                value: c['company'] as String,
                child: Text(c['company'] as String),
              )).toList(),
              onChanged: (v) => setState(() => _selectedClient = v ?? ''),
              validator: (v) => v == null || v.isEmpty ? 'Select a client' : null,
            ),
            const SizedBox(height: 16),

            // Status
            _label('Status'),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppColors.darkScaffoldBg : AppColors.cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
              ),
              items: _statuses.map((s) => DropdownMenuItem<String>(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _selectedStatus = v ?? 'Planning'),
            ),
            const SizedBox(height: 16),

            // Health
            _label('Health'),
            DropdownButtonFormField<String>(
              value: _selectedHealth,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppColors.darkScaffoldBg : AppColors.cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
              ),
              items: _healthOptions.map((h) => DropdownMenuItem<String>(
                value: h,
                child: Row(children: [
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      color: h == 'healthy' ? AppColors.success : (h == 'at-risk' ? AppColors.warning : AppColors.danger),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(h == 'healthy' ? 'Healthy' : (h == 'at-risk' ? 'At Risk' : 'Critical')),
                ]),
              )).toList(),
              onChanged: (v) => setState(() => _selectedHealth = v ?? 'healthy'),
            ),
            const SizedBox(height: 16),

            // Dates
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Start Date'),
                _datePicker(context, _startDate, (d) => setState(() => _startDate = d), isDark),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('End Date'),
                _datePicker(context, _endDate, (d) => setState(() => _endDate = d), isDark),
              ])),
            ]),
            const SizedBox(height: 16),

            // Budget
            _label('Budget'),
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '0.00', prefixText: '\$ '),
            ),
            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Update Project' : 'Create Project'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
    );
  }

  Widget _datePicker(BuildContext context, DateTime date, ValueChanged<DateTime> onPick, bool isDark) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkScaffoldBg : AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
        ),
        child: Row(children: [
          Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text('${date.month}/${date.day}/${date.year}', style: const TextStyle(fontSize: 14)),
        ]),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final budget = double.tryParse(_budgetController.text) ?? 0;
    final formattedBudget = '\$${budget.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

    final data = {
      'name': _nameController.text.trim(),
      'client': _selectedClient,
      'team': widget.project?['team'] ?? ['JD'],
      'status': _selectedStatus,
      'deadline': '${_endDate.month.toString().padLeft(2, '0')}/${_endDate.day.toString().padLeft(2, '0')}',
      'progress': _selectedStatus == 'Completed' ? 1.0 : (widget.project?['progress'] ?? 0.0),
      'tasksDone': widget.project?['tasksDone'] ?? 0,
      'tasksTotal': widget.project?['tasksTotal'] ?? 0,
      'health': _selectedHealth,
      'budget': formattedBudget,
    };

    if (isEditing) {
      final idx = MockData.projects.indexOf(widget.project!);
      if (idx != -1) MockData.projects[idx] = data;
    }

    Navigator.pop(context, data);
  }
}
