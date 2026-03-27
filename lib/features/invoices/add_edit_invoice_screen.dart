import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';

class AddEditInvoiceScreen extends StatefulWidget {
  final Map<String, dynamic>? invoice;
  const AddEditInvoiceScreen({super.key, this.invoice});

  @override
  State<AddEditInvoiceScreen> createState() => _AddEditInvoiceScreenState();
}

class _AddEditInvoiceScreenState extends State<AddEditInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  String _selectedClient = '';
  String _selectedProject = '';
  String _selectedStatus = 'unpaid';
  DateTime _issueDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 14));

  bool get isEditing => widget.invoice != null;

  List<String> get _clientProjects {
    return MockData.projects
        .where((p) => p['client'] == _selectedClient)
        .map((p) => p['name'] as String)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.invoice?['amount']?.toString().replaceAll('\$', '').replaceAll(',', '') ?? '');
    _notesController = TextEditingController();
    _selectedClient = widget.invoice?['client'] ?? (MockData.clients.isNotEmpty ? MockData.clients[0]['company'] as String : '');
    _selectedProject = widget.invoice?['project'] ?? '';
    _selectedStatus = widget.invoice?['status'] ?? 'unpaid';

    // Set initial project
    if (_selectedProject.isEmpty && _clientProjects.isNotEmpty) {
      _selectedProject = _clientProjects.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Invoice' : 'New Invoice'),
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
            // Invoice preview header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBg : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.receipt_long, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(isEditing ? widget.invoice!['id'] as String : 'New Invoice', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(isEditing ? 'Editing existing invoice' : 'Fill in the details below', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ])),
              ]),
            ),
            const SizedBox(height: 20),

            _label('Client'),
            DropdownButtonFormField<String>(
              value: _selectedClient.isNotEmpty ? _selectedClient : null,
              decoration: _dropdownDeco(isDark),
              items: MockData.clients.map((c) => DropdownMenuItem<String>(
                value: c['company'] as String,
                child: Text(c['company'] as String),
              )).toList(),
              onChanged: (v) {
                setState(() {
                  _selectedClient = v ?? '';
                  _selectedProject = _clientProjects.isNotEmpty ? _clientProjects.first : '';
                });
              },
              validator: (v) => v == null || v.isEmpty ? 'Select a client' : null,
            ),
            const SizedBox(height: 16),

            _label('Project'),
            DropdownButtonFormField<String>(
              value: _clientProjects.contains(_selectedProject) ? _selectedProject : null,
              decoration: _dropdownDeco(isDark),
              items: _clientProjects.isEmpty
                  ? [const DropdownMenuItem<String>(value: '', child: Text('No projects for this client'))]
                  : _clientProjects.map((p) => DropdownMenuItem<String>(value: p, child: Text(p))).toList(),
              onChanged: (v) => setState(() => _selectedProject = v ?? ''),
            ),
            const SizedBox(height: 16),

            _label('Amount'),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(hintText: '0.00', prefixText: '\$ ', prefixIcon: Icon(Icons.attach_money, size: 20)),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Amount is required';
                if (double.tryParse(v.trim()) == null) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Dates
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Issue Date'),
                _datePicker(context, _issueDate, (d) => setState(() => _issueDate = d), isDark),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _label('Due Date'),
                _datePicker(context, _dueDate, (d) => setState(() => _dueDate = d), isDark),
              ])),
            ]),
            const SizedBox(height: 16),

            // Status (only for editing)
            if (isEditing) ...[
              _label('Payment Status'),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: _dropdownDeco(isDark),
                items: const [
                  DropdownMenuItem(value: 'unpaid', child: Text('Unpaid')),
                  DropdownMenuItem(value: 'paid', child: Text('Paid')),
                  DropdownMenuItem(value: 'overdue', child: Text('Overdue')),
                ],
                onChanged: (v) => setState(() => _selectedStatus = v ?? 'unpaid'),
              ),
              const SizedBox(height: 16),
            ],

            _label('Notes'),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Optional notes...'),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Update Invoice' : 'Generate Invoice'),
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

  Widget _datePicker(BuildContext context, DateTime date, ValueChanged<DateTime> onPick, bool isDark) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2030));
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
          const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text('${date.month}/${date.day}/${date.year}', style: const TextStyle(fontSize: 14)),
        ]),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final formattedAmount = '\$${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final issueStr = '${months[_issueDate.month - 1]} ${_issueDate.day}';
    final dueStr = '${months[_dueDate.month - 1]} ${_dueDate.day}';

    final invoiceNum = MockData.invoices.length + 43;
    final data = {
      'id': widget.invoice?['id'] ?? 'INV-${invoiceNum.toString().padLeft(4, '0')}',
      'client': _selectedClient,
      'project': _selectedProject,
      'amount': formattedAmount,
      'issue': issueStr,
      'due': dueStr,
      'status': _selectedStatus,
    };

    if (isEditing) {
      final idx = MockData.invoices.indexOf(widget.invoice!);
      if (idx != -1) MockData.invoices[idx] = data;
    }

    Navigator.pop(context, data);
  }
}
