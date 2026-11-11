import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'registration_section_card.dart';

class ParticipantForm extends StatelessWidget {
  const ParticipantForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return RegistrationSectionCard(
      title: 'Data peserta',
      child: Column(
        children: [
          _ParticipantField(
            controller: nameController,
            label: 'Nama lengkap',
            hint: 'Masukkan nama peserta',
            icon: Icons.person_outline,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Nama wajib diisi'
                : null,
          ),
          const SizedBox(height: 12),
          _ParticipantField(
            controller: emailController,
            label: 'Email',
            hint: 'nama@email.com',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) return 'Email wajib diisi';
              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                return 'Masukkan alamat email yang valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          _ParticipantField(
            controller: phoneController,
            label: 'Nomor WhatsApp',
            hint: '08xxxxxxxxxx',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
              if (digits.length < 9) return 'Masukkan nomor yang valid';
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class _ParticipantField extends StatelessWidget {
  const _ParticipantField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorMaxLines: 2,
      ),
    );
  }
}
