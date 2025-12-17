import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_store.dart';
import '../providers/auth_provider.dart';

class CreateEventScreen extends StatefulWidget {
  static const routeName = "/createEvent";

  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      return;
    }

    final auth = context.read<AuthProvider>();
    final user = auth.user;

    if (user == null) return;

    setState(() => _isLoading = true);

    final event = EventModel(
      id: "", // Firestore otomatik verecek
      title: _titleController.text.trim(),
      category: _categoryController.text.trim(),
      date: _selectedDate!,
      time: _timeController.text.trim(),
      location: _locationController.text.trim(),
      description: _descriptionController.text.trim(),
      ownerId: user.uid,
      isApproved: false, // ✅ admin onayı bekleyecek
    );


    await EventStore.addEvent(event);

    setState(() => _isLoading = false);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Category"),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: "Time"),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descriptionController,
                decoration:
                const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              ListTile(
                title: Text(
                  _selectedDate == null
                      ? "Select Date"
                      : "Date: ${_selectedDate!.toLocal().toString().split(" ")[0]}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Create Event"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
