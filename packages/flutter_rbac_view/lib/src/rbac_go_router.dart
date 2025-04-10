// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter_rbac_service/flutter_rbac_service.dart";
import "package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart";
import "package:flutter_rbac_view/flutter_rbac_view.dart";
import "package:flutter_rbac_view/src/routes.dart";
import "package:go_router/go_router.dart";

/// Returns a list of GoRouter routes for the RBAC management view.
List<GoRoute> getRbacViewRoutes({
  required String closeRoute,
  RbacService? rbacService,
}) {
  var service =
      rbacService ?? RbacService(dataInterface: LocalRbacDatasource());

  return <GoRoute>[
    GoRoute(
      path: RbacRoutes.accountOverview,
      builder: (context, state) => AccountOverviewScreen(
        rbacService: service,
        onQuit: () {
          context.go(closeRoute);
        },
        onTapAccounts: () {},
        onTapPermissions: () {
          context.pushReplacement(RbacRoutes.permissionOverview);
        },
        onTapObjects: () {
          context.pushReplacement(RbacRoutes.objectOverview);
        },
        onTapCreateLink: () async {
          await context.push(RbacRoutes.createLink);
        },
        onTapAccount: (account) async {
          await context.push(
            RbacRoutes.accountDetail(account.id),
          );
        },
        onTapAccountGroup: (group) async {
          await context.push(
            RbacRoutes.accountGroupDetail(group.id),
          );
        },
      ),
    ),
    GoRoute(
      path: "${RbacRoutes.accountOverview}/:accountId",
      builder: (context, state) => AccountDetailScreen(
        rbacService: service,
        onQuit: () {
          context.go(closeRoute);
        },
        onTapAccounts: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.pushReplacement(RbacRoutes.objectOverview);
          }
        },
        onTapPermissions: () {
          if (context.canPop()) {
            context.pop();
          }

          context.pushReplacement(RbacRoutes.permissionOverview);
        },
        onTapObjects: () {
          if (context.canPop()) {
            context.pop();
          }

          context.pushReplacement(RbacRoutes.objectOverview);
        },
        onTapCreateLink: () async {
          if (context.canPop()) {
            context.pop();
          }

          await context.push(RbacRoutes.createLink);
        },
        accountId: state.pathParameters["accountId"] ?? "",
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.pushReplacement(RbacRoutes.objectOverview);
          }
        },
      ),
    ),
    GoRoute(
      path: "${RbacRoutes.accountOverview}/group/:groupId",
      builder: (context, state) => AccountGroupScreen(
        rbacService: service,
        onQuit: () {
          context.go(closeRoute);
        },
        onTapAccounts: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.pushReplacement(RbacRoutes.objectOverview);
          }
        },
        onTapPermissions: () {
          if (context.canPop()) {
            context.pop();
          }

          context.pushReplacement(RbacRoutes.permissionOverview);
        },
        onTapObjects: () {
          if (context.canPop()) {
            context.pop();
          }

          context.pushReplacement(RbacRoutes.objectOverview);
        },
        onTapCreateLink: () async {
          if (context.canPop()) {
            context.pop();
          }

          await context.push(RbacRoutes.createLink);
        },
        accountGroupId: state.pathParameters["groupId"] ?? "",
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.pushReplacement(RbacRoutes.objectOverview);
          }
        },
      ),
    ),
    GoRoute(
      path: RbacRoutes.permissionOverview,
      builder: (context, state) => PermissionOverviewScreen(
        rbacService: service,
        onQuit: () {
          context.go(closeRoute);
        },
        onTapAccounts: () {
          context.pushReplacement(RbacRoutes.accountOverview);
        },
        onTapPermissions: () {},
        onTapObjects: () {
          context.pushReplacement(RbacRoutes.objectOverview);
        },
        onTapCreateLink: () async {
          await context.push(RbacRoutes.createLink);
        },
      ),
    ),
    GoRoute(
      path: RbacRoutes.objectOverview,
      builder: (context, state) => ObjectOverviewScreen(
        rbacService: service,
        onQuit: () {
          context.go(closeRoute);
        },
        onTapAccounts: () {
          context.pushReplacement(RbacRoutes.accountOverview);
        },
        onTapPermissions: () {
          context.pushReplacement(RbacRoutes.permissionOverview);
        },
        onTapObjects: () {},
        onTapCreateLink: () async {
          await context.push(RbacRoutes.createLink);
        },
        onTapObject: (object) async {
          await context.push(RbacRoutes.objectDetail(object.id));
        },
      ),
    ),
    GoRoute(
      path: "${RbacRoutes.objectOverview}/:objectId",
      builder: (context, state) => ObjectDetailScreen(
        rbacService: service,
        onQuit: () {
          context.go(closeRoute);
        },
        onTapAccounts: () {
          if (context.canPop()) {
            context.pop();
          }

          context.pushReplacement(RbacRoutes.accountOverview);
        },
        onTapPermissions: () {
          if (context.canPop()) {
            context.pop();
          }

          context.pushReplacement(RbacRoutes.permissionOverview);
        },
        onTapObjects: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.pushReplacement(RbacRoutes.permissionOverview);
          }
        },
        onTapCreateLink: () async {
          if (context.canPop()) {
            context.pop();
          }

          await context.push(RbacRoutes.createLink);
        },
        objectId: state.pathParameters["objectId"] ?? "",
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.pushReplacement(RbacRoutes.permissionOverview);
          }
        },
      ),
    ),
    GoRoute(
      path: RbacRoutes.createLink,
      builder: (context, state) => CreateLinkScreen(
        rbacService: service,
        onQuit: () {
          context.go(closeRoute);
        },
        onTapAccounts: () {
          if (context.canPop()) {
            context.pop();
          }

          context.pushReplacement(RbacRoutes.accountOverview);
        },
        onTapPermissions: () {
          if (context.canPop()) {
            context.pop();
          }

          context.pushReplacement(RbacRoutes.permissionOverview);
        },
        onTapObjects: () {
          if (context.canPop()) {
            context.pop();
          }

          context.pushReplacement(RbacRoutes.objectOverview);
        },
        onTapCreateLink: () {},
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.pushReplacement(RbacRoutes.accountOverview);
          }
        },
      ),
    ),
  ];
}
