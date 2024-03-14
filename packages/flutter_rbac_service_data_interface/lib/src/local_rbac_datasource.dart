// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';

class LocalRbacDatasource implements RbacDataInterface {
  final securableObjectMap = <String, SecurableObjectDataModel>{};
  final roleMap = <String, RoleDataModel>{};
  final accountMap = <String, AccountDataModel>{};
  final permissionMap = <String, PermissionModel>{};
  final roleAssignmentMap = <String, RoleAssignmentModel>{};

  ///////////////////////// CRUD Securable Objects /////////////////////////////
  @override
  Future<void> setSecurableObject(
    SecurableObjectDataModel object,
  ) async =>
      securableObjectMap.addAll({
        object.id: object,
      });

  @override
  Future<SecurableObjectDataModel?> getSecurableObjectById(
    String objectId,
  ) async =>
      securableObjectMap[objectId];

  @override
  Future<SecurableObjectDataModel?> getSecurableObjectByName(
    String objectName,
  ) async {
    SecurableObjectDataModel? object;

    for (var obj in securableObjectMap.values) {
      if (obj.name == objectName) {
        object = obj;
        break;
      }
    }

    return object;
  }

  @override
  Future<List<SecurableObjectDataModel>> getAllSecurableObjects() async =>
      securableObjectMap.values.toList();

  @override
  Future<void> deleteSecurableObject(String objectId) async =>
      securableObjectMap.remove(objectId);

  /////////////////////////////// CRUD Roles ///////////////////////////////////
  @override
  Future<void> setRole(
    RoleDataModel role,
  ) async =>
      roleMap.addAll({role.id: role});

  @override
  Future<RoleDataModel?> getRoleById(String roleId) async => roleMap[roleId];

  @override
  Future<RoleDataModel?> getRoleByName(String roleName) async {
    RoleDataModel? role;

    for (var rl in roleMap.values) {
      if (rl.name == roleName) {
        role = rl;
        break;
      }
    }

    return role;
  }

  @override
  Future<List<RoleDataModel>> getRolesByPermissionIds(
    List<String> permissionIds,
  ) async {
    var roles = <RoleDataModel>[];

    for (var rl in roleMap.values) {
      if (rl.permissionIds.containsAll(permissionIds)) {
        roles.add(rl);
        break;
      }
    }

    return roles;
  }

  @override
  Future<List<RoleDataModel>> getAllRoles() async => roleMap.values.toList();

  @override
  Future<void> deleteRole(String roleId) async => roleMap.remove(roleId);

  ///////////////////////////// CRUD Accounts //////////////////////////////////
  @override
  Future<void> setAccount(AccountDataModel account) async =>
      accountMap.addAll({account.id: account});

  @override
  Future<AccountDataModel?> getAccountById(String accountId) async =>
      accountMap[accountId];

  @override
  Future<AccountDataModel?> getAccountByEmail(String accountEmail) async {
    AccountDataModel? account;

    for (var acc in accountMap.values) {
      if (acc.email == accountEmail) {
        account = acc;
        break;
      }
    }

    return account;
  }

  @override
  Future<List<AccountDataModel>> getAllAccounts() async =>
      accountMap.values.toList();

  @override
  Future<void> deleteAccount(String accountId) async {
    accountMap.remove(accountId);
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
    String? roleId,
    String? permissionId,
  }) async {
    var result = <String, RoleAssignmentModel>{};
    result.addAll(roleAssignmentMap);

    if (objectId != null) {
      result.removeWhere((key, value) => value.objectId != objectId);
    }

    if (accountId != null) {
      result.removeWhere((key, value) => value.accountId != accountId);
    }

    if (roleId != null) {
      result.removeWhere((key, value) => value.roleId != roleId);
    }

    if (permissionId != null) {
      result.removeWhere((key, value) => value.permissionId != permissionId);
    }

    return result.values.toList();
  }

  @override
  Future<void> deleteRoleAssignment(String assignmentId) async =>
      roleAssignmentMap.remove(assignmentId);
}
