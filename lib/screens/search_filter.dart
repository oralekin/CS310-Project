import 'dart:core';

import 'package:flutter/material.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final UniqueKey _formKey = UniqueKey();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text("Filter Events")),
    body: Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                fillColor: Color(0xFFE0E0E0),
                hintStyle: TextStyle(color: Color(0xFFA0A0A0)),
                icon: Icon(Icons.search),
                hint: Text(
                  "Search by name or keyword",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text("University"),
            DropdownMenuFormField(dropdownMenuEntries: []),
            SizedBox(height: 10),
            Text("Category"),
            Wrap(
              spacing: 10,
              children: [
                Text("abcd"),
                Text("abcd"),
                Text("abcd"),
                Text("abcd"),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormField<DateTime>(
                  builder: (formState) => DatePicker(formState),
                  // initialValue: DateTime.now(),
                ),
                FormField<DateTime>(
                  builder: (formState) => DatePicker(formState),
                  // initialValue: DateTime.now(),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class DatePicker extends StatelessWidget {
  final FormFieldState<DateTime> formState;

  Future<void> _selectDate() {
    return showDatePicker(
      context: formState.context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then(formState.didChange);
  }

  String dateFormat(DateTime? d) => d == null
      ? "DD/MM/YYYY"
      : "${d.day.toString().padLeft(2)}/${d.month.toString().padLeft(2)}/${d.year.toString().padLeft(4)}";

  const DatePicker(this.formState, {super.key});
  //   @override
  //   State<StatefulWidget> createState() => _DatePickerState();
  // }

  // class _DatePickerState extends State<DatePicker> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: GestureDetector(
        onTap: () => _selectDate(),
        child: Text(dateFormat(formState.value)),
      ),
    );
  }
}
