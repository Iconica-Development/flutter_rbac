// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";
import "package:flutter_rbac_service/flutter_rbac_service.dart";
import "package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart";
import "package:flutter_rbac_view/src/screens/objects/tables/object_table.dart";
import "package:flutter_rbac_view/src/widgets/base_screen.dart";

class ObjectOverviewScreen extends StatefulWidget {
  const ObjectOverviewScreen({
    required this.rbacService,
    required this.onTapAccounts,
    required this.onTapPermissions,
    required this.onTapObjects,
    required this.onTapCreateLink,
    required this.onTapObject,
    required this.onQuit,
    super.key,
  });

  static const String route = "ObjectOverviewScreen";

  final RbacService rbacService;

  final void Function() onTapAccounts;
  final void Function() onTapPermissions;
  final void Function() onTapObjects;
  final VoidCallback? onTapCreateLink;
  final void Function(SecurableObjectModel object) onTapObject;
  final void Function() onQuit;

  @override
  State<ObjectOverviewScreen> createState() => _ObjectOverviewScreenState();
}

class _ObjectOverviewScreenState extends State<ObjectOverviewScreen> {
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
              child: ObjectTable(
                rbacService: widget.rbacService,
                onTapObject: widget.onTapObject,
              ),
            ),
          ),
        ),
      );
}
