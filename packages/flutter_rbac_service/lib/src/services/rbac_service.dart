// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:uuid/uuid.dart';

class RbacService {
  RbacService({RbacDataInterface? dataInterface})
      : _dataInterface = dataInterface ?? LocalRbacDatasource();
  final RbacDataInterface _dataInterface;

  final _uuid = const Uuid();

  // CRUD Securable Objects ///////////////////////////////////////////////////

  /// Creates a new securable object with the specified [name].
  ///
  /// If a securable object with the same name already exists, the existing
  /// object is returned.
  /// Otherwise, a new securable object is created with a unique ID and the
  /// provided [name].
  ///
  /// Returns the created or existing [SecurableObjectDataModel].
  Future<SecurableObjectDataModel> createSecurableObject(String name) async {
    var foundObject = await _dataInterface.getSecurableObjectByName(name);

    if (foundObject != null) {
      debugPrint('Securable object already exists: (ID: ${foundObject.id},'
          ' Name: ${foundObject.name})');

      return foundObject;
    }

    var object = SecurableObjectDataModel(
      id: _uuid.v4(),
      name: name,
    );
    await _dataInterface.setSecurableObject(object);

    return object;
  }

  /// Retrieves a securable object by its ID.
  ///
  /// Returns the [SecurableObjectDataModel] with the specified [objectId],
  /// if found.
  /// Returns `null` if no securable object with the specified ID is found.
  Future<SecurableObjectDataModel?> getSecurableObjectById(
    String objectId,
  ) async =>
      _dataInterface.getSecurableObjectById(objectId);

  /// Retrieves a securable object by its name.
  ///
  /// Returns the [SecurableObjectDataModel] with the specified [name],
  /// if found.
  /// Returns `null` if no securable object with the specified name is found.
  Future<SecurableObjectDataModel?> getSecurableObjectByName(
    String name,
  ) async =>
      _dataInterface.getSecurableObjectByName(name);

  /// Retrieves all securable objects.
  ///
  /// Returns a list of [SecurableObjectDataModel] containing all securable
  /// objects.
  Future<List<SecurableObjectDataModel>> getAllSecurableObjects() async =>
      _dataInterface.getAllSecurableObjects();

  /// Updates the name of a securable object specified by its [objectId].
  ///
  /// Retrieves the securable object with the specified [objectId].
  /// If the object is found, its name is updated to [newName] and saved.
  ///
  /// Returns the updated [SecurableObjectDataModel] if successful, `null`
  /// otherwise.
  Future<SecurableObjectDataModel?> updateSecurableObject(
    String objectId,
    String newName,
  ) async {
    var object = await _dataInterface.getSecurableObjectById(objectId);

    if (object == null) {
      debugPrint('Securable object not found: (ID: $objectId');
      return null;
    }

    object = object.copyWith(name: newName);

    await _dataInterface.setSecurableObject(object);

    return object;
  }

  /// Deletes a securable object specified by its [objectId].
  ///
  /// This method deletes the securable object with the specified [objectId].
  /// Before deletion, it retrieves all role assignments referencing the object
  /// and deletes them. Then, it deletes the securable object itself.
  ///
  /// Returns a list of IDs of deleted role assignments.
  Future<List<String>> deleteSecurableObject(String objectId) async {
    var deletedAssignments = <String>[];

    var assignments =
        await _dataInterface.getRoleAssignmentsByReference(objectId: objectId);

    for (var assignment in assignments) {
      await _dataInterface.deleteRoleAssignment(assignment.id);

      deletedAssignments.add(assignment.id);
    }

    await _dataInterface.deleteSecurableObject(objectId);

    return deletedAssignments;
  }

  // CRUD Roles ////////////////////////////////////////////////////////////////

  /// Creates a new role with the specified [name] and [permissionIds].
  ///
  /// If a role with the same name already exists, the existing role is
  /// returned.
  /// Otherwise, a new role is created with a unique ID, the provided [name],
  /// and the specified [permissionIds].
  ///
  /// Returns the created or existing [RoleDataModel].
  Future<RoleDataModel> createRole(
    String name,
    Set<String> permissionIds,
  ) async {
    var foundRole = await _dataInterface.getRoleByName(name);

    if (foundRole != null) {
      debugPrint('Permission already exists: (ID: ${foundRole.id},'
          ' Name: ${foundRole.name},'
          ' PermissionIDs: ${foundRole.permissionIds})');

      return foundRole;
    }

    var role = RoleDataModel(
      id: _uuid.v4(),
      name: name,
      permissionIds: permissionIds,
    );
    await _dataInterface.setRole(role);

    return role;
  }

