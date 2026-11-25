import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/feed_service.dart';

class CreateFeedPage extends StatefulWidget {
  const CreateFeedPage({super.key, required this.service});
  final FeedService service;

  @override
  State<CreateFeedPage> createState() => _CreateFeedPageState();
}

class _CreateFeedPageState extends State<CreateFeedPage> {
  final _form = GlobalKey<FormState>();
  final _club = TextEditingController();
  final _title = TextEditingController();
  final _message = TextEditingController();
  String _category = 'Futsal';
  bool _sending = false;
  String? _error;
  XFile? _selectedImage;

  static const images = {
    'Futsal': 'assets/images/futsal.jpg',
    'Badminton': 'assets/images/badminton.jpg',
    'Basket': 'assets/images/basket.jpg',
    'Lari': 'assets/images/running.jpg',
    'Voli': 'assets/images/volleyball.jpg',
    'Tenis': 'assets/images/tennis.jpg',
    'Sepeda': 'assets/images/cycling.jpg',
    'Renang': 'assets/images/swimming.jpg',
    'Yoga': 'assets/images/yoga.jpg',
    'Pingpong': 'assets/images/pingpong.jpg',
  };

  @override
  void dispose() {
    _club.dispose();
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_sending || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await widget.service.submitPost(
        club: _club.text.trim(),
        category: _category,
        title: _title.text.trim(),
        message: _message.text.trim(),
        imagePath: images[_category]!,
        image: _selectedImage,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _error = 'Pengiriman belum dapat dikonfirmasi. Cek koneksi dan hubungi pengelola sebelum mengirim ulang.';
      });
    }
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (image != null && mounted) setState(() => _selectedImage = image);
  }

  Widget _field(
    TextEditingController controller,
    String label,
    int limit, {
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: !_sending,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLength: limit,
        minLines: lines,
        maxLines: lines,
        validator: (value) =>
            (value ?? '').trim().isEmpty ? '$label wajib diisi' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_sending,
      child: Scaffold(
        appBar: AppBar(title: const Text('Buat postingan')),
        body: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Bagikan kabar olahraga. Postingan akan tampil setelah disetujui pengelola.',
              ),
              const SizedBox(height: 20),
              _field(_club, 'Nama pengirim / klub', 80),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Olahraga',
                  border: OutlineInputBorder(),
                ),
                items: images.keys
                    .map(
                      (name) =>
                          DropdownMenuItem(value: name, child: Text(name)),
                    )
                    .toList(),
                onChanged: _sending
                    ? null
                    : (value) => setState(() => _category = value!),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _selectedImage == null
                    ? Image.asset(
                        images[_category]!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : FutureBuilder<Uint8List>(
                        future: _selectedImage!.readAsBytes(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(
                              height: 160,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return Image.memory(
                            snapshot.data!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedImage == null
                          ? 'Foto ilustrasi sesuai olahraga yang dipilih.'
                          : 'Foto dari galeri akan dipakai untuk postingan.',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _sending ? null : _pickImage,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(
                      _selectedImage == null ? 'Pilih foto' : 'Ganti foto',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _field(_title, 'Judul', 120),
              _field(_message, 'Isi postingan', 2000, lines: 5),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              FilledButton.icon(
                onPressed: _sending ? null : _submit,
                icon: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_outlined),
                label: Text(_sending ? 'Mengirim...' : 'Kirim postingan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
