import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/models/selectable_dialog_item.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/name_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/select_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/sure_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/rbac_data_table.dart';

class PermissionGroupTable extends StatefulWidget {
  const PermissionGroupTable({
    required this.rbacService,
    required this.permissionGroups,
    required this.permissions,
    required this.refresh,
    super.key,
  });

  final RbacService rbacService;
  final List<PermissionGroupModel>? permissionGroups;
  final Map<String, PermissionModel>? permissions;
  final Future<void> Function() refresh;

  @override
  State<PermissionGroupTable> createState() => _PermissionGroupTableState();
}

class _PermissionGroupTableState extends State<PermissionGroupTable> {
  @override
  Widget build(BuildContext context) => RbacDataTable<PermissionGroupModel>(
        title: 'Permission groups',
        tableTitle: 'PERMISSION GROUPS',
        titleButtonText: 'Create permission group',
        titleButtonOnTap: () async {
          String? name;
          Set<String>? permissionIds;

          await showDialog(
            context: context,
            builder: (context) => NameDialog(
              title: 'Name your permission group',
              onSuccesfullCommit: (value) async {
                name = value;
              },
            ),
          );
          if (name == null) return;

          var permissions = await widget.rbacService.getAllPermissions();

          if (context.mounted)
            await showDialog(
              context: context,
              builder: (context) => SelectDialog(
                title: 'Choose permissions for this group',
                onSuccesfullCommit: (value) async {
                  permissionIds = value;
                },
                items: permissions
                    .map(
                      (p) => SelectableDialogItem(id: p.id, title: p.name),
                    )
                    .toList(),
              ),
            );

          if (permissionIds == null) return;

          await widget.rbacService.createPermissionGroup(name!, permissionIds!);

          unawaited(widget.refresh());
        },
        items: widget.permissionGroups,
        onTapRefresh: () {
          unawaited(widget.refresh());
        },
        // ignore: avoid_annotating_with_dynamic
        listItemBuilder: (dynamic group) {
          if (group is PermissionGroupModel)
            return ListItem(
              data: [
                (group.name, 1),
                (
                  group.permissionIds
                      .map((p) => widget.permissions?[p]?.name)
                      .join(' + '),
                  1
                ),
                (group.id, 1),
              ],
              trailingIcon: IconButton(
                onPressed: () async {
                  if (await showSureDialog(context)) {
                    await widget.rbacService.deletePermissionGroup(group.id);

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