  /// Retrieves a role by its ID.
  ///
  /// Returns the [RoleDataModel] with the specified [roleId], if found.
  /// Returns `null` if no role with the specified ID is found.
  Future<RoleDataModel?> getRoleById(String roleId) async =>
      _dataInterface.getRoleById(roleId);

  /// Retrieves a role by its name.
  ///
  /// Returns the [RoleDataModel] with the specified [roleName], if found.
  /// Returns `null` if no role with the specified name is found.
  Future<RoleDataModel?> getRoleByName(String roleName) async =>
      _dataInterface.getRoleByName(roleName);

  /// Retrieves all roles.
  ///
  /// Returns a list of [RoleDataModel] containing all roles.
  Future<List<RoleDataModel>> getAllRoles() async =>
      _dataInterface.getAllRoles();

  /// Updates the name of a role specified by its [roleId].
  ///
  /// Retrieves the role with the specified [roleId].
  /// If the role is found, its name is updated to [newName] and saved.
  ///
  /// Returns the updated [RoleDataModel] if successful, `null` otherwise.
  Future<RoleDataModel?> updateRole(String roleId, String newName) async {
    var role = await _dataInterface.getRoleById(roleId);

    if (role == null) {
      debugPrint('Role not found: (ID: $roleId');
      return null;
    }

    role = role.copyWith(name: newName);

    await _dataInterface.setRole(role);

    return role;
  }

  /// Deletes a role specified by its [roleId].
  ///
  /// This method deletes the role with the specified [roleId].
  /// Before deletion, it retrieves all role assignments referencing the role
  /// and deletes them. Then, it deletes the role itself.
  ///
  /// Returns a list of IDs of deleted role assignments.
  Future<List<String>> deleteRole(String roleId) async {
    var deletedAssignments = <String>[];

    var assignments =
        await _dataInterface.getRoleAssignmentsByReference(roleId: roleId);

    for (var assignment in assignments) {
      await _dataInterface.deleteRoleAssignment(assignment.id);

      deletedAssignments.add(assignment.id);
    }

    await _dataInterface.deleteRole(roleId);

    return deletedAssignments;
  }

  // CRUD Accounts /////////////////////////////////////////////////////////////

  /// Creates a new account with the specified [id] and [email].
  ///
  /// Creates a new [AccountDataModel] instance with the provided [id] and
  /// [email].
  /// Saves the newly created account.
  ///
  /// Returns the created [AccountDataModel].
  Future<AccountDataModel> createAccount(String id, String email) async {
    var account = AccountDataModel(id: id, email: email);

    await _dataInterface.setAccount(account);

    return account;
  }

  /// Retrieves an account by its ID.
  ///
  /// Returns the [AccountDataModel] with the specified [accountId], if found.
  /// Returns `null` if no account with the specified ID is found.
  Future<AccountDataModel?> getAccountById(String accountId) async =>
      _dataInterface.getAccountById(accountId);

  /// Retrieves an account by its email.
  ///
  /// Returns the [AccountDataModel] with the specified [accountEmail], if
  /// found.
  /// Returns `null` if no account with the specified email is found.
  Future<AccountDataModel?> getAccountByEmail(String accountEmail) async =>
      _dataInterface.getAccountByEmail(accountEmail);

  /// Retrieves all accounts.
  ///
  /// Returns a list of [AccountDataModel] containing all accounts.
  Future<List<AccountDataModel>> getAllAccounts() async =>
      _dataInterface.getAllAccounts();

  /// Updates the email of an account specified by its [accountId].
  ///
  /// Retrieves the account with the specified [accountId].
  /// If the account is found, its email is updated to [newEmail] and saved.
  ///
  /// Returns the updated [AccountDataModel] if successful, `null` otherwise.
  Future<AccountDataModel?> updateAccount(
    String accountId,
    String newEmail,
  ) async {
    var account = await _dataInterface.getAccountById(accountId);

    if (account == null) {
      debugPrint('Account not found: (ID: $accountId');
      return null;
    }

    account = account.copyWith(email: newEmail);

    await _dataInterface.setAccount(account);

    return account;
  }

