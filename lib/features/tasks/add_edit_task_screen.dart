import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Map<String, dynamic>? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  String _selectedProject = '';
  String _selectedAssignee = '';
  String _selectedAssigneeName = '';
  String _selectedStatus = 'To Do';
  String _selectedPriority = 'Medium';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  bool get isEditing => widget.task != null;

  final _statuses = ['To Do', 'In Progress', 'Review', 'Completed'];
  final _priorities = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task?['task'] ?? '');
    _descController = TextEditingController();
    _selectedProject = widget.task?['project'] ?? (MockData.projects.isNotEmpty ? MockData.projects[0]['name'] as String : '');
    _selectedAssignee = widget.task?['assignee'] ?? (MockData.team.isNotEmpty ? MockData.team[0]['name'].toString().split(' ').map((s) => s[0]).join() : '');
    _selectedAssigneeName = widget.task?['assigneeName'] ?? (MockData.team.isNotEmpty ? MockData.team[0]['name'] as String : '');
    _selectedStatus = widget.task?['status'] ?? 'To Do';
    _selectedPriority = widget.task?['priority'] ?? 'Medium';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'New Task'),
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
            _label('Task Name'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'What needs to be done?', prefixIcon: Icon(Icons.task_alt_outlined, size: 20)),
              validator: (v) => v == null || v.trim().isEmpty ? 'Task name is required' : null,
            ),
            const SizedBox(height: 16),

            _label('Description'),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Add details about this task...'),
            ),
            const SizedBox(height: 16),

            _label('Project'),
            DropdownButtonFormField<String>(
              value: _selectedProject.isNotEmpty ? _selectedProject : null,
              decoration: _dropdownDeco(isDark),
              items: MockData.projects.map((p) => DropdownMenuItem<String>(
                value: p['name'] as String,
                child: Text(p['name'] as String),
              )).toList(),
              onChanged: (v) => setState(() => _selectedProject = v ?? ''),
              validator: (v) => v == null || v.isEmpty ? 'Select a project' : null,
            ),
            const SizedBox(height: 16),

            _label('Assignee'),
            DropdownButtonFormField<String>(
              value: _selectedAssigneeName.isNotEmpty ? _selectedAssigneeName : null,
              decoration: _dropdownDeco(isDark),
              items: MockData.team.map((m) => DropdownMenuItem<String>(
                value: m['name'] as String,
                child: Row(children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                    child: Center(child: Text(
                      m['name'].toString().split(' ').map((s) => s[0]).join(),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                    )),
                  ),
                  const SizedBox(width: 10),
                  Text(m['name'] as String),
                ]),
              )).toList(),
              onChanged: (v) {
                setState(() {
                  _selectedAssigneeName = v ?? '';
                  _selectedAssignee = v != null ? v.split(' ').map((s) => s[0]).join() : '';
                });
              },
            ),
            const SizedBox(height: 16),

            // Priority + Status
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Priority'),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: _dropdownDeco(isDark),
                  items: _priorities.map((p) => DropdownMenuItem<String>(
                    value: p,
                    child: Row(children: [
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          color: _priorityColor(p),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(p),
                    ]),
                  )).toList(),
                  onChanged: (v) => setState(() => _selectedPriority = v ?? 'Medium'),
                ),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Status'),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: _dropdownDeco(isDark),
                  items: _statuses.map((s) => DropdownMenuItem<String>(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => _selectedStatus = v ?? 'To Do'),
                ),
              ])),
            ]),
            const SizedBox(height: 16),

            _label('Due Date'),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _dueDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkScaffoldBg : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 10),
                  Text('${_dueDate.month}/${_dueDate.day}/${_dueDate.year}', style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: AppColors.textMuted),
                ]),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Update Task' : 'Create Task'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  InputDecoration _dropdownDeco(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? AppColors.darkScaffoldBg : AppColors.cardBg,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
    );
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'Critical': return AppColors.danger;
      case 'High': return AppColors.danger;
      case 'Medium': return AppColors.warning;
      default: return AppColors.textMuted;
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dueStr = '${months[_dueDate.month - 1]} ${_dueDate.day}';

    final data = {
      'task': _nameController.text.trim(),
      'project': _selectedProject,
      'assignee': _selectedAssignee,
      'assigneeName': _selectedAssigneeName,
      'priority': _selectedPriority,
      'status': _selectedStatus,
      'due': dueStr,
      'overdue': _dueDate.isBefore(DateTime.now()),
    };

    if (isEditing) {
      final idx = MockData.tasks.indexOf(widget.task!);
      if (idx != -1) MockData.tasks[idx] = data;
    }

    Navigator.pop(context, data);
  }
}
