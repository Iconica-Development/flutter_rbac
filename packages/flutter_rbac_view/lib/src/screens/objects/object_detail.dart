// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/widgets/base_screen.dart';
import 'package:flutter_rbac_view/src/widgets/block_header.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/sure_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/secondary_button.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';

class ObjectDetailScreen extends StatefulWidget {
  const ObjectDetailScreen({
    required this.rbacService,
    required this.objectId,
    required this.onTapAccounts,
    required this.onTapPermissions,
    required this.onTapObjects,
    required this.onTapCreateLink,
    required this.onBack,
    required this.onQuit,
    super.key,
  });

  static const String route = 'ObjectDetailScreen';

  final RbacService rbacService;
  final String objectId;
  final void Function() onBack;
  final void Function() onTapAccounts;
  final void Function() onTapPermissions;
  final void Function() onTapObjects;
  final VoidCallback? onTapCreateLink;
  final void Function() onQuit;

  @override
  State<ObjectDetailScreen> createState() => _ObjectDetailScreenState();
}

class _ObjectDetailScreenState extends State<ObjectDetailScreen> {
  late Future<List> dataFuture;
  Future<List<(AccountModel, AccountGroupModel?)>>? accountFuture;

  int? selectedPermission;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List> getData() async {
    var object =
        await widget.rbacService.getSecurableObjectById(widget.objectId);

    var assignments = <RoleAssignmentModel>[];

    assignments.addAll(
      await widget.rbacService
          .getRoleAssignmentsByReference(objectId: widget.objectId),
    );

    var allPermissions = (await widget.rbacService.getAllPermissions())
        .map((p) => {p.id: p})
        .fold(
      <String, PermissionModel>{},
      (previousValue, element) {
        previousValue.addAll(element);

        return previousValue;
      },
    );

    var assignmentsByPId = assignments.groupListsBy((a) => a.permissionId);

    var singlePermissionAssignments =
        <(PermissionModel, List<(String, AccountGroupModel?)>)>[];

    for (var entry in assignmentsByPId.entries) {
      if (entry.key != null) {
        if (allPermissions[entry.key] != null) {
          var perm = allPermissions[entry.key]!;

          var accountIds = <(String, AccountGroupModel?)>[];

          for (var e in entry.value) {
            if (e.accountId != null) {
              accountIds.add((e.accountId!, null));
            } else if (e.accountGroupId != null) {
              var accountGroup = await widget.rbacService
                  .getAccountGroupById(e.permissionGroupId!);

              if (accountGroup != null)
                for (var accId in accountGroup.accountIds) {
                  accountIds.add((accId, accountGroup));
                }
            }
          }

          singlePermissionAssignments.add((perm, accountIds));
        }
      }
    }

    var assignmentsByPGId =
        assignments.groupListsBy((a) => a.permissionGroupId);

    var groupPermissionAssignments = <(
      (PermissionGroupModel, List<PermissionModel>),
      List<(String, AccountGroupModel?)>
    )>[];

    for (var entry in assignmentsByPGId.entries) {
      if (entry.key != null) {
        var permissionGroup =
            await widget.rbacService.getPermissionGroupById(entry.key!);

        if (permissionGroup != null) {
          var perms = <PermissionModel>[];

          for (var pId in permissionGroup.permissionIds) {
            var perm = allPermissions[pId];

            if (perm != null) {
              perms.add(perm);
            }
          }

          var accountIds = <(String, AccountGroupModel?)>[];

          for (var e in entry.value) {
            if (e.accountId != null) {
              accountIds.add((e.accountId!, null));
            } else if (e.accountGroupId != null) {
              var accountGroup = await widget.rbacService
                  .getAccountGroupById(e.accountGroupId!);

              if (accountGroup != null)
                for (var accId in accountGroup.accountIds) {
                  accountIds.add((accId, accountGroup));
                }
            }
          }

          groupPermissionAssignments
              .add(((permissionGroup, perms), accountIds));
        }
      }
    }

    return [object, singlePermissionAssignments, groupPermissionAssignments];
  }

