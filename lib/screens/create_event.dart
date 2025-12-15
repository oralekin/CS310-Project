import 'package:flutter/material.dart';
import '../models/event_store.dart';

class CreateEventScreen extends StatefulWidget {
  static const routeName = "/createEvent";

  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _location = '';
  String? _selectedCategory;
  String _dateText = 'Pick Date';
  String _timeText = 'Pick Time';

  DateTime? _selectedDate; // ✅ ARKA PLANDA DateTime TUTULUR

  final List<String> _categories = [
    'Workshop',
    'Social',
    'Sports',
    'Seminar',
  ];

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick a date')),
        );
        return;
      }

      globalEvents.add(
        EventModel(
          title: _title,
          description: _description,
          category: _selectedCategory ?? '',
          date: _selectedDate!, // ✅ ARTIK DateTime
          time: _timeText,
          location: _location,
        ),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Event Saved'),
          content: const Text('Your event has been created successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/adminHome');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushNamed(context, '/adminHome');
                  },
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Create Event',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text('Event Title',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter event title',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                  (value == null || value.isEmpty)
                      ? 'Title cannot be empty'
                      : null,
                  onSaved: (value) => _title = value ?? '',
                ),

                const SizedBox(height: 16),

                const Text('Description',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Short event description...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                  (value == null || value.isEmpty)
                      ? 'Description cannot be empty'
                      : null,
                  onSaved: (value) => _description = value ?? '',
                ),

                const SizedBox(height: 16),

                const Text('Category',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: _selectedCategory,
                  hint: const Text('Select category'),
                  items: _categories
                      .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value);
                  },
                ),

                const SizedBox(height: 16),

                const Text('Date & Time',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                          );

                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                              _dateText =
                              "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_dateText,
                                style:
                                const TextStyle(color: Colors.black87)),
                            const SizedBox(width: 6),
                            const Icon(Icons.calendar_today_outlined,
                                size: 18, color: Colors.black87),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (picked != null) {
                            setState(() {
                              _timeText = picked.format(context);
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_timeText,
                                style:
                                const TextStyle(color: Colors.black87)),
                            const SizedBox(width: 6),
                            const Icon(Icons.access_time,
                                size: 18, color: Colors.black87),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                const Text('Location',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'e.g. FMAN G040',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) =>
                  (value == null || value.isEmpty)
                      ? 'Location cannot be empty'
                      : null,
                  onSaved: (value) => _location = value ?? '',
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _saveEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Event',
                      style:
                      TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
