// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/screens/accounts/tables/account_group_table.dart';
import 'package:flutter_rbac_view/src/screens/accounts/tables/account_table.dart';
import 'package:flutter_rbac_view/src/widgets/base_screen.dart';

class AccountOverviewScreen extends StatefulWidget {
  const AccountOverviewScreen({
    required this.rbacService,
    required this.onTapAccounts,
    required this.onTapPermissions,
    required this.onTapObjects,
    required this.onTapCreateLink,
    required this.onTapAccount,
    required this.onTapAccountGroup,
    required this.onQuit,
    super.key,
  });

  static const String route = 'AccountOverviewScreen';

  final RbacService rbacService;

  final void Function() onTapAccounts;
  final void Function() onTapPermissions;
  final void Function() onTapObjects;
  final VoidCallback? onTapCreateLink;
  final void Function(AccountModel account) onTapAccount;
  final void Function(AccountGroupModel group) onTapAccountGroup;
  final void Function() onQuit;

  @override
  State<AccountOverviewScreen> createState() => _AccountOverviewScreenState();
}

class _AccountOverviewScreenState extends State<AccountOverviewScreen> {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AccountTable(
                    rbacService: widget.rbacService,
                    onTapAccount: widget.onTapAccount,
                  ),
                  AccountGroupTable(
                    rbacService: widget.rbacService,
                    onTapAccountGroup: widget.onTapAccountGroup,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
