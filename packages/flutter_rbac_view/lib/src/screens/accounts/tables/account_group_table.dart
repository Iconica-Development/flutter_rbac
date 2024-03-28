// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/rbac_data_table.dart';

class AccountGroupTable extends StatefulWidget {
  const AccountGroupTable({
    required this.rbacService,
    required this.onTapAccountGroup,
    super.key,
  });

  final RbacService rbacService;
  final void Function(AccountGroupModel accountGroup) onTapAccountGroup;

  @override
  State<AccountGroupTable> createState() => _AccountGroupTableState();
}

class _AccountGroupTableState extends State<AccountGroupTable> {
  late Future<List<AccountGroupModel>> dataFuture;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List<AccountGroupModel>> getData() =>
      widget.rbacService.getAllAccountGroups();

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: dataFuture,
        builder: (context, snapshot) => RbacDataTable<AccountGroupModel>(
          title: 'Account groups',
          tableTitle: 'ACCOUNT GROUPS',
          titleButtonText: 'Create account group',
          titleButtonOnTap: () async {
            var accountGroup = await widget.rbacService
                .createAccountGroup('New account group', {});

            setState(() {
              dataFuture = getData();
            });

            widget.onTapAccountGroup(accountGroup);
          },
          // ignore: discarded_futures
          items: snapshot.data,
          onTapRefresh: () {
            setState(() {
              // ignore: discarded_futures
              dataFuture = getData();
            });
          },
          // ignore: avoid_annotating_with_dynamic
          listItemBuilder: (dynamic group) {
            if (group is AccountGroupModel)
              return ListItem(
                data: [(group.name, 1), (group.id, 1), (null, 1)],
                trailingIcon: const Icon(
                  Icons.chevron_right,
                  size: 24,
                ),
                onTap: () {
                  widget.onTapAccountGroup(group);
                },
              );

            return null;
          },
        ),
      );
}
