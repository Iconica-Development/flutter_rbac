// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_view/src/widgets/primary_button.dart';

class NameDialog extends StatefulWidget {
  const NameDialog({
    required this.title,
    required this.onSuccesfullCommit,
    super.key,
  });

  final String title;
  final Future<void> Function(String name) onSuccesfullCommit;

  @override
  State<NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<NameDialog> {
  var formKey = GlobalKey<FormState>();
  String? input;

  var loading = false;

  @override
  Widget build(BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 52,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF212121)),
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.white,
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 300,
                child: TextFormField(
                  style: const TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF212121),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Input',
                    hintStyle: TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF8D8D8D),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Input can not be empty';
                    }

                    return null;
                  },
                  onSaved: (newValue) {
                    input = newValue;
                  },
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              PrimaryButton(
                onPressed: () async {
                  if (!loading) {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState?.save();

                      setState(() {
                        loading = true;
                      });

                      await widget.onSuccesfullCommit(input!);

                      if (context.mounted) Navigator.of(context).pop(input);
                    }
                  }
                },
                text: 'Save',
              ),
              const SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF8D8D8D),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
