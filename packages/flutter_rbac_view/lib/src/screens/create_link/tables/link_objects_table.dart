// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/widgets/block_header.dart';
import 'package:flutter_rbac_view/src/widgets/primary_button.dart';
import 'package:flutter_rbac_view/src/widgets/secondary_button.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';

class CreateLinkObjectTable extends StatefulWidget {
  const CreateLinkObjectTable({
    required this.rbacService,
    required this.objectIds,
    required this.onBack,
    required this.onSave,
    super.key,
  });

  final RbacService rbacService;
  final Set<String> objectIds;
  final VoidCallback onBack;
  final void Function(
    Set<String> objectIds,
  ) onSave;

  @override
  State<CreateLinkObjectTable> createState() => _CreateLinkObjectTableState();
}

class _CreateLinkObjectTableState extends State<CreateLinkObjectTable> {
  late Future<List<SecurableObjectModel>> dataFuture;

  late Set<String> objectIds = widget.objectIds;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List<SecurableObjectModel>> getData() async {
    var allObjects = await widget.rbacService.getAllSecurableObjects();

    return allObjects;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Create link',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              const Spacer(),
              SecondaryButton(
                text: objectIds.isEmpty ? 'Previous' : 'Cancel',
                onPressed: () async {
                  if (objectIds.isEmpty) {
                    widget.onBack();
                  } else {
                    setState(() {
                      objectIds = {};
                    });
                  }
                },
              ),
              const SizedBox(
                width: 8,
              ),
              PrimaryButton(
                text: 'Save',
                onPressed: () async {
                  widget.onSave(objectIds);
                },
                enabled: objectIds.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const BlockHeader(
            titles: [('Name', 1), ('ID', 2)],
            trailingIcon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            leftPadding: 57,
          ),
          const SizedBox(
            height: 6,
          ),
          FutureBuilder<List<SecurableObjectModel>>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                );
              }

              var allObjects = snapshot.data!;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < allObjects.length; i++) ...[
                    Row(
                      children: [
                        Checkbox(
                          value: objectIds.contains(allObjects[i].id),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                if (value) {
                                  objectIds.add(allObjects[i].id);
                                } else {
                                  objectIds.remove(allObjects[i].id);
                                }
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
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ListItem(
                            data: [
                              (allObjects[i].name, 1),
                              (allObjects[i].id, 2),
                            ],
                            rightPadding: 52,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      );
}
