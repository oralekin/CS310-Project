import 'package:flutter/material.dart';

const String ddmmyyyyPlaceholder = "DD/MM/YYYY";
String ddmmyyyyFormatter(DateTime d) {
  return "${d.day.toString().padLeft(2)}/${d.month.toString().padLeft(2)}/${d.year.toString().padLeft(4)}";
}

class DatePicker extends StatelessWidget {
  final FormFieldState<DateTime> formState;

  final String placeholder;
  final String Function(DateTime) formatter;

  Future<void> _selectDate() {
    return showDatePicker(
      context: formState.context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then(formState.didChange);
  }

  String dateFormat(DateTime? d) => d == null ? "DD/MM/YYYY" : formatter(d);

  const DatePicker({
    super.key,
    required this.formState,
    this.placeholder = ddmmyyyyPlaceholder,
    this.formatter = ddmmyyyyFormatter,
  });

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
  }) : super(builder: (formState) => DatePicker(formState: formState));
}
