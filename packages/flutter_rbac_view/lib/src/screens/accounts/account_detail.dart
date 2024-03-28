// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/widgets/base_screen.dart';
import 'package:flutter_rbac_view/src/widgets/block_header.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/sure_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';

class AccountDetailScreen extends StatefulWidget {
  const AccountDetailScreen({
    required this.rbacService,
    required this.accountId,
    required this.onTapAccounts,
    required this.onTapPermissions,
    required this.onTapObjects,
    required this.onTapCreateLink,
    required this.onBack,
    required this.onQuit,
    super.key,
  });

  static const String route = 'AccountDetailScreen';

  final RbacService rbacService;
  final String accountId;
  final void Function() onBack;
  final void Function() onTapAccounts;
  final void Function() onTapPermissions;
  final void Function() onTapObjects;
  final VoidCallback? onTapCreateLink;
  final void Function() onQuit;

  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  late Future<List> dataFuture;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List> getData() async {
    var account = await widget.rbacService.getAccountById(widget.accountId);
    var groups = await widget.rbacService
        .getAccountGroupsByAccountIds([widget.accountId]);

    var assignments = <(RoleAssignmentModel, AccountGroupModel?)>[];

    assignments.addAll(
      (await widget.rbacService
              .getRoleAssignmentsByReference(accountId: widget.accountId))
          .map((ra) => (ra, null))
          .toList(),
    );
    for (var group in groups) {
      assignments.addAll(
        (await widget.rbacService
                .getRoleAssignmentsByReference(accountGroupId: group.id))
            .map((ra) => (ra, group))
            .toList(),
      );
    }

    var allObjects = (await widget.rbacService.getAllSecurableObjects())
        .map((p) => {p.id: p})
        .fold(
      <String, SecurableObjectModel>{},
      (previousValue, element) {
        previousValue.addAll(element);

        return previousValue;
      },
    );

    var objects = <SecurableObjectModel?>[];

    for (var assignment in assignments) {
      objects.add(allObjects[assignment.$1.objectId]);
    }

    var allPermissions = (await widget.rbacService.getAllPermissions())
        .map((p) => {p.id: p})
        .fold(
      <String, PermissionModel>{},
      (previousValue, element) {
        previousValue.addAll(element);

        return previousValue;
      },
    );

    var permissions =
        <(List<PermissionModel>, AccountGroupModel?, PermissionGroupModel?)>[];

    for (var assignment in assignments) {
      var perms = <PermissionModel>[];

      if (assignment.$1.permissionId != null) {
        var perm = allPermissions[assignment.$1.permissionId];

        if (perm != null) perms.add(perm);

        permissions.add((perms, assignment.$2, null));
      } else if (assignment.$1.permissionGroupId != null) {
        var permGroup = await widget.rbacService
            .getPermissionGroupById(assignment.$1.permissionGroupId!);

        if (permGroup != null)
          for (var pgId in permGroup.permissionIds) {
            var p = allPermissions[pgId];

            if (p != null) perms.add(p);
          }

        permissions.add((perms, assignment.$2, permGroup));
      }
    }

    return [account, objects, permissions];
  }

  @override
  Widget build(BuildContext context) {
    var rbacService = widget.rbacService;

    return BaseScreen(
      onTapAccounts: widget.onTapPermissions,
      onTapPermissions: widget.onTapPermissions,
      onTapObjects: widget.onTapObjects,
      onTapCreateLink: widget.onTapCreateLink,
      onQuit: widget.onQuit,
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
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
                      'Edit account',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<dynamic>>(
                  // ignore: discarded_futures
                  future: dataFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
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

                    var account = snapshot.data![0] as AccountModel?;
                    var objects =
                        snapshot.data![1] as List<SecurableObjectModel?>?;
                    var permissions = snapshot.data![2] as List<
                        (
                          List<PermissionModel>,
                          AccountGroupModel?,
                          PermissionGroupModel?
                        )>?;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 220,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const BlockHeader(
                                titles: [('ACCOUNT', 1)],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: const Color(0xFF212121),
                                  ),
                                ),
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      account?.email ?? 'Email',
                                      style: const TextStyle(
                                        fontFamily: 'Avenir',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      account?.id ?? 'ID',
                                      style: const TextStyle(
                                        fontFamily: 'Avenir',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const BlockHeader(
                                titles: [
                                  ('SECURED OBJECTS', 1),
                                  ('PERMISSIONS', 2),
                                  ('ACCOUNT GROUP', 1),
                                ],
                                trailingIcon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              if (objects != null && permissions != null) ...[
                                for (var i = 0; i < objects.length; i++) ...[
                                  ListItem(
                                    data: [
                                      (objects[i]?.name ?? 'Unknown', 1),
                                      (
                                        permissions[i]
                                            .$1
                                            .map((p) => p.name)
                                            .join(' + '),
                                        2
                                      ),
                                      (permissions[i].$2?.name, 1),
                                    ],
                                    trailingIcon: IconButton(
                                      onPressed: () async {
                                        if (await showSureDialog(context)) {
                                          if (permissions[i].$2 != null) {
                                            await rbacService
                                                // ignore: lines_longer_than_80_chars
                                                .removeAccountsFromAccountsGroup(
                                              permissions[i].$2!.id,
                                              [widget.accountId],
                                            );
                                          } else if (objects[i] != null) {
                                            if (permissions[i].$3 != null) {
                                              var assigns = await rbacService
                                                  // ignore: lines_longer_than_80_chars
                                                  .getRoleAssignmentsByReference(
                                                accountId: widget.accountId,
                                                objectId: objects[i]!.id,
                                                permissionGroupId:
                                                    permissions[i].$3!.id,
                                              );

                                              for (var assign in assigns) {
                                                await rbacService
                                                    .deleteRoleAssignment(
                                                  assign.id,
                                                );
                                              }
                                            } else {
                                              var assigns = await rbacService
                                                  // ignore: lines_longer_than_80_chars
                                                  .getRoleAssignmentsByReference(
                                                accountId: widget.accountId,
                                                objectId: objects[i]!.id,
                                                permissionId:
                                                    permissions[i].$1.first.id,
                                              );

                                              for (var assign in assigns) {
                                                await rbacService
                                                    .deleteRoleAssignment(
                                                  assign.id,
                                                );
                                              }
                                            }
                                          }

                                          setState(() {
                                            dataFuture = getData();
                                          });
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                      ),
                                    ),
                                    rightPadding: 15,
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
