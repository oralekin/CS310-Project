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
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedUniversity;
  DateTime? _selectedDate;

  bool _isLoading = false;

  final List<String> _categories = [
    "Workshop",
    "Seminar",
    "Culture",
  ];

  final List<String> _universities = [
    "Sabancı University",
    "Koç University",
    "Boğaziçi University",
    "ITU",
  ];

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
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _selectedCategory == null ||
        _selectedUniversity == null) {
      return;
    }

    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user == null) return;

    setState(() => _isLoading = true);

    final event = EventModel(
      id: "",
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      date: _selectedDate!,
      time: _timeController.text.trim(),
      location: _locationController.text.trim(),
      university: _selectedUniversity!,
      ownerId: user.uid,
      isApproved: false, // 🔒 admin approval
    );

    await EventStore.addEvent(event);

    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event (Admin)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// TITLE
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Event Title"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              /// CATEGORY
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                decoration: const InputDecoration(labelText: "Category"),
                validator: (v) => v == null ? "Required" : null,
              ),
              const SizedBox(height: 12),

              /// UNIVERSITY
              DropdownButtonFormField<String>(
                value: _selectedUniversity,
                items: _universities
                    .map(
                      (u) => DropdownMenuItem(
                        value: u,
                        child: Text(u),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedUniversity = v),
                decoration: const InputDecoration(labelText: "University"),
                validator: (v) => v == null ? "Required" : null,
              ),
              const SizedBox(height: 12),

              /// TIME
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: "Time"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              /// LOCATION
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              /// DESCRIPTION
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              /// DATE
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

              /// SUBMIT
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
