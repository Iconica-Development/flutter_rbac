// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart";

abstract class RbacDataInterface {
  RbacDataInterface._();

  // CRUD Securable objects
  Future<void> setSecurableObject(SecurableObjectModel object);
  Future<SecurableObjectModel?> getSecurableObjectById(String objectId);
  Future<SecurableObjectModel?> getSecurableObjectByName(String objectName);
  Future<List<SecurableObjectModel>> getAllSecurableObjects();
  Future<void> deleteSecurableObject(String objectId);

  // CRUD Accounts
  Future<void> setAccount(AccountModel account);
  Future<AccountModel?> getAccountById(String accountId);
  Future<AccountModel?> getAccountByEmail(String accountEmail);
  Future<List<AccountModel>> getAllAccounts();
  Future<void> deleteAccount(String accountId);

  // CRUD Account Group
  Future<void> setAccountGroup(AccountGroupModel accountGroup);
  Future<AccountGroupModel?> getAccountGroupById(String accountGroupId);
  Future<AccountGroupModel?> getAccountGroupByName(String accountGroupName);
  Future<List<AccountGroupModel>> getAccountGroupsByAccountIds(
    List<String> accountIds,
  );
  Future<List<AccountGroupModel>> getAllAccountGroups();
  Future<void> deleteAccountGroup(String accountId);

  // CRUD Permission
  Future<void> setPermission(PermissionModel permission);
  Future<PermissionModel?> getPermissionById(String permissionId);
  Future<PermissionModel?> getPermissionByName(String permissionName);
  Future<List<PermissionModel>> getAllPermissions();
  Future<void> deletePermission(String permissionId);

  // CRUD Permission Groups
  Future<void> setPermissionGroup(PermissionGroupModel permissionGroup);
  Future<PermissionGroupModel?> getPermissionGroupById(
    String permissionGroupId,
  );
  Future<PermissionGroupModel?> getPermissionGroupByName(String roleName);
  Future<List<PermissionGroupModel>> getPermissionGroupsByPermissionIds(
    List<String> permissionIds,
  );
  Future<List<PermissionGroupModel>> getAllPermissionGroups();
  Future<void> deletePermissionGroup(String permissionGroupId);

  // CRUD Role Assignments
  Future<void> setRoleAssignment(RoleAssignmentModel assignment);
  Future<RoleAssignmentModel?> getRoleAssignmentById(String assignmentId);
  Future<List<RoleAssignmentModel>> getRoleAssignmentsByReference({
    String? objectId,
    String? accountId,
    String? accountGroupId,
    String? permissionId,
    String? permissionGroupId,
  });
  Future<void> deleteRoleAssignment(String assignmentId);
}
