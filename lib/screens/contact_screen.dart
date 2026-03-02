// lib/screens/contact_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/theme/app_theme.dart';
import '../widgets/gradient_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  EmailJS Configuration
//  ➜ Sign up FREE at https://www.emailjs.com
//  ➜ Create a service (Gmail / Outlook)  → copy Service ID
//  ➜ Create an email template            → copy Template ID
//  ➜ Account → API Keys                  → copy Public Key
//
//  Template variables to use:
//    {{from_name}}  {{from_email}}  {{phone}}
//    {{service_req}} {{message}}   {{to_email}}
// ─────────────────────────────────────────────────────────────────────────────
const String _emailJsServiceId  = 'service_02x35wb';
const String _emailJsTemplateId = 'template_vcy0wn9';
const String _emailJsPublicKey  = 'WdPVCZDQAmzXcV9NR';
const String _adminEmail        = 'ayaangundkalli13@gmail.com';


class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();
  String? _selectedService;
  bool _isLoading = false;

  late AnimationController _entranceCtrl;

  static const _services = [
    'Mobile App Development',
    'Web Development',
    'UI/UX Designing',
    'Graphic Designing',
    'Excel Solutions',
    'Photo & Video Editing',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _messageCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  Future<bool> _sendEmail() async {
  const url = 'https://api.emailjs.com/api/v1.0/email/send';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'origin': 'http://localhost', // ✅ VERY IMPORTANT
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id':  _emailJsServiceId,
        'template_id': _emailJsTemplateId,
        'user_id':     _emailJsPublicKey,
        'template_params': {
          'to_email':    _adminEmail,
          'from_name':   _nameCtrl.text.trim(),
          'from_email':  _emailCtrl.text.trim(),
          'phone':       _phoneCtrl.text.trim(),
          'service_req': _selectedService ?? 'Not specified',
          'message':     _messageCtrl.text.trim().isEmpty
              ? 'No message provided.'
              : _messageCtrl.text.trim(),
        },
      }),
    );

    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    return response.statusCode == 200;
  } catch (e) {
    debugPrint('EmailJS error: $e');
    return false;
  }
}

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    debugPrint('=== Contact Form ===');
    debugPrint('Name:    ${_nameCtrl.text}');
    debugPrint('Email:   ${_emailCtrl.text}');
    debugPrint('Phone:   ${_phoneCtrl.text}');
    debugPrint('Service: $_selectedService');
    debugPrint('Message: ${_messageCtrl.text}');

    final success = await _sendEmail();
    setState(() => _isLoading = false);
    if (!mounted) return;

    _showSnack(
      success
          ? 'Request sent! We\'ll be in touch within 24 hours. ✨'
          : 'Failed to send. Please check your EmailJS config.',
      success,
    );
    if (success) _resetForm();
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameCtrl.clear();
    _emailCtrl.clear();
    _phoneCtrl.clear();
    _messageCtrl.clear();
    setState(() => _selectedService = null);
  }

  void _showSnack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_rounded : Icons.error_rounded,
              color: Colors.white, size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(msg,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ],
        ),
        backgroundColor: success ? AppTheme.green : const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark  = colors.isDark;

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: AnimatedBuilder(
        animation: _entranceCtrl,
        builder: (context, child) {
          final t = Curves.easeOut.transform(_entranceCtrl.value);
          return Opacity(opacity: t, child: child);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header card ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary.withOpacity(isDark ? 0.15 : 0.08),
                      AppTheme.accent.withOpacity(isDark ? 0.08 : 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(isDark ? 0.25 : 0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        gradient: AppTheme.brandGradient,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.35),
                            blurRadius: 12, offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Let's Work Together",
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 3),
                          Text("We'll get back to you within 24 hours.",
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Form ────────────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Full Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Name is required';
                        if (v.trim().length < 2) return 'Minimum 2 characters';
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),
                    _fieldLabel('Email Address'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        final re = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!re.hasMatch(v.trim())) return 'Enter a valid email';
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),
                    _fieldLabel('Phone Number'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.phone_outlined, size: 20),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Phone number is required';
                        if (v.trim().length < 7) return 'Enter a valid phone number';
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),
                    _fieldLabel('Service Required'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedService,
                      decoration: const InputDecoration(
                        hintText: 'Select a service',
                        prefixIcon: Icon(Icons.grid_view_outlined, size: 20),
                      ),
                      dropdownColor: colors.cardBg,
                      items: _services.map((s) =>
                          DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => _selectedService = v),
                      validator: (v) => v == null ? 'Please select a service' : null,
                    ),

                    const SizedBox(height: 18),
                    _fieldLabel('Message  (Optional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageCtrl,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Tell us about your project...',
                      ),
                    ),

                    const SizedBox(height: 30),

                    _isLoading
                        ? Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: AppTheme.brandGradient,
                              borderRadius: BorderRadius.circular(AppTheme.radiusM),
                              boxShadow: AppTheme.buttonGlow,
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5),
                              ),
                            ),
                          )
                        : GradientButton(
                            label: 'Send Request',
                            icon: Icons.send_rounded,
                            onPressed: _submit,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.appColors.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
      );
}