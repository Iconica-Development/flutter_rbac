// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/rbac_data_table.dart';

class AccountTable extends StatefulWidget {
  const AccountTable({
    required this.rbacService,
    required this.onTapAccount,
    super.key,
  });

  final RbacService rbacService;
  final void Function(AccountModel account) onTapAccount;

  @override
  State<AccountTable> createState() => _AccountTableState();
}

class _AccountTableState extends State<AccountTable> {
  late Future<List<AccountModel>> dataFuture;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List<AccountModel>> getData() => widget.rbacService.getAllAccounts();

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: dataFuture,
        builder: (context, snapshot) => RbacDataTable<AccountModel>(
          title: 'Accounts',
          tableTitle: 'ACCOUNTS',
          items: snapshot.data,
          onTapRefresh: () {
            setState(() {
              // ignore: discarded_futures
              dataFuture = getData();
            });
          },
          // ignore: avoid_annotating_with_dynamic
          listItemBuilder: (dynamic account) {
            if (account is AccountModel)
              return ListItem(
                data: [
                  (account.email ?? 'No email', 1),
                  (account.id, 1),
                  (null, 1),
                ],
                trailingIcon: const Icon(
                  Icons.chevron_right,
                  size: 24,
                ),
                onTap: () {
                  widget.onTapAccount(account);
                },
              );

            return null;
          },
        ),
      );
}