  /// Deletes an account specified by its [accountId].
  ///
  /// This method deletes the account with the specified [accountId].
  /// Before deletion, it retrieves all role assignments referencing the account
  /// and deletes them. Then, it deletes the account itself.
  ///
  /// Returns a list of IDs of deleted role assignments.
  Future<List<String>> deleteAccount(String accountId) async {
    var deletedAssignments = <String>[];

    var assignments = await _dataInterface.getRoleAssignmentsByReference(
      accountId: accountId,
    );

    for (var assignment in assignments) {
      await _dataInterface.deleteRoleAssignment(assignment.id);

      deletedAssignments.add(assignment.id);
    }

    await _dataInterface.deleteAccount(accountId);

    return deletedAssignments;
  }

  // CRUD Permissions //////////////////////////////////////////////////////////

  /// Creates a new permission with the specified [name].
  ///
  /// If a permission with the same name already exists, the existing permission
  /// is returned.
  /// Otherwise, a new permission is created with a unique ID and the provided
  /// [name].
  ///
  /// Returns the created or existing [PermissionModel].
  Future<PermissionModel> createPermission(String name) async {
    var foundPermission = await _dataInterface.getPermissionByName(name);

    if (foundPermission != null) {
      debugPrint('Permission already exists: (ID: ${foundPermission.id},'
          ' Name: ${foundPermission.name})');

      return foundPermission;
    }

    var permission = PermissionModel(id: _uuid.v4(), name: name);
    await _dataInterface.setPermission(permission);

    return permission;
  }

  /// Retrieves a permission by its ID.
  ///
  /// Returns the [PermissionModel] with the specified [permissionId], if found.
  /// Returns `null` if no permission with the specified ID is found.
  Future<PermissionModel?> getPermissionById(String permissionId) async =>
      _dataInterface.getPermissionById(permissionId);

  /// Retrieves a permission by its name.
  ///
  /// Returns the [PermissionModel] with the specified [permissionName], if
  /// found.
  /// Returns `null` if no permission with the specified name is found.
  Future<PermissionModel?> getPermissionByName(String permissionName) async =>
      _dataInterface.getPermissionByName(permissionName);

  /// Retrieves all permissions.
  ///
  /// Returns a list of [PermissionModel] containing all permissions.
  Future<List<PermissionModel>> getAllPermissions() async =>
      _dataInterface.getAllPermissions();

  /// Updates the name of a permission specified by its [permissionId].
  ///
  /// Retrieves the permission with the specified [permissionId].
  /// If the permission is found, its name is updated to [newName] and saved.
  ///
  /// Returns the updated [PermissionModel] if successful, `null` otherwise.
  Future<PermissionModel?> updatePermission(
    String permissionId,
    String newName,
  ) async {
    var permission = await _dataInterface.getPermissionById(permissionId);

    if (permission == null) {
      debugPrint('Permission not found: (ID: $permissionId');
      return null;
    }

    permission = permission.copyWith(name: newName);

    await _dataInterface.setPermission(permission);

    return permission;
  }

  /// Deletes a permission specified by its [permissionId].
  ///
  /// This method deletes the permission with the specified [permissionId].
  /// Before deletion, it retrieves all role assignments referencing the
  /// permission and deletes them. Then, it retrieves all roles that have the
  /// permission and removes the permission from their permission list. Finally,
  /// it deletes the permission itself.
  ///
  /// Returns a list of IDs of deleted role assignments.
  Future<List<String>> deletePermission(String permissionId) async {
    var deletedAssignments = <String>[];

    var assignments = await _dataInterface.getRoleAssignmentsByReference(
      permissionId: permissionId,
    );

    for (var assignment in assignments) {
      await _dataInterface.deleteRoleAssignment(assignment.id);

      deletedAssignments.add(assignment.id);
    }

    var roles = await _dataInterface.getRolesByPermissionIds([permissionId]);

    for (var role in roles) {
      role.permissionIds.remove(permissionId);

      await _dataInterface.setRole(role);
    }

    await _dataInterface.deletePermission(permissionId);

    return deletedAssignments;
  }

  // CRUD Role Assignments //////////////////////////////////////////////////////////

