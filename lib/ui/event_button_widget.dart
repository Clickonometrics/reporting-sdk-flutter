import 'package:flutter/material.dart';

class EventButtonWidget extends StatefulWidget {
  const EventButtonWidget({Key? key, required this.text, this.onPress}) : super(key: key);

  final String text;
  final VoidCallback? onPress;

  @override
  State<EventButtonWidget> createState() => _EventButtonWidgetState();
}

class _EventButtonWidgetState extends State<EventButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: ElevatedButton(
        onPressed: () {
          widget.onPress?.call();
        },
        child: Text(
          widget.text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}