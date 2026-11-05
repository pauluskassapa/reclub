import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/managed_event.dart';
import '../widgets/event_category_selector.dart';
import '../widgets/event_date_picker.dart';
import '../widgets/event_description_field.dart';
import '../widgets/event_form_header.dart';
import '../widgets/event_location_field.dart';
import '../widgets/event_name_field.dart';
import '../widgets/event_submit_button.dart';
import '../widgets/managed_event_card.dart';

class ManageEventPage extends StatefulWidget {
  const ManageEventPage({
    super.key,
    this.onEventsChanged,
    this.initialEvents = const [],
  });

  final ValueChanged<List<ManagedEvent>>? onEventsChanged;
  final List<ManagedEvent> initialEvents;

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  late final List<ManagedEvent> _events;

  DateTime? _selectedDateTime;

  String _selectedCategory = 'Sepak bola';

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _events = [...widget.initialEvents];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submitEvent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tanggal dan waktu kegiatan.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final event = ManagedEvent(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      dateTime: _selectedDateTime!,
      location: _locationController.text.trim(),
      category: _selectedCategory,
    );

    setState(() {
      if (_editingIndex != null) {
        _events[_editingIndex!] = event;
      } else {
        _events.add(event);
      }
    });
    widget.onEventsChanged?.call(List.unmodifiable(_events));

    final isEditing = _editingIndex != null;

    _resetForm();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? 'Kegiatan berhasil diperbarui.'
              : 'Kegiatan berhasil dibuat.',
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _locationController.clear();

    setState(() {
      _selectedDateTime = null;
      _selectedCategory = 'Sepak bola';
      _editingIndex = null;
    });
  }

  void _editEvent(int index) {
    final event = _events[index];

    _nameController.text = event.name;
    _descriptionController.text = event.description;
    _locationController.text = event.location;

    setState(() {
      _selectedDateTime = event.dateTime;
      _selectedCategory = event.category;
      _editingIndex = index;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Silakan ubah informasi kegiatan.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteEvent(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kegiatan'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus kegiatan ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _events.removeAt(index);

      if (_editingIndex == index) {
        _resetForm();
      } else if (_editingIndex != null && _editingIndex! > index) {
        _editingIndex = _editingIndex! - 1;
      }
    });
    widget.onEventsChanged?.call(List.unmodifiable(_events));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kegiatan berhasil dihapus.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Kelola Kegiatan',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            const EventFormHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventNameField(controller: _nameController),

                      const SizedBox(height: 18),

                      EventDescriptionField(controller: _descriptionController),

                      const SizedBox(height: 18),

                      EventCategorySelector(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      EventDatePicker(
                        selectedDateTime: _selectedDateTime,
                        onDateTimeSelected: (dateTime) {
                          setState(() {
                            _selectedDateTime = dateTime;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      EventLocationField(controller: _locationController),

                      const SizedBox(height: 24),

                      EventSubmitButton(
                        onPressed: _submitEvent,
                        isEditing: _editingIndex != null,
                      ),

                      if (_editingIndex != null) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: _resetForm,
                            child: const Text(
                              'Batal Mengedit',
                              style: TextStyle(color: AppColors.mutedText),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Kegiatan Saya',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_events.length} kegiatan',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            if (_events.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.event_note_outlined,
                        size: 48,
                        color: AppColors.mutedText,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Belum Ada Kegiatan',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Kegiatan yang kamu buat akan muncul di sini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.mutedText),
                      ),
                    ],
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(_events.length, (index) {
                    return ManagedEventCard(
                      event: _events[index],
                      onEdit: () => _editEvent(index),
                      onDelete: () => _deleteEvent(index),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
