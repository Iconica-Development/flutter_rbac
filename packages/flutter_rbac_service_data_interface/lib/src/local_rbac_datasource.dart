// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';

class LocalRbacDatasource implements RbacDataInterface {
  final securableObjectMap = <String, SecurableObjectModel>{};
  final accountMap = <String, AccountModel>{
    'user_1': const AccountModel(id: 'user_1', email: 'user_1@email.com'),
    'user_2': const AccountModel(id: 'user_2', email: 'user_2@email.com'),
    'user_3': const AccountModel(id: 'user_3', email: 'user_3@email.com'),
  };
  final accountGroupMap = <String, AccountGroupModel>{};
  final permissionMap = <String, PermissionModel>{};
  final permissionGroupMap = <String, PermissionGroupModel>{};
  final roleAssignmentMap = <String, RoleAssignmentModel>{};

  ///////////////////////// CRUD Securable Objects /////////////////////////////
  @override
  Future<void> setSecurableObject(
    SecurableObjectModel object,
  ) async =>
      securableObjectMap.addAll({
        object.id: object,
      });

  @override
  Future<SecurableObjectModel?> getSecurableObjectById(
    String objectId,
  ) async =>
      securableObjectMap[objectId];

  @override
  Future<SecurableObjectModel?> getSecurableObjectByName(
    String objectName,
  ) async {
    SecurableObjectModel? object;

    for (var obj in securableObjectMap.values) {
      if (obj.name == objectName) {
        object = obj;
        break;
      }
    }

    return object;
  }

  @override
  Future<List<SecurableObjectModel>> getAllSecurableObjects() async =>
      securableObjectMap.values.toList();

  @override
  Future<void> deleteSecurableObject(String objectId) async =>
      securableObjectMap.remove(objectId);

  ///////////////////////////// CRUD Accounts //////////////////////////////////
  @override
  Future<void> setAccount(AccountModel account) async =>
      accountMap.addAll({account.id: account});

  @override
  Future<AccountModel?> getAccountById(String accountId) async =>
      accountMap[accountId];

  @override
  Future<AccountModel?> getAccountByEmail(String accountEmail) async {
    AccountModel? account;

    for (var acc in accountMap.values) {
      if (acc.email == accountEmail) {
        account = acc;
        break;
      }
    }

    return account;
  }

  @override
  Future<List<AccountModel>> getAllAccounts() async =>
      accountMap.values.toList();

  @override
  Future<void> deleteAccount(String accountId) async {
    accountMap.remove(accountId);
  }

  ////////////////////////// CRUD Account Groups ///////////////////////////////
  @override
  Future<void> setAccountGroup(AccountGroupModel accountGroup) async =>
      accountGroupMap.addAll({accountGroup.id: accountGroup});

  @override
  Future<AccountGroupModel?> getAccountGroupById(String accountGroupId) async =>
      accountGroupMap[accountGroupId];

  @override
  Future<AccountGroupModel?> getAccountGroupByName(
    String accountGroupName,
  ) async {
    AccountGroupModel? accountGroup;

    for (var ag in accountGroupMap.values) {
      if (ag.name == accountGroupName) {
        accountGroup = ag;
        break;
      }
    }

    return accountGroup;
  }

  @override
  Future<List<AccountGroupModel>> getAccountGroupsByAccountIds(
    List<String> accountIds,
  ) async {
    var accountGroups = <AccountGroupModel>[];

    for (var ag in accountGroupMap.values) {
      if (ag.accountIds.containsAll(accountIds)) {
        accountGroups.add(ag);
        break;
      }
    }

    return accountGroups;
  }

  @override
  Future<List<AccountGroupModel>> getAllAccountGroups() async =>
      accountGroupMap.values.toList();

  @override
  Future<void> deleteAccountGroup(String accountGroupId) async {
    accountGroupMap.remove(accountGroupId);
  }

  /////////////////////////// CRUD Permissions /////////////////////////////////
  @override
  Future<void> setPermission(PermissionModel permission) async =>
      permissionMap.addAll({permission.id: permission});

  @override
  Future<PermissionModel?> getPermissionById(String permissionId) async =>
      permissionMap[permissionId];

  @override
  Future<PermissionModel?> getPermissionByName(String permissionName) async {
    PermissionModel? permission;

    for (var perm in permissionMap.values) {
      if (perm.name == permissionName) {
        permission = perm;
        break;
      }
    }

    return permission;
  }

  @override
  Future<List<PermissionModel>> getAllPermissions() async =>
      permissionMap.values.toList();

  @override
  Future<void> deletePermission(String permissionId) async =>
      permissionMap.remove(permissionId);

  ///////////////////////// CRUD Permission Groups /////////////////////////////
  @override
  Future<void> setPermissionGroup(
    PermissionGroupModel permissionGroup,
  ) async =>
      permissionGroupMap.addAll({permissionGroup.id: permissionGroup});

  @override
  Future<PermissionGroupModel?> getPermissionGroupById(
    String permissionGroupId,
  ) async =>
      permissionGroupMap[permissionGroupId];

  @override
  Future<PermissionGroupModel?> getPermissionGroupByName(
    String permissionGroupName,
  ) async {
    PermissionGroupModel? permissionGroup;

    for (var pg in permissionGroupMap.values) {
      if (pg.name == permissionGroupName) {
        permissionGroup = pg;
        break;
      }
    }

    return permissionGroup;
  }

  @override
  Future<List<PermissionGroupModel>> getPermissionGroupsByPermissionIds(
    List<String> permissionIds,
  ) async {
    var permissionGroups = <PermissionGroupModel>[];

    for (var pg in permissionGroupMap.values) {
      if (pg.permissionIds.containsAll(permissionIds)) {
        permissionGroups.add(pg);
        break;
      }
    }

    return permissionGroups;
  }

  @override
  Future<List<PermissionGroupModel>> getAllPermissionGroups() async =>
      permissionGroupMap.values.toList();

  @override
  Future<void> deletePermissionGroup(String permissionGroupId) async =>
      permissionGroupMap.remove(permissionGroupId);

  /////////////////////////// CRUD Assignments /////////////////////////////////
  @override
  Future<void> setRoleAssignment(
    RoleAssignmentModel assignment,
  ) async =>
      roleAssignmentMap.addAll({assignment.id: assignment});

  @override
  Future<RoleAssignmentModel?> getRoleAssignmentById(
    String assignmentId,
  ) async =>
      roleAssignmentMap[assignmentId];

  @override
  Future<List<RoleAssignmentModel>> getRoleAssignmentsByReference({
    String? objectId,
    String? accountId,
    String? accountGroupId,
    String? permissionId,
    String? permissionGroupId,
  }) async {
    var result = <String, RoleAssignmentModel>{};
    result.addAll(roleAssignmentMap);

    if (objectId != null) {
      result.removeWhere((key, value) => value.objectId != objectId);
    }

    if (accountId != null) {
      result.removeWhere((key, value) => value.accountId != accountId);
    }

    if (accountId != null) {
      result
          .removeWhere((key, value) => value.accountGroupId != accountGroupId);
    }

    if (permissionId != null) {
      result.removeWhere((key, value) => value.permissionId != permissionId);
    }

    if (permissionGroupId != null) {
      result.removeWhere(
        (key, value) => value.permissionGroupId != permissionGroupId,
      );
    }

    return result.values.toList();
  }

  @override
  Future<void> deleteRoleAssignment(String assignmentId) async =>
      roleAssignmentMap.remove(assignmentId);
}
