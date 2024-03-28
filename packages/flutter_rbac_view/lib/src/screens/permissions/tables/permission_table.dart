// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/name_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/sure_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/rbac_data_table.dart';

class PermissionTable extends StatefulWidget {
  const PermissionTable({
    required this.rbacService,
    required this.permissions,
    required this.refresh,
    super.key,
  });

  final RbacService rbacService;
  final List<PermissionModel>? permissions;
  final Future<void> Function() refresh;

  @override
  State<PermissionTable> createState() => _PermissionTableState();
}

class _PermissionTableState extends State<PermissionTable> {
  late Future<List<PermissionModel>> dataFuture;

  @override
  Widget build(BuildContext context) => RbacDataTable<PermissionModel>(
        title: 'Permissions',
        tableTitle: 'Permission',
        titleButtonText: 'Create permission',
        titleButtonOnTap: () async {
          await showDialog(
            context: context,
            builder: (context) => NameDialog(
              title: 'Name your permission',
              onSuccesfullCommit: (value) async {
                await widget.rbacService.createPermission(value);
              },
            ),
          );

          unawaited(widget.refresh());
        },
        items: widget.permissions,
        onTapRefresh: () {
          unawaited(widget.refresh());
        },
        // ignore: avoid_annotating_with_dynamic
        listItemBuilder: (dynamic permission) {
          if (permission is PermissionModel)
            return ListItem(
              data: [(permission.name, 1), (permission.id, 1), (null, 1)],
              trailingIcon: IconButton(
                onPressed: () async {
                  if (await showSureDialog(context)) {
                    await widget.rbacService.deletePermission(permission.id);

                    unawaited(widget.refresh());
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
              ),
            );

          return null;
        },
      );
}
