import 'dart:core';

import 'package:flutter/material.dart';
import 'package:uniconnect/widgets/date_picker.dart';

makeLabel(String s) =>
    Text(s, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600));

class SearchFilterScreen extends StatefulWidget {
  static const routeName = '/search';

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

    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: Icon(Icons.search),
                    hint: Text(
                      "Search by name or keyword",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                makeLabel("University"),
                DropdownMenuFormField(
                  hintText: "Select University",
                  dropdownMenuEntries:
                      ["Sabanci University", "Leiden University"]
                          .map(
                            (uni) => DropdownMenuEntry(label: uni, value: uni),
                          )
                          .toList(),
                ),
                SizedBox(height: 10),
                makeLabel("Category"),
                FormField<List<String>>(
                  builder: (formState) => Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: ["Workshop", "Seminar", "Culture"]
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
                makeLabel("Date"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FormDatePickerField(placeholder: "Start Date"),
                    FormDatePickerField(placeholder: "End Date"),
                  ],
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // go to events list
                    },
                    child: Text("Apply Filters"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