  Future<List<(AccountModel, AccountGroupModel?)>> getAccountData(
    List<(String, AccountGroupModel?)> accountIds,
  ) async {
    var accounts = <(AccountModel, AccountGroupModel?)>[];

    for (var accIds in accountIds) {
      var account = await widget.rbacService.getAccountById(accIds.$1);

      if (account != null) {
        accounts.add((account, accIds.$2));
      }
    }

    return accounts;
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
                      'Edit secured object',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w800,
                        fontSize: 32,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const Spacer(),
                    SecondaryButton(
                      onPressed: () async {
                        if (await showSureDialog(context)) {
                          unawaited(
                            widget.rbacService
                                .deleteSecurableObject(widget.objectId),
                          );

                          widget.onBack();
                        }
                      },
                      text: 'Delete',
                    ),
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

                    var object = snapshot.data![0] as SecurableObjectModel?;
                    var singlePermissionAssignments = snapshot.data![1] as List<
                        (PermissionModel, List<(String, AccountGroupModel?)>)>?;
                    var groupPermissionAssignments = snapshot.data![2] as List<
                        (
                          (PermissionGroupModel, List<PermissionModel>),
                          List<(String, AccountGroupModel?)>
                        )>?;

                    if (accountFuture == null && selectedPermission != null) {
                      if (singlePermissionAssignments == null &&
                              groupPermissionAssignments == null ||
                          (singlePermissionAssignments?.length ?? 0) +
                                  (groupPermissionAssignments?.length ?? 0) >=
                              selectedPermission!) {
                        selectedPermission = null;
                      } else {
                        // ignore: discarded_futures
                        accountFuture = getAccountData(
                          selectedPermission! <
                                  (singlePermissionAssignments?.length ?? 0)
                              ? singlePermissionAssignments![
                                      selectedPermission!]
                                  .$2
                              : groupPermissionAssignments![
                                      selectedPermission! -
                                          (singlePermissionAssignments
                                                  ?.length ??
                                              0)]
                                  .$2,
                        );
                      }
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 220,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const BlockHeader(
                                titles: [('SECURED OBJECT', 1)],
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
                                child: Row(
                                  children: [
                                    Text(
                                      object?.name ?? 'Name',
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
                                titles: [('PERMISSIONS', 1)],
                                trailingIcon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              if (singlePermissionAssignments != null) ...[
                                for (var i = 0;
                                    i < singlePermissionAssignments.length;
                                    i++) ...[
                                  ListItem(
                                    data: [
                                      (null, 1),
                                      (
                                        singlePermissionAssignments[i].$1.name,
                                        3
                                      ),
                                    ],
                                    selected: selectedPermission == i,
                                    onTap: () {
                                      setState(() {
                                        selectedPermission = i;

                                        // ignore: discarded_futures
                                        accountFuture = getAccountData(
                                          singlePermissionAssignments[i].$2,
                                        );
                                      });
                                    },
                                    trailingIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            if (await showSureDialog(context)) {
                                              var assignments = await rbacService
                                                  .getRoleAssignmentsByReference(
                                                objectId: widget.objectId,
                                                permissionId:
                                                    singlePermissionAssignments[
                                                            i]
                                                        .$1
                                                        .id,
                                              );

                                              for (var assignment
                                                  in assignments) {
                                                await rbacService
                                                    .deleteRoleAssignment(
                                                  assignment.id,
                                                );
                                              }

                                              setState(() {
                                                selectedPermission = null;
                                                accountFuture = null;
                                                // ignore: discarded_futures
                                                dataFuture = getData();
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    rightPadding: 15,
                                  ),
                                ],
                              ],
                              if (groupPermissionAssignments != null) ...[
                                for (var i = 0;
                                    i < groupPermissionAssignments.length;
                                    i++) ...[
                                  ListItem(
                                    data: [
                                      (
                                        groupPermissionAssignments[i]
                                            .$1
                                            .$1
                                            .name,
                                        1
                                      ),
                                      (
                                        groupPermissionAssignments[i]
                                            .$1
                                            .$2
                                            .map((p) => p.name)
                                            .join(' + '),
                                        3
                                      ),
                                    ],
                                    selected: selectedPermission ==
                                        i +
                                            (singlePermissionAssignments
                                                    ?.length ??
                                                0),
                                    onTap: () {
                                      setState(() {
                                        selectedPermission = i +
                                            (singlePermissionAssignments
                                                    ?.length ??
                                                0);

                                        // ignore: discarded_futures
                                        accountFuture = getAccountData(
                                          groupPermissionAssignments[i].$2,
                                        );
                                      });
                                    },
                                    trailingIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            if (await showSureDialog(context)) {
                                              var assignments = await rbacService
                                                  .getRoleAssignmentsByReference(
                                                objectId: widget.objectId,
                                                permissionGroupId:
                                                    groupPermissionAssignments[
                                                            i]
                                                        .$1
                                                        .$1
                                                        .id,
                                              );

                                              for (var assignment
                                                  in assignments) {
                                                await rbacService
                                                    .deleteRoleAssignment(
                                                  assignment.id,
                                                );
                                              }

                                              setState(() {
                                                selectedPermission = null;
                                                accountFuture = null;
                                                // ignore: discarded_futures
                                                dataFuture = getData();
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    rightPadding: 15,
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        if (accountFuture != null) ...[
                          Expanded(
                            child: FutureBuilder(
                              future: accountFuture,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
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

                                var accounts = snapshot.data!;

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const BlockHeader(
                                      titles: [('ACCOUNTS', 1), ('TYPE', 1)],
                                      trailingIcon: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    for (var account in accounts) ...[
                                      ListItem(
                                        data: [
                                          (account.$1.email ?? 'Unknown', 1),
                                          (account.$2?.name, 1),
                                        ],
                                        trailingIcon: IconButton(
                                          onPressed: () async {
                                            if (await showSureDialog(context)) {
                                              if (account.$2 != null) {
                                                await rbacService
                                                    .removeAccountsFromAccountsGroup(
                                                  account.$2!.id,
                                                  [account.$1.id],
                                                );
                                              } else {
                                                var selectedP = selectedPermission! <
                                                        (singlePermissionAssignments
                                                                ?.length ??
                                                            0)
                                                    ? singlePermissionAssignments![
                                                            selectedPermission!]
                                                        .$1
                                                    : groupPermissionAssignments![
                                                            selectedPermission! -
                                                                (singlePermissionAssignments
                                                                        ?.length ??
                                                                    0)]
                                                        .$1
                                                        .$1;

                                                List<RoleAssignmentModel>?
                                                    assignments;

                                                if (selectedP
                                                    is PermissionModel) {
                                                  assignments = await rbacService
                                                      .getRoleAssignmentsByReference(
                                                    objectId: widget.objectId,
                                                    accountId: account.$1.id,
                                                    permissionId: selectedP.id,
                                                  );
                                                } else if (selectedP
                                                    is PermissionGroupModel) {
                                                  assignments = await rbacService
                                                      .getRoleAssignmentsByReference(
                                                    objectId: widget.objectId,
                                                    accountId: account.$1.id,
                                                    permissionGroupId:
                                                        selectedP.id,
                                                  );
                                                }

                                                if (assignments != null) {
                                                  for (var assignment
                                                      in assignments) {
                                                    await rbacService
                                                        .deleteRoleAssignment(
                                                      assignment.id,
                                                    );
                                                  }
                                                }
                                              }

                                              setState(() {
                                                accountFuture = null;
                                                // ignore: discarded_futures
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
                                );
                              },
                            ),
                          ),
                        ] else ...[
                          const Spacer(),
                        ],
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
