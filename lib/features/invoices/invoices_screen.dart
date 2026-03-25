import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/mock_data.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String _filter = 'all';

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'all') return MockData.invoices;
    return MockData.invoices.where((i) => i['status'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Summary cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: _summaryTile('Total', '\$13,800', AppColors.primary, isDark)),
                  const SizedBox(width: 8),
                  Expanded(child: _summaryTile('Paid', '\$5,700', AppColors.success, isDark)),
                  const SizedBox(width: 8),
                  Expanded(child: _summaryTile('Overdue', '\$4,200', AppColors.danger, isDark)),
                ],
              ),
            ),
            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                _chip('All', 'all', isDark),
                const SizedBox(width: 8),
                _chip('Paid', 'paid', isDark),
                const SizedBox(width: 8),
                _chip('Unpaid', 'unpaid', isDark),
                const SizedBox(width: 8),
                _chip('Overdue', 'overdue', isDark),
              ]),
            ),
            const SizedBox(height: 8),
            // Invoice list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) => _invoiceCard(_filtered[i], isDark, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ]),
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

  Widget _invoiceCard(Map<String, dynamic> inv, bool isDark, BuildContext context) {
    return GestureDetector(
      onTap: () => _showInvoiceDetail(context, inv, isDark),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: inv['status'] == 'overdue' ? AppColors.danger.withValues(alpha: 0.3) : (isDark ? AppColors.darkBorder : AppColors.border)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _statusColor(inv['status'] as String).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.receipt_long, size: 20, color: _statusColor(inv['status'] as String)),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(inv['id'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(inv['amount'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 4),
              Text(inv['client'] as String, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Row(children: [
                Text('Due: ${inv['due']}', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const Spacer(),
                _statusBadge(inv['status'] as String),
              ]),
            ])),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    switch (status) {
      case 'paid': return StatusBadge.paid();
      case 'overdue': return StatusBadge.overdue();
      default: return StatusBadge.unpaid();
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'paid': return AppColors.success;
      case 'overdue': return AppColors.danger;
      default: return AppColors.warning;
    }
  }

  void _showInvoiceDetail(BuildContext context, Map<String, dynamic> inv, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7, maxChildSize: 0.95, minChildSize: 0.4, expand: false,
        builder: (ctx, sc) => ListView(
          controller: sc,
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Text(inv['id'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const Spacer(),
              _statusBadge(inv['status'] as String),
            ]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.scaffoldBg, borderRadius: BorderRadius.circular(10)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Bill To', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                const SizedBox(height: 4),
                Text(inv['client'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(inv['project'] as String, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ]),
            ),
            const SizedBox(height: 16),
            Row(children: [
              _infoPill('Issued', inv['issue'] as String),
              const SizedBox(width: 12),
              _infoPill('Due', inv['due'] as String),
            ]),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text('Line Items', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            _lineItem('Development work', '40 hrs × \$50', '\$2,000'),
            _lineItem('Design services', '10 hrs × \$50', '\$500'),
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              Text(inv['amount'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Download PDF'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('Mark as Paid'))),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _infoPill(String label, String value) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.scaffoldBg, borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
    ));
  }

  Widget _lineItem(String desc, String qty, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(desc, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text(qty, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ])),
        Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
