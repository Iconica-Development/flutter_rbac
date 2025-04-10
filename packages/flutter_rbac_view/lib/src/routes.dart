// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

mixin RbacRoutes {
  static const String accountOverview = "/rbac/accounts";
  static String accountDetail(String accountId) =>
      "$accountOverview/$accountId";
  static String accountGroupDetail(String accountGroupId) =>
      "$accountOverview/group/$accountGroupId";
  static const String permissionOverview = "/rbac/permissions";
  static const String objectOverview = "/rbac/objects";
  static String objectDetail(String objectId) => "$objectOverview/$objectId";
  static const String createLink = "/rbac/link";
}