  /// Creates a new role assignment.
  ///
  /// Creates a new [RoleAssignmentModel] with the specified parameters.
  /// The [objectId] and [accountId] are required. Either [roleId] or
  /// [permissionId] must be provided, but not both. If both are provided, the
  /// assignment creation fails.
  ///
  /// Returns the created [RoleAssignmentModel] if successful, `null` otherwise.
  Future<RoleAssignmentModel?> createRoleAssignment({
    required String objectId,
    required String accountId,
    String? roleId,
    String? permissionId,
  }) async {
    if (roleId != null && permissionId != null) {
      debugPrint('A role assignment should only contain either a '
          'role or permission, not both!');

      return null;
    }

    var foundAssignment = (await _dataInterface.getRoleAssignmentsByReference(
      objectId: objectId,
      accountId: accountId,
      roleId: roleId,
      permissionId: permissionId,
    ))
        .firstOrNull;

    if (foundAssignment != null) {
      debugPrint('Permission already exists: (ID: ${foundAssignment.id}');

      return foundAssignment;
    }

    var assignment = RoleAssignmentModel(
      id: _uuid.v4(),
      objectId: objectId,
      accountId: accountId,
      roleId: roleId,
      permissionId: permissionId,
    );
    await _dataInterface.setRoleAssignment(assignment);

    return assignment;
  }

  /// Retrieves a role assignment by its ID.
  ///
  /// Returns the [RoleAssignmentModel] with the specified [assignmentId], if
  /// found.
  /// Returns `null` if no role assignment with the specified ID is found.
  Future<RoleAssignmentModel?> getRoleAssignmentById(
    String assignmentId,
  ) async =>
      _dataInterface.getRoleAssignmentById(assignmentId);

  /// Retrieves role assignments based on the provided reference parameters.
  ///
  /// If any of the reference parameters are provided, this method retrieves
  /// role assignments matching those parameters from the data interface. If no
  /// reference parameters are provided, it retrieves all role assignments.
  ///
  /// Returns a list of [RoleAssignmentModel] that match the provided reference
  /// parameters.
  Future<List<RoleAssignmentModel>> getRoleAssignmentsByReference({
    String? objectId,
    String? accountId,
    String? roleId,
    String? permissionId,
  }) async =>
      _dataInterface.getRoleAssignmentsByReference(
        objectId: objectId,
        accountId: accountId,
        roleId: roleId,
        permissionId: permissionId,
      );

  /// Deletes a role assignment specified by its ID.
  ///
  /// This method deletes the role assignment with the specified [assignmentId].
  ///
  /// Returns `void`.
  Future<void> deleteRoleAssignment(String assignmentId) async =>
      _dataInterface.deleteRoleAssignment(assignmentId);

  // Other Methods /////////////////////////////////////////////////////////////

  /// Adds permissions to a role.
  ///
  /// Retrieves the role specified by [roleId]. If the role is found,
  /// the provided [permissionIds] are added to its permission list.
  /// The updated role is then saved.
  ///
  /// Returns the updated [RoleDataModel] if successful, `null` otherwise.
  Future<RoleDataModel?> addPermissionsToRole(
    String roleId,
    List<String> permissionIds,
  ) async {
    var role = await _dataInterface.getRoleById(roleId);

    if (role == null) {
      debugPrint('Role not found: (ID: $roleId');
      return null;
    }

    role.permissionIds.addAll(permissionIds);

    await _dataInterface.setRole(role);

    return role;
  }

  /// Removes permissions from a role.
  ///
  /// Retrieves the role specified by [roleId]. If the role is found,
  /// the provided [permissionIds] are removed from its permission list.
  /// The updated role is then saved.
  ///
  /// Returns the updated [RoleDataModel] if successful, `null` otherwise.
  Future<RoleDataModel?> removePermissionsFromRole(
    String roleId,
    List<String> permissionIds,
  ) async {
    var role = await _dataInterface.getRoleById(roleId);

    if (role == null) {
      debugPrint('Role not found: (ID: $roleId');
      return null;
    }

    role.permissionIds.removeAll(permissionIds);

    await _dataInterface.setRole(role);

    return role;
  }

  /// Grants permissions to an account for a specific object.
  ///
  /// Grants permissions specified by [permissionIds] to the account with ID
  /// [accountId] for the object with ID [objectId]. For each permission ID
  /// provided, this method checks if there is already an existing role
  /// assignment for the specified object, account, and permission combination.
  /// If no such assignment exists, a new assignment is created with a unique
  /// ID and saved to the data interface.
  ///
  /// Returns a list of [RoleAssignmentModel] representing the granted
  /// permissions.
  Future<List<RoleAssignmentModel>> grantAccountPermissions(
    String accountId,
    String objectId,
    List<String> permissionIds,
  ) async {
    var assignments = <RoleAssignmentModel>[];

    for (var pId in permissionIds) {
      var duplicateAssignments =
          await _dataInterface.getRoleAssignmentsByReference(
        objectId: objectId,
        accountId: accountId,
        permissionId: pId,
      );

      if (duplicateAssignments.isEmpty) {
        var id = _uuid.v4();

        var assignment = RoleAssignmentModel(
          id: id,
          objectId: objectId,
          accountId: accountId,
          permissionId: pId,
        );

        await _dataInterface.setRoleAssignment(assignment);

        assignments.add(assignment);
      } else {
        debugPrint(
          'Duplicate assignment: (ObjectID: $objectId, '
          'AccountID: $accountId, PermissionID: $pId)',
        );
      }
    }

    return assignments;
  }

