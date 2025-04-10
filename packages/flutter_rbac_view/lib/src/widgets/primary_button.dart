// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onPressed,
    required this.text,
    this.enableAddIcon = false,
    this.enabled = true,
    super.key,
  });

  final void Function() onPressed;
  final String text;
  final bool enableAddIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: enabled ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            enabled ? const Color(0xFF71C6D1) : const Color(0xFFB5DADF),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (enableAddIcon) ...[
              const Icon(
                Icons.add,
                color: Colors.white,
              ),
              const SizedBox(
                width: 8,
              ),
            ],
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: enabled ? Colors.white : const Color(0xFFFDFCFB),
              ),
            ),
          ],
        ),
      );
}
