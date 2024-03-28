// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/widgets/block_header.dart';
import 'package:flutter_rbac_view/src/widgets/primary_button.dart';
import 'package:flutter_rbac_view/src/widgets/secondary_button.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';

class CreateLinkAccountTable extends StatefulWidget {
  const CreateLinkAccountTable({
    required this.rbacService,
    required this.accountIds,
    required this.accountGroupIds,
    required this.onBack,
    required this.onSave,
    super.key,
  });

  final RbacService rbacService;
  final Set<String> accountIds;
  final Set<String> accountGroupIds;
  final VoidCallback onBack;
  final void Function(
    Set<String> accountIds,
    Set<String> accountGroupIds,
  ) onSave;

  @override
  State<CreateLinkAccountTable> createState() => _CreateLinkAccountTableState();
}

class _CreateLinkAccountTableState extends State<CreateLinkAccountTable> {
  late Future<List> dataFuture;

  late Set<String> accountIds = widget.accountIds;
  late Set<String> accountGroupIds = widget.accountGroupIds;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List> getData() async {
    var allAccountGroups = await widget.rbacService.getAllAccountGroups();

    var allAccounts = await widget.rbacService.getAllAccounts();

    return [allAccountGroups, allAccounts];
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                'Create link',
                style: TextStyle(
                  fontFamily: 'Avenir',
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              const Spacer(),
              SecondaryButton(
                text: 'Cancel',
                onPressed: () async {
                  setState(() {
                    accountIds = {};
                    accountGroupIds = {};
                  });
                },
              ),
              const SizedBox(
                width: 8,
              ),
              PrimaryButton(
                text: 'Save',
                onPressed: () async {
                  widget.onSave(accountIds, accountGroupIds);
                },
                enabled: accountIds.isNotEmpty || accountGroupIds.isNotEmpty,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const BlockHeader(
            titles: [('EMAIL ADDRESS/GROUP NAME', 1), ('ID', 1)],
            trailingIcon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            leftPadding: 57,
          ),
          const SizedBox(
            height: 6,
          ),
          FutureBuilder(
            future: dataFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
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

              var allAccountGroups =
                  snapshot.data![0] as List<AccountGroupModel>;
              var allAccounts = snapshot.data![1] as List<AccountModel>;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < allAccountGroups.length; i++) ...[
                    Row(
                      children: [
                        Checkbox(
                          value:
                              accountGroupIds.contains(allAccountGroups[i].id),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                if (value) {
                                  accountGroupIds.add(allAccountGroups[i].id);
                                } else {
                                  accountGroupIds
                                      .remove(allAccountGroups[i].id);
                                }
                              });
                            }
                          },
                          fillColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.black;
                              }

                              return Colors.white;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ListItem(
                            data: [
                              ('Group: ${allAccountGroups[i].name}', 1),
                              (allAccountGroups[i].id, 1),
                              (null, 1),
                            ],
                            rightPadding: 52,
                          ),
                        ),
                      ],
                    ),
                  ],
                  for (var i = 0; i < allAccounts.length; i++) ...[
                    Row(
                      children: [
                        Checkbox(
                          value: accountIds.contains(allAccounts[i].id),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                if (value) {
                                  accountIds.add(allAccounts[i].id);
                                } else {
                                  accountIds.remove(allAccounts[i].id);
                                }
                              });
                            }
                          },
                          fillColor: MaterialStateProperty.resolveWith(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return Colors.black;
                              }

                              return Colors.white;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ListItem(
                            data: [
                              (allAccounts[i].email ?? 'Unknown', 1),
                              (allAccounts[i].id, 1),
                              (null, 1),
                            ],
                            rightPadding: 52,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      );
}
