// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_view/src/models/selectable_dialog_item.dart';
import 'package:flutter_rbac_view/src/widgets/primary_button.dart';

class SelectDialog extends StatefulWidget {
  const SelectDialog({
    required this.title,
    required this.onSuccesfullCommit,
    required this.items,
    super.key,
  });

  final String title;
  final Future<void> Function(Set<String> name) onSuccesfullCommit;
  final List<SelectableDialogItem> items;

  @override
  State<SelectDialog> createState() => _SelectDialogState();
}

class _SelectDialogState extends State<SelectDialog> {
  Set<String> selectedIds = {};

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
        content: Column(
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
            for (var item in widget.items) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Checkbox(
                        value: selectedIds.contains(item.id),
                        onChanged: (value) {
                          if (value == null) return;

                          if (value) {
                            setState(() {
                              selectedIds.add(item.id);
                            });
                          } else {
                            setState(() {
                              selectedIds.remove(item.id);
                            });
                          }
                        },
                        fillColor: MaterialStateProperty.resolveWith(
                          (states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.black;
                            }

                            return Colors.white;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'Avenir',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(
                            0xFF212121,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(
              height: 24,
            ),
            PrimaryButton(
              enabled: selectedIds.isNotEmpty,
              onPressed: () async {
                if (!loading) {
                  setState(() {
                    loading = true;
                  });

                  await widget.onSuccesfullCommit(selectedIds);

                  if (context.mounted) Navigator.of(context).pop(selectedIds);
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
      );
}
