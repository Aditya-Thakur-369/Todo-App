import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? pre;
  final Widget? sur;
  final String? Function(String?)? validator;
  final bool autofocus;

  const CustomTextFormField(
      {required this.labelText,
      required this.hintText,
      required this.controller,
      this.obscureText = false,
      this.pre,
      this.sur,
      this.validator,
      this.autofocus = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: labelText,
          hintText: hintText,
          prefixIcon: pre,
          suffixIcon: sur,
        ),
        autofocus: autofocus,
        obscureText: obscureText,
        validator: validator);
  }
}

class CustomElevatedButton extends StatefulWidget {
  final String message;
  final Future Function()? function;

  const CustomElevatedButton({
    required this.message,
    this.function,
  });

  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          loading = true;
        });

        if (widget.function != null) {
          await widget.function!();
        }

        setState(() {
          loading = false;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(left: 150, right: 150, top: 12, bottom: 12),
        ),
        elevation: MaterialStateProperty.all(1),
      ),
      child: loading
          ? SpinKitWave(
              color: Colors.white,
              size: 25,
            )
          : FittedBox(
              child: Text(
                widget.message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}

class CustomSnackBar {
  static void showSnackBar(
      BuildContext context, String label, Function() onPressed, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: label,
        onPressed: onPressed,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class Format {
  static String date(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }
}

class DatePicker extends StatelessWidget {
  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onSelectedDate;

  const DatePicker({
    required this.labelText,
    required this.selectedDate,
    this.onSelectedDate,
  });

  Future<void> selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectedDate?.call(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.titleLarge!;
    return Expanded(
      flex: 5,
      child: InputDropdown(
        labelText: labelText,
        valueText: Format.date(selectedDate),
        valueStyle: valueStyle,
        onPressed: () => selectDate(context),
      ),
    );
  }
}

class TimePicker extends StatelessWidget {
  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay>? onSelectedTime;

  const TimePicker({
    required this.labelText,
    required this.selectedTime,
    this.onSelectedTime,
  });

  Future<void> selectTime(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null && pickedTime != selectedTime) {
      onSelectedTime?.call(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.titleLarge!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () => selectTime(context),
          ),
        ),
      ],
    );
  }
}

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key? key,
    this.labelText,
    required this.valueText,
    required this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String? labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
