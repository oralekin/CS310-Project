import 'dart:core';

import 'package:flutter/material.dart';
import 'package:uniconnect/widgets/date_picker.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Filter Events"),
      actions: [
        TextButton(
          onPressed: () => _formKey.currentState?.reset(),
          child: Text("Clear"),
        ),
      ],
    ),
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
            FormField<List<String>>(
              builder: (formState) => Wrap(
                spacing: 4,
                runSpacing: 4,
                children: ["some", "categories", "here"]
                    .map(
                      (name) => FilterChip(
                        label: Text(name),
                        onSelected: (s) {
                          final newList = formState.value!;
                          if (s) {
                            newList.add(name);
                          } else {
                            newList.remove(name);
                          }
                          formState.didChange(newList);
                        },
                        selected: formState.value!.contains(name),
                      ),
                    )
                    .toList(),
              ),
              initialValue: [],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [FormDatePickerField(), FormDatePickerField()],
            ),
          ],
        ),
      ),
    ),
  );
}
