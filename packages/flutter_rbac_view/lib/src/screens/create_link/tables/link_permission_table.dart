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

class CreateLinkPermissionTable extends StatefulWidget {
  const CreateLinkPermissionTable({
    required this.rbacService,
    required this.permissionIds,
    required this.permissionGroupIds,
    required this.onBack,
    required this.onSave,
    super.key,
  });

  final RbacService rbacService;
  final Set<String> permissionIds;
  final Set<String> permissionGroupIds;
  final VoidCallback onBack;
  final void Function(
    Set<String> permissionIds,
    Set<String> permissionGroupIds,
  ) onSave;

  @override
  State<CreateLinkPermissionTable> createState() =>
      _CreateLinkPermissionTableState();
}

class _CreateLinkPermissionTableState extends State<CreateLinkPermissionTable> {
  late Future<List> dataFuture;

  late Set<String> permissionIds = widget.permissionIds;
  late Set<String> permissionGroupIds = widget.permissionGroupIds;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List> getData() async {
    var allPermissionGroups = await widget.rbacService.getAllPermissionGroups();

    var allPermissions = await widget.rbacService.getAllPermissions();

    return [allPermissionGroups, allPermissions];
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
                text: permissionIds.isEmpty && permissionGroupIds.isEmpty
                    ? 'Previous'
                    : 'Cancel',
                onPressed: () async {
                  if (permissionIds.isEmpty && permissionGroupIds.isEmpty) {
                    widget.onBack();
                  } else {
                    setState(() {
                      permissionIds = {};
                      permissionGroupIds = {};
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
                  widget.onSave(permissionIds, permissionGroupIds);
                },
                enabled:
                    permissionIds.isNotEmpty || permissionGroupIds.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const BlockHeader(
            titles: [('GROUP NAME', 1), ('PERMISSION(S)', 2), ('ID', 2)],
            trailingIcon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            leftPadding: 57,
          ),
          const SizedBox(
            height: 6,
          ),
          FutureBuilder(
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

              var allPermissionGroups =
                  snapshot.data![0] as List<PermissionGroupModel>;
              var allPermissions = snapshot.data![1] as List<PermissionModel>;

              var allPermissionsMap = allPermissions.fold(
                  <String, PermissionModel>{}, (previousValue, permission) {
                previousValue.addAll({permission.id: permission});

                return previousValue;
              });

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < allPermissionGroups.length; i++) ...[
                    Row(
                      children: [
                        Checkbox(
                          value: permissionGroupIds
                              .contains(allPermissionGroups[i].id),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                if (value) {
                                  permissionGroupIds
                                      .add(allPermissionGroups[i].id);
                                } else {
                                  permissionGroupIds
                                      .remove(allPermissionGroups[i].id);
                                }
                              });
                            }
                          },
                          fillColor: WidgetStateProperty.resolveWith(
                            (states) {
                              if (states.contains(WidgetState.selected)) {
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
                              (allPermissionGroups[i].name, 1),
                              (
                                allPermissionGroups[i]
                                    .permissionIds
                                    .map((pId) => allPermissionsMap[pId]?.name)
                                    .join(' + '),
                                2
                              ),
                              (allPermissionGroups[i].id, 2),
                            ],
                            rightPadding: 52,
                          ),
                        ),
                      ],
                    ),
                  ],
                  for (var i = 0; i < allPermissions.length; i++) ...[
                    Row(
                      children: [
                        Checkbox(
                          value: permissionIds.contains(allPermissions[i].id),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                if (value) {
                                  permissionIds.add(allPermissions[i].id);
                                } else {
                                  permissionIds.remove(allPermissions[i].id);
                                }
                              });
                            }
                          },
                          fillColor: WidgetStateProperty.resolveWith(
                            (states) {
                              if (states.contains(WidgetState.selected)) {
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
                              (null, 1),
                              (allPermissions[i].name, 2),
                              (allPermissions[i].id, 2),
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
