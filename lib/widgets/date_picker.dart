import 'package:flutter/material.dart';

const String ddmmyyyyPlaceholder = "DD/MM/YYYY";
String ddmmyyyyFormatter(DateTime d) {
  return "${d.day.toString().padLeft(2)}/${d.month.toString().padLeft(2)}/${d.year.toString().padLeft(4)}";
}

class DatePicker extends StatelessWidget {
  final FormFieldState<DateTime> formState;

  final DateTime? firstDate;
  final DateTime? lastDate;

  final String? placeholder;
  final String Function(DateTime)? formatter;

  Future<void> _selectDate() {
    return showDatePicker(
      context: formState.context,
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
    ).then(formState.didChange);
  }

  String dateFormat(DateTime? d) => d == null
      ? (placeholder ?? ddmmyyyyPlaceholder)
      : (formatter ?? ddmmyyyyFormatter)(d);

  const DatePicker({
    super.key,
    required this.formState,
    this.firstDate,
    this.lastDate,
    this.placeholder,
    this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: GestureDetector(
        onTap: () => _selectDate(),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE6E6E6), // light grey like screenshot
            borderRadius: BorderRadius.circular(12), // rounded pill-ish
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 8),
              Text(
                dateFormat(formState.value),
                style: TextStyle(
                  color: formState.value == null ? Colors.grey : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TODO: there might be a better way to do this
class FormDatePickerField extends FormField<DateTime> {
  FormDatePickerField({
    super.key,
    super.autovalidateMode,
    super.enabled,
    super.errorBuilder,
    super.forceErrorText,
    super.initialValue,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,

    firstDate,
    lastDate,
    placeholder,
    formatter,
  }) : super(
         builder: (formState) => DatePicker(
           formState: formState,
           firstDate: firstDate,
           lastDate: lastDate,
           placeholder: placeholder,
           formatter: formatter,
         ),
       );
}
