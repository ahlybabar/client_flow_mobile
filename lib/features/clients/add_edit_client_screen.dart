import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AddEditClientScreen extends StatefulWidget {
  final Map<String, dynamic>? client;
  const AddEditClientScreen({super.key, this.client});

  @override
  State<AddEditClientScreen> createState() => _AddEditClientScreenState();
}

class _AddEditClientScreenState extends State<AddEditClientScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyController;
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  bool get isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.client?['company'] ?? '');
    _contactController = TextEditingController(text: widget.client?['contact'] ?? '');
    _emailController = TextEditingController(text: widget.client?['email'] ?? '');
    _phoneController = TextEditingController(text: widget.client?['phone'] ?? '');
    _addressController = TextEditingController(text: widget.client?['address'] ?? '');
  }

  @override
  void dispose() {
    _companyController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Client' : 'New Client'),
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
            // Company icon
            Center(
              child: Container(
                width: 72, height: 72,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _companyController.text.isNotEmpty ? _companyController.text.substring(0, 1).toUpperCase() : 'C',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ),
            ),

            _label('Company Name'),
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(hintText: 'Enter company name', prefixIcon: Icon(Icons.business_outlined, size: 20)),
              onChanged: (_) => setState(() {}),
              validator: (v) => v == null || v.trim().isEmpty ? 'Company name is required' : null,
            ),
            const SizedBox(height: 16),

            _label('Contact Person'),
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(hintText: 'Full name', prefixIcon: Icon(Icons.person_outline, size: 20)),
              validator: (v) => v == null || v.trim().isEmpty ? 'Contact person is required' : null,
            ),
            const SizedBox(height: 16),

            _label('Email'),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'email@company.com', prefixIcon: Icon(Icons.email_outlined, size: 20)),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim())) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),

            _label('Phone'),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: '+1 555-0100', prefixIcon: Icon(Icons.phone_outlined, size: 20)),
            ),
            const SizedBox(height: 16),

            _label('Address'),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Street, City, State', prefixIcon: Icon(Icons.location_on_outlined, size: 20)),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Update Client' : 'Add Client'),
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'company': _companyController.text.trim(),
      'contact': _contactController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'projects': widget.client?['projects'] ?? 0,
      'status': widget.client?['status'] ?? 'active',
      'since': widget.client?['since'] ?? 'March 2025',
      'totalInvoiced': widget.client?['totalInvoiced'] ?? '\$0',
      'totalPaid': widget.client?['totalPaid'] ?? '\$0',
      'outstanding': widget.client?['outstanding'] ?? '\$0',
    };

    Navigator.pop(context, data);
  }
}
