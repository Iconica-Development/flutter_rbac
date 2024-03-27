import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: onPressed,
        style: const ButtonStyle(
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          backgroundColor: MaterialStatePropertyAll(
            Color(0xFFFAF9F7),
          ),
          side: MaterialStatePropertyAll(
            BorderSide(
              color: Color(0xFF212121),
              width: 3,
            ),
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Avenir',
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Color(0xFF212121),
          ),
        ),
      );
}
