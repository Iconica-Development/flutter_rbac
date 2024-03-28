// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/flutter_rbac_view.dart';

/// A screen widget for managing Role-Based Access Control (RBAC).
class RbacScreen extends StatefulWidget {
  /// Constructs a [RbacScreen] widget.
  const RbacScreen({
    required this.onQuit,
    this.rbacService,
    super.key,
  });

  /// An instance of [RbacService] for managing RBAC.
  /// If null a [RbacService] will be used that uses [LocalRbacDatasource].
  final RbacService? rbacService;

  /// A callback function called when the user quits the screen.
  final VoidCallback onQuit;

  @override
  State<RbacScreen> createState() => _RbacScreenState();
}

class _RbacScreenState extends State<RbacScreen> {
  late var rbacService =
      widget.rbacService ?? RbacService(dataInterface: LocalRbacDatasource());

  Future<void> navigate(BuildContext context, String currentRoute) async {
    if (currentRoute == AccountOverviewScreen.route) {
      await _navigate(
        context,
        AccountOverviewScreen(
          rbacService: rbacService,
          onTapAccounts: () {},
          onTapPermissions: () {
            navigate(context, PermissionOverviewScreen.route);
          },
          onTapObjects: () {
            navigate(context, ObjectOverviewScreen.route);
          },
          onTapCreateLink: () {
            navigate(context, CreateLinkScreen.route);
          },
          onTapAccount: (account) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => AccountDetailScreen(
                  rbacService: rbacService,
                  accountId: account.id,
                  onTapAccounts: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      navigate(context, AccountOverviewScreen.route);
                    }
                  },
                  onTapPermissions: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    navigate(context, PermissionOverviewScreen.route);
                  },
                  onTapObjects: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    navigate(context, ObjectOverviewScreen.route);
                  },
                  onTapCreateLink: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    navigate(context, CreateLinkScreen.route);
                  },
                  onBack: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      navigate(context, AccountOverviewScreen.route);
                    }
                  },
                  onQuit: widget.onQuit,
                ),
              ),
            );
          },
          onTapAccountGroup: (accountGroup) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => AccountGroupScreen(
                  rbacService: rbacService,
                  accountGroupId: accountGroup.id,
                  onTapAccounts: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      navigate(context, AccountOverviewScreen.route);
                    }
                  },
                  onTapPermissions: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    navigate(context, PermissionOverviewScreen.route);
                  },
                  onTapObjects: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    navigate(context, ObjectOverviewScreen.route);
                  },
                  onTapCreateLink: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    navigate(context, CreateLinkScreen.route);
                  },
                  onBack: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      navigate(context, AccountOverviewScreen.route);
                    }
                  },
                  onQuit: widget.onQuit,
                ),
              ),
            );
          },
          onQuit: widget.onQuit,
        ),
      );
    } else if (currentRoute == PermissionOverviewScreen.route) {
      await _navigate(
        context,
        PermissionOverviewScreen(
          rbacService: rbacService,
          onTapAccounts: () {
            navigate(context, AccountOverviewScreen.route);
          },
          onTapPermissions: () {},
          onTapObjects: () {
            navigate(context, ObjectOverviewScreen.route);
          },
          onTapCreateLink: () {
            navigate(context, CreateLinkScreen.route);
          },
          onQuit: widget.onQuit,
        ),
      );
    } else if (currentRoute == ObjectOverviewScreen.route) {
      await _navigate(
        context,
        ObjectOverviewScreen(
          rbacService: rbacService,
          onTapAccounts: () {
            navigate(context, AccountOverviewScreen.route);
          },
          onTapPermissions: () {
            navigate(context, PermissionOverviewScreen.route);
          },
          onTapObjects: () {},
          onTapCreateLink: () {
            navigate(context, CreateLinkScreen.route);
          },
          onTapObject: (object) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => ObjectDetailScreen(
                  rbacService: rbacService,
                  objectId: object.id,
                  onTapAccounts: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    navigate(context, AccountOverviewScreen.route);
                  },
                  onTapPermissions: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    navigate(context, PermissionOverviewScreen.route);
                  },
                  onTapObjects: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      navigate(context, ObjectOverviewScreen.route);
                    }
                  },
                  onTapCreateLink: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }

                    navigate(context, CreateLinkScreen.route);
                  },
                  onBack: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      navigate(context, ObjectOverviewScreen.route);
                    }
                  },
                  onQuit: widget.onQuit,
                ),
              ),
            );
          },
          onQuit: widget.onQuit,
        ),
      );
    } else if (currentRoute == CreateLinkScreen.route) {
      await _navigate(
        context,
        CreateLinkScreen(
          rbacService: rbacService,
          onTapAccounts: () {
            navigate(context, AccountOverviewScreen.route);
          },
          onTapPermissions: () {
            navigate(context, PermissionOverviewScreen.route);
          },
          onTapObjects: () {
            navigate(
              context,
              ObjectOverviewScreen.route,
            );
          },
          onTapCreateLink: () {},
          onBack: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          onQuit: widget.onQuit,
        ),
      );
    }
  }

  Future<void> _navigate(BuildContext context, Widget screen) =>
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (c) => screen),
      );

  @override
  Widget build(BuildContext context) => AccountOverviewScreen(
        rbacService: rbacService,
        onTapAccounts: () {},
        onTapPermissions: () {
          unawaited(navigate(context, PermissionOverviewScreen.route));
        },
        onTapObjects: () {
          unawaited(navigate(context, ObjectOverviewScreen.route));
        },
        onTapCreateLink: () {
          unawaited(navigate(context, CreateLinkScreen.route));
        },
        onTapAccount: (account) async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) => AccountDetailScreen(
                rbacService: rbacService,
                accountId: account.id,
                onTapAccounts: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    navigate(context, AccountOverviewScreen.route);
                  }
                },
                onTapPermissions: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }

                  navigate(context, PermissionOverviewScreen.route);
                },
                onTapObjects: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }

                  navigate(context, ObjectOverviewScreen.route);
                },
                onTapCreateLink: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }

                  navigate(context, CreateLinkScreen.route);
                },
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    navigate(context, AccountOverviewScreen.route);
                  }
                },
                onQuit: widget.onQuit,
              ),
            ),
          );
        },
        onTapAccountGroup: (accountGroup) async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) => AccountGroupScreen(
                rbacService: rbacService,
                accountGroupId: accountGroup.id,
                onTapAccounts: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    navigate(context, AccountOverviewScreen.route);
                  }
                },
                onTapPermissions: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }

                  navigate(context, PermissionOverviewScreen.route);
                },
                onTapObjects: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }

                  navigate(context, ObjectOverviewScreen.route);
                },
                onTapCreateLink: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  }

                  navigate(context, CreateLinkScreen.route);
                },
                onBack: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    navigate(context, AccountOverviewScreen.route);
                  }
                },
                onQuit: widget.onQuit,
              ),
            ),
          );
        },
        onQuit: widget.onQuit,
      );
}
