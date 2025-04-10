// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_rbac_service/flutter_rbac_service.dart";
import "package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart";
import "package:flutter_rbac_view/src/screens/permissions/tables/permission_group_table.dart";
import "package:flutter_rbac_view/src/screens/permissions/tables/permission_table.dart";
import "package:flutter_rbac_view/src/widgets/base_screen.dart";

class PermissionOverviewScreen extends StatefulWidget {
  const PermissionOverviewScreen({
    required this.rbacService,
    required this.onTapAccounts,
    required this.onTapPermissions,
    required this.onTapObjects,
    required this.onTapCreateLink,
    required this.onQuit,
    super.key,
  });

  static const String route = "PermissionOverviewScreen";

  final RbacService rbacService;

  final void Function() onTapAccounts;
  final void Function() onTapPermissions;
  final void Function() onTapObjects;
  final VoidCallback? onTapCreateLink;
  final void Function() onQuit;

  @override
  State<PermissionOverviewScreen> createState() =>
      _PermissionOverviewScreenState();
}

class _PermissionOverviewScreenState extends State<PermissionOverviewScreen> {
  late Future<List> dataFuture;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List> getData() async {
    var permissions = await widget.rbacService.getAllPermissions();
    var permissionGroups = await widget.rbacService.getAllPermissionGroups();

    return [permissions, permissionGroups];
  }

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
              child: FutureBuilder(
                future: dataFuture,
                builder: (context, snapshot) {
                  var permissions = snapshot.data?[0] as List<PermissionModel>?;
                  var permissionGroups =
                      snapshot.data?[1] as List<PermissionGroupModel>?;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PermissionTable(
                        rbacService: widget.rbacService,
                        permissions: permissions,
                        refresh: () async {
                          setState(() {
                            // ignore: discarded_futures
                            dataFuture = getData();
                          });
                        },
                      ),
                      PermissionGroupTable(
                        rbacService: widget.rbacService,
                        permissions: permissions?.fold(
                            <String, PermissionModel>{}, (previousValue, p) {
                          if (previousValue == null) return {p.id: p};

                          previousValue.addAll({p.id: p});

                          return previousValue;
                        }),
                        permissionGroups: permissionGroups,
                        refresh: () async {
                          setState(() {
                            // ignore: discarded_futures
                            dataFuture = getData();
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
}
