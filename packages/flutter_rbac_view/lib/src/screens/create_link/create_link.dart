// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_view/src/screens/create_link/tables/link_account_table.dart';
import 'package:flutter_rbac_view/src/screens/create_link/tables/link_objects_table.dart';
import 'package:flutter_rbac_view/src/screens/create_link/tables/link_permission_table.dart';
import 'package:flutter_rbac_view/src/widgets/base_screen.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/sure_dialog.dart';

class CreateLinkScreen extends StatefulWidget {
  const CreateLinkScreen({
    required this.rbacService,
    required this.onTapAccounts,
    required this.onTapPermissions,
    required this.onTapObjects,
    required this.onTapCreateLink,
    required this.onBack,
    required this.onQuit,
    super.key,
  });

  static const String route = 'CreateLinkScreen';

  final RbacService rbacService;

  final void Function() onTapAccounts;
  final void Function() onTapPermissions;
  final void Function() onTapObjects;
  final VoidCallback onTapCreateLink;
  final VoidCallback onBack;
  final void Function() onQuit;

  @override
  State<CreateLinkScreen> createState() => _CreateLinkScreenState();
}

class _CreateLinkScreenState extends State<CreateLinkScreen> {
  var currentPage = 0;

  late Set<String> accountIds = {};
  late Set<String> accountGroupIds = {};

  late Set<String> permissionIds = {};
  late Set<String> permissionGroupIds = {};

  late Set<String> objectIds = {};

  var loading = false;

  @override
  Widget build(BuildContext context) => BaseScreen(
        onTapAccounts: widget.onTapAccounts,
        onTapPermissions: widget.onTapPermissions,
        onTapObjects: widget.onTapObjects,
        onTapCreateLink: widget.onTapCreateLink,
        onQuit: widget.onQuit,
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: loading
                  ? const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    )
                  : currentPage == 2
                      ? CreateLinkObjectTable(
                          rbacService: widget.rbacService,
                          objectIds: objectIds,
                          onBack: () {
                            setState(() {
                              currentPage = 0;
                            });
                          },
                          onSave: (objectIds) async {
                            if (await showSureDialog(
                              context,
                              title: 'Are you sure you want to create these '
                                  'links?',
                            )) {
                              this.objectIds = objectIds;

                              setState(() {
                                loading = true;
                              });

                              for (var objectId in this.objectIds) {
                                for (var accountId in accountIds) {
                                  for (var permissionId in permissionIds) {
                                    await widget.rbacService
                                        .createRoleAssignment(
                                      objectId: objectId,
                                      accountId: accountId,
                                      permissionId: permissionId,
                                    );
                                  }
                                  for (var permissionGroupId
                                      in permissionGroupIds) {
                                    await widget.rbacService
                                        .createRoleAssignment(
                                      objectId: objectId,
                                      accountId: accountId,
                                      permissionGroupId: permissionGroupId,
                                    );
                                  }
                                }
                                for (var accountGroupId in accountGroupIds) {
                                  for (var permissionId in permissionIds) {
                                    await widget.rbacService
                                        .createRoleAssignment(
                                      objectId: objectId,
                                      accountGroupId: accountGroupId,
                                      permissionId: permissionId,
                                    );
                                  }
                                  for (var permissionGroupId
                                      in permissionGroupIds) {
                                    await widget.rbacService
                                        .createRoleAssignment(
                                      objectId: objectId,
                                      accountGroupId: accountGroupId,
                                      permissionGroupId: permissionGroupId,
                                    );
                                  }
                                }
                              }

                              widget.onBack();
                            }
                          },
                        )
                      : currentPage == 1
                          ? CreateLinkPermissionTable(
                              rbacService: widget.rbacService,
                              permissionIds: permissionIds,
                              permissionGroupIds: permissionGroupIds,
                              onBack: () {
                                setState(() {
                                  currentPage = 0;
                                });
                              },
                              onSave: (permissionIds, permissionGroupIds) {
                                this.permissionIds = permissionIds;
                                this.permissionGroupIds = permissionGroupIds;

                                setState(() {
                                  currentPage = 2;
                                });
                              },
                            )
                          : CreateLinkAccountTable(
                              rbacService: widget.rbacService,
                              accountIds: accountIds,
                              accountGroupIds: accountGroupIds,
                              onBack: () {
                                widget.onBack();
                              },
                              onSave: (accountIds, accountGroupIds) {
                                this.accountIds = accountIds;
                                this.accountGroupIds = accountGroupIds;

                                setState(() {
                                  currentPage = 1;
                                });
                              },
                            ),
            ),
          ),
        ),
      );
}
