import 'package:flutter/material.dart';
import 'package:uniconnect/widgets/date_picker.dart';

Text _label(String s) => Text(
  s,
  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
);

class SearchFilterScreen extends StatefulWidget {
  static const routeName = '/search';

  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _searchQuery;
  String? _selectedUniversity;
  final List<String> _selectedCategories = [];

  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _universities = [
    "Sabanci University",
    "Leiden University",
  ];

  final List<String> _categories = [
    "Workshop",
    "Seminar",
    "Culture",
  ];

  void _clearFilters() {
    setState(() {
      _searchQuery = null;
      _selectedUniversity = null;
      _selectedCategories.clear();
      _startDate = null;
      _endDate = null;
    });
    _formKey.currentState?.reset();
  }

  void _applyFilters() {
    Navigator.pop(context, {
      "query": _searchQuery,
      "university": _selectedUniversity,
      "categories": _selectedCategories,
      "startDate": _startDate,
      "endDate": _endDate,
    });
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔹 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Filter Events",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _clearFilters,
            child: const Text("Clear"),
          ),
        ],
      ),

      /// 🔹 BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// SEARCH
                TextFormField(
                  initialValue: _searchQuery,
                  decoration: InputDecoration(
                    hintText: "Search by name or keyword",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) => _searchQuery = v,
                ),

                const SizedBox(height: 24),

                /// UNIVERSITY
                _label("University"),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedUniversity,
                  hint: const Text("Select University"),
                  items: _universities
                      .map(
                        (u) => DropdownMenuItem(
                      value: u,
                      child: Text(u),
                    ),
                  )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedUniversity = v),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// CATEGORY
                _label("Category"),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _categories.map((cat) {
                    final selected = _selectedCategories.contains(cat);
                    return ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (s) {
                        setState(() {
                          s
                              ? _selectedCategories.add(cat)
                              : _selectedCategories.remove(cat);
                        });
                      },
                      selectedColor: Colors.grey[300],
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                /// DATE
                _label("Date"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickStartDate,
                        child: AbsorbPointer(
                          child: FormDatePickerField(
                            placeholder: _startDate == null
                                ? "Start Date"
                                : _fmtDate(_startDate!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickEndDate,
                        child: AbsorbPointer(
                          child: FormDatePickerField(
                            placeholder: _endDate == null
                                ? "End Date"
                                : _fmtDate(_endDate!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// APPLY BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Apply Filters",
                        style:
                        TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return "$dd/$mm/$yy";
  }
}