  /// Revokes permissions from an account for a specific object.
  ///
  /// Revokes permissions specified by [permissionIds] from the account with ID
  /// [accountId] for the object with ID [objectId]. For each permission ID
  /// provided, this method retrieves all existing role assignments with the
  /// specified object, account, and permission combination, and deletes them
  /// from the data interface.
  ///
  /// Returns `void`.
  Future<void> revokeAccountPermissions(
    String accountId,
    String objectId,
    List<String> permissionIds,
  ) async {
    for (var pId in permissionIds) {
      var assignments = await _dataInterface.getRoleAssignmentsByReference(
        accountId: accountId,
        objectId: objectId,
        permissionId: pId,
      );

      for (var assignment in assignments) {
        await _dataInterface.deleteRoleAssignment(assignment.id);
      }
    }
  }

  /// Grants a role to an account for multiple objects.
  ///
  /// Grants the role specified by [roleId] to the account with ID [accountId]
  /// for multiple objects specified by [objectIds]. If [objectIds] is `null`,
  /// grants the role to the account for all securable objects available.
  /// For each object ID provided, this method checks if there is already an
  /// existing role assignment for the specified object, account, and role
  /// combination. If no such assignment exists, a new assignment is created
  /// with a unique ID and saved to the data interface.
  ///
  /// Returns a list of [RoleAssignmentModel] representing the granted roles.
  Future<List<RoleAssignmentModel>> grantRole(
    String accountId,
    String roleId, {
    List<String>? objectIds,
  }) async {
    var objIds = objectIds ?? <String>[];

    if (objectIds == null) {
      var objects = await _dataInterface.getAllSecurableObjects();

      for (var object in objects) {
        objIds.add(object.id);
      }
    }

    var assignments = <RoleAssignmentModel>[];

    for (var objectId in objIds) {
      var duplicateAssignments =
          await _dataInterface.getRoleAssignmentsByReference(
        objectId: objectId,
        accountId: accountId,
        roleId: roleId,
      );

      if (duplicateAssignments.isEmpty) {
        var id = _uuid.v4();

        var assignment = RoleAssignmentModel(
          id: id,
          objectId: objectId,
          accountId: accountId,
          roleId: roleId,
        );

        await _dataInterface.setRoleAssignment(assignment);

        assignments.add(assignment);
      } else {
        debugPrint(
          'Duplicate assignment: (ObjectID: $objectId, '
          'AccountID: $accountId, RoleID: $roleId)',
        );
      }
    }

    return assignments;
  }

  /// Revokes a role from an account for specified objects.
  ///
  /// Revokes the role with ID [roleId] from the account with ID [accountId] for
  /// the specified objects with IDs provided in [objectIds]. If [objectIds] is
  /// not provided, this method revokes the role from all objects in the system.
  /// For each object ID, this method retrieves all existing role assignments
  /// with the specified account, object, and role combination, and deletes them
  /// from the data interface.
  ///
  /// Returns `void`.
  Future<void> revokeRole(
    String accountId,
    String roleId, {
    List<String>? objectIds,
  }) async {
    var objIds = objectIds ?? <String>[];

    if (objectIds == null) {
      var objects = await _dataInterface.getAllSecurableObjects();

      for (var object in objects) {
        objIds.add(object.id);
      }
    }

    for (var objId in objIds) {
      var assignments = await _dataInterface.getRoleAssignmentsByReference(
        accountId: accountId,
        objectId: objId,
        roleId: roleId,
      );

      for (var assignment in assignments) {
        await _dataInterface.deleteRoleAssignment(assignment.id);
      }
    }
  }

