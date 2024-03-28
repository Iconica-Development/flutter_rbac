// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/widgets/base_screen.dart';
import 'package:flutter_rbac_view/src/widgets/block_header.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/name_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/sure_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/primary_button.dart';
import 'package:flutter_rbac_view/src/widgets/secondary_button.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';

class AccountGroupScreen extends StatefulWidget {
  const AccountGroupScreen({
    required this.rbacService,
    required this.accountGroupId,
    required this.onTapAccounts,
    required this.onTapPermissions,
    required this.onTapObjects,
    required this.onTapCreateLink,
    required this.onBack,
    required this.onQuit,
    super.key,
  });

  static const String route = 'AccountGroupScreen';

  final RbacService rbacService;
  final String accountGroupId;
  final void Function() onBack;
  final void Function() onTapAccounts;
  final void Function() onTapPermissions;
  final void Function() onTapObjects;
  final VoidCallback? onTapCreateLink;
  final void Function() onQuit;

  @override
  State<AccountGroupScreen> createState() => _AccountGroupScreenState();
}

class _AccountGroupScreenState extends State<AccountGroupScreen> {
  late Future<List> dataFuture;

  late Set<String> accountIds;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List> getData() async {
    var accountGroup =
        await widget.rbacService.getAccountGroupById(widget.accountGroupId);

    var allAccounts = await widget.rbacService.getAllAccounts();

    if (accountGroup != null) {
      setState(() {
        accountIds = <String>{};

        accountIds.addAll(accountGroup.accountIds);
      });
    }

    return [accountGroup, allAccounts];
  }

  @override
  Widget build(BuildContext context) => BaseScreen(
        onTapAccounts: widget.onTapPermissions,
        onTapPermissions: widget.onTapPermissions,
        onTapObjects: widget.onTapObjects,
        onTapCreateLink: widget.onTapCreateLink,
        onQuit: widget.onQuit,
        child: Align(
          alignment: Alignment.topCenter,
          child: FutureBuilder<List<dynamic>>(
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

              var accountGroup = snapshot.data![0] as AccountGroupModel?;
              var allAccounts = snapshot.data![1] as List<AccountModel>?;

              if (accountGroup == null || allAccounts == null) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
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
                          Text(
                            accountGroup.name,
                            style: const TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          FilledButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => NameDialog(
                                  title: 'Name your account group',
                                  onSuccesfullCommit: (name) async {
                                    await widget.rbacService.updateAccountGroup(
                                      accountGroup.id,
                                      newName: name,
                                    );

                                    setState(() {
                                      dataFuture = getData();
                                    });
                                  },
                                ),
                              );
                            },
                            style: const ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 8,
                                ),
                              ),
                              backgroundColor: MaterialStatePropertyAll(
                                Color(0xFFFAF9F6),
                              ),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                              ),
                              side: MaterialStatePropertyAll(
                                BorderSide(),
                              ),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Edit name',
                                  style: TextStyle(
                                    fontFamily: 'Avenir',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SecondaryButton(
                            text: 'Delete',
                            onPressed: () async {
                              if (await showSureDialog(context)) {
                                await widget.rbacService
                                    .deleteAccountGroup(accountGroup.id);

                                widget.onBack();
                              }
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SecondaryButton(
                            text: 'Cancel',
                            onPressed: () {
                              setState(() {
                                accountIds = accountGroup.accountIds;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          PrimaryButton(
                            text: 'Save',
                            onPressed: () async {
                              await widget.rbacService.updateAccountGroup(
                                accountGroup.id,
                                accountIds: accountIds,
                              );

                              setState(() {
                                dataFuture = getData();
                              });
                            },
                            enabled: accountIds
                                    .difference(accountGroup.accountIds)
                                    .isNotEmpty ||
                                accountGroup.accountIds
                                    .difference(accountIds)
                                    .isNotEmpty,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const BlockHeader(
                        titles: [('EMAIL ADDRESS', 1), ('ID', 1)],
                        trailingIcon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        leftPadding: 57,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
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
                                ],
                                rightPadding: 52,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
}
