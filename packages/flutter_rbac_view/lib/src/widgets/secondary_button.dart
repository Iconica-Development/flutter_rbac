// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

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
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          backgroundColor: WidgetStatePropertyAll(
            Color(0xFFFAF9F7),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(
              color: Color(0xFF212121),
              width: 3,
            ),
          ),
          shape: WidgetStatePropertyAll(
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