  /// Retrieves roles assigned to an account for a specific object.
  ///
  /// Retrieves roles assigned to the account with ID [accountId] for the object
  /// with ID [objectId]. It queries the data interface to get all role
  /// assignments matching the provided account and object IDs. Then, it
  /// collects unique role IDs from these assignments and retrieves the
  /// corresponding role data models from the data interface. Finally, it
  /// returns a set of role data models associated with the account and object.
  ///
  /// Returns a [Set] of [RoleDataModel].
  Future<Set<RoleDataModel>> getAccountRoles(
    String accountId,
    String objectId,
  ) async {
    var assignments = await _dataInterface.getRoleAssignmentsByReference(
      objectId: objectId,
      accountId: accountId,
    );

    var roleIds = <String>{};

    for (var assignment in assignments) {
      if (assignment.roleId != null) {
        roleIds.add(assignment.roleId!);
      }
    }

    var roles = await _getRolesByIdList(roleIds.toList());

    return roles.toSet();
  }

  /// Retrieves permissions granted to an account based on assigned roles for a
  /// specific object.
  ///
  /// Retrieves permissions granted to the account with ID [accountId] based on
  /// the roles assigned to it for the object with ID [objectId]. It first
  /// retrieves the roles assigned to the account for the specified object using
  /// [getAccountRoles] method. Then, it collects all unique permission IDs
  /// associated with these roles and retrieves the corresponding permission
  /// data models from the data interface. Finally, it returns a set of
  /// permission data models granted to the account for the specified object.
  ///
  /// Returns a [Set] of [PermissionModel].
  Future<Set<PermissionModel>> getAccountRolePermissions(
    String accountId,
    String objectId,
  ) async {
    var listOfPermissions = <PermissionModel>{};

    var roles = await getAccountRoles(accountId, objectId);

    for (var role in roles) {
      listOfPermissions = {
        ...listOfPermissions,
        ...await _getPermissionsByIdList(role.permissionIds.toList()),
      };
    }

    return listOfPermissions;
  }

  /// Retrieves permissions directly assigned to an account for a specific
  /// object.
  ///
  /// Retrieves permissions directly assigned to the account with ID [accountId]
  /// for the object with ID [objectId]. It retrieves all role assignments
  /// associated with the account and object from the data interface using
  /// [getRoleAssignmentsByReference] method. Then, it collects all unique
  /// permission IDs from these role assignments. For each role assignment with
  /// a role ID, it retrieves the corresponding role from the data interface and
  /// adds its permission IDs to the set. If a role assignment has a permission
  /// ID directly, it adds that permission ID to the set. Finally, it retrieves
  /// the permission data models corresponding to the collected permission IDs
  /// and returns a set of permission models directly assigned to the account
  /// for the specified object.
  ///
  /// Returns a [Set] of [PermissionModel].
  Future<Set<PermissionModel>> getAccountPermissions(
    String accountId,
    String objectId,
  ) async {
    var permissionsIds = <String>{};

    var assignments = await _dataInterface.getRoleAssignmentsByReference(
      accountId: accountId,
      objectId: objectId,
    );

    for (var assignment in assignments) {
      if (assignment.roleId != null) {
        var role = await _dataInterface.getRoleById(assignment.roleId!);

        if (role != null) {
          permissionsIds.addAll(role.permissionIds);
        }
      }

      if (assignment.permissionId != null) {
        permissionsIds.add(assignment.permissionId!);
      }
    }

    var permissions =
        (await _getPermissionsByIdList(permissionsIds.toList())).toSet();

    return permissions;
  }

  /// Retrieves all role assignments.
  ///
  /// Retrieves all role assignments from the data interface using the
  /// [getRoleAssignmentsByReference] method without specifying any criteria.
  /// This method retrieves and returns a list of all role assignment models
  /// stored in the data interface.
  ///
  /// Returns a [List] of [RoleAssignmentModel].
  Future<List<RoleAssignmentModel>> getAllRoleAssignments() async =>
      _dataInterface.getRoleAssignmentsByReference();

  Future<List<RoleDataModel>> _getRolesByIdList(List<String> roleIds) async {
    var roles = <RoleDataModel>[];

    for (var roleId in roleIds) {
      var role = await _dataInterface.getRoleById(roleId);

      if (role != null) {
        roles.add(role);
      }
    }

    return roles;
  }

  Future<List<PermissionModel>> _getPermissionsByIdList(
    List<String> permissionIds,
  ) async {
    var permissions = <PermissionModel>[];

    for (var permissionId in permissionIds) {
      var permission = await _dataInterface.getPermissionById(permissionId);

      if (permission != null) {
        permissions.add(permission);
      }
    }

    return permissions;
  }
}
