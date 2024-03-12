// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';

abstract class RbacDataInterface {
  RbacDataInterface._();

  // CRUD Securable objects
  Future<void> setSecurableObject(SecurableObjectDataModel object);
  Future<SecurableObjectDataModel?> getSecurableObjectById(String objectId);
  Future<SecurableObjectDataModel?> getSecurableObjectByName(String objectName);
  Future<List<SecurableObjectDataModel>> getAllSecurableObjects();
  Future<void> deleteSecurableObject(String objectId);

  // CRUD Roles
  Future<void> setRole(RoleDataModel role);
  Future<RoleDataModel?> getRoleById(String roleId);
  Future<RoleDataModel?> getRoleByName(String roleName);
  Future<List<RoleDataModel>> getRolesByPermissionIds(
    List<String> permissionIds,
  );
  Future<List<RoleDataModel>> getAllRoles();
  Future<void> deleteRole(String roleId);

  // CRUD Accounts
  Future<void> setAccount(AccountDataModel account);
  Future<AccountDataModel?> getAccountById(String accountId);
  Future<AccountDataModel?> getAccountByEmail(String accountEmail);
  Future<List<AccountDataModel>> getAllAccounts();
  Future<void> deleteAccount(String accountId);

  // CRUD Permission
  Future<void> setPermission(PermissionModel permission);
  Future<PermissionModel?> getPermissionById(String permissionId);
  Future<PermissionModel?> getPermissionByName(String permissionName);
  Future<List<PermissionModel>> getAllPermissions();
  Future<void> deletePermission(String permissionId);

  // CRUD Role Assignments
  Future<void> setRoleAssignment(RoleAssignmentModel assignment);
  Future<RoleAssignmentModel?> getRoleAssignmentById(String assignmentId);
  Future<List<RoleAssignmentModel>> getRoleAssignmentsByReference({
    String? objectId,
    String? accountId,
    String? roleId,
    String? permissionId,
  });
  Future<void> deleteRoleAssignment(String assignmentId);
}
