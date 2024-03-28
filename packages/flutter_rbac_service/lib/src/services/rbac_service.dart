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

  // Securable Objects /////////////////////////////////////////////////////////

  /// Creates a new securable object with the specified [name].
  ///
  /// If a securable object with the same name already exists, the existing
  /// object is returned.
  /// Otherwise, a new securable object is created with a unique ID and the
  /// provided [name].
  ///
  /// Returns the created or existing [SecurableObjectModel].
  Future<SecurableObjectModel> createSecurableObject(String name) async {
    var foundObject = await _dataInterface.getSecurableObjectByName(name);

    if (foundObject != null) {
      debugPrint('Securable object already exists: (ID: ${foundObject.id},'
          ' Name: ${foundObject.name})');

      return foundObject;
    }

    var object = SecurableObjectModel(
      id: _uuid.v4(),
      name: name,
    );
    await _dataInterface.setSecurableObject(object);

    return object;
  }

  /// Retrieves a securable object by its ID.
  ///
  /// Returns the [SecurableObjectModel] with the specified [objectId],
  /// if found.
  /// Returns `null` if no securable object with the specified ID is found.
  Future<SecurableObjectModel?> getSecurableObjectById(
    String objectId,
  ) async =>
      _dataInterface.getSecurableObjectById(objectId);

  /// Retrieves a securable object by its name.
  ///
  /// Returns the [SecurableObjectModel] with the specified [name],
  /// if found.
  /// Returns `null` if no securable object with the specified name is found.
  Future<SecurableObjectModel?> getSecurableObjectByName(
    String name,
  ) async =>
      _dataInterface.getSecurableObjectByName(name);

  /// Retrieves all securable objects.
  ///
  /// Returns a list of [SecurableObjectModel] containing all securable
  /// objects.
  Future<List<SecurableObjectModel>> getAllSecurableObjects() async =>
      _dataInterface.getAllSecurableObjects();

  /// Updates the name of a securable object specified by its [objectId].
  ///
  /// Retrieves the securable object with the specified [objectId].
  /// If the object is found, its name is updated to [newName] and saved.
  ///
  /// Returns the updated [SecurableObjectModel] if successful, `null`
  /// otherwise.
  Future<SecurableObjectModel?> updateSecurableObject(
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

  // Accounts //////////////////////////////////////////////////////////////////

  /// Creates a new account with the specified [id] and [email].
  ///
  /// Creates a new [AccountModel] instance with the provided [id] and
  /// [email].
  /// Saves the newly created account.
  ///
  /// Returns the created [AccountModel].
  Future<AccountModel> createAccount(String id, String email) async {
    var account = AccountModel(id: id, email: email);

    await _dataInterface.setAccount(account);

    return account;
  }

  /// Retrieves an account by its ID.
  ///
  /// Returns the [AccountModel] with the specified [accountId], if found.
  /// Returns `null` if no account with the specified ID is found.
  Future<AccountModel?> getAccountById(String accountId) async =>
      _dataInterface.getAccountById(accountId);

  /// Retrieves an account by its email.
  ///
  /// Returns the [AccountModel] with the specified [accountEmail], if
  /// found.
  /// Returns `null` if no account with the specified email is found.
  Future<AccountModel?> getAccountByEmail(String accountEmail) async =>
      _dataInterface.getAccountByEmail(accountEmail);

  /// Retrieves all accounts.
  ///
  /// Returns a list of [AccountModel] containing all accounts.
  Future<List<AccountModel>> getAllAccounts() async =>
      _dataInterface.getAllAccounts();

  /// Updates the email of an account specified by its [accountId].
  ///
  /// Retrieves the account with the specified [accountId].
  /// If the account is found, its email is updated to [newEmail] and saved.
  ///
  /// Returns the updated [AccountModel] if successful, `null` otherwise.
  Future<AccountModel?> updateAccount(
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

  /// Deletes an account and its associated data.
  ///
  /// Deletes the account specified by [accountId] from the data interface,
  /// along with its associated role assignments and account groups. This method
  /// retrieves all role assignments and account groups associated with the
  /// specified account ID, removes them, and then deletes the account itself.
  ///
  /// Returns a [List] of [String] representing the IDs of the deleted role
  /// assignments.
  Future<List<String>> deleteAccount(String accountId) async {
    var deletedAssignments = <String>[];

    var assignments = await _dataInterface.getRoleAssignmentsByReference(
      accountId: accountId,
    );

    for (var assignment in assignments) {
      await _dataInterface.deleteRoleAssignment(assignment.id);

      deletedAssignments.add(assignment.id);
    }

    var accountGroups =
        await _dataInterface.getAccountGroupsByAccountIds([accountId]);

    for (var ag in accountGroups) {
      ag.accountIds.remove(accountId);

      await _dataInterface.setAccountGroup(ag);
    }

    await _dataInterface.deleteAccount(accountId);

    return deletedAssignments;
  }

  // Account Groups ////////////////////////////////////////////////////////////

  /// Creates an account group.
  ///
  /// Creates and stores an account group with the specified [id], [name], and
  /// [accountIds] in the data interface.
  ///
  /// Returns a [Future] that completes with the created [AccountGroupModel].
  Future<AccountGroupModel> createAccountGroup(
    String name,
    Set<String> accountIds,
  ) async {
    var foundGroup = await _dataInterface.getAccountGroupByName(name);

    if (foundGroup != null) {
      debugPrint('Account group already exists: (ID: ${foundGroup.id},'
          ' Name: ${foundGroup.name})');

      return foundGroup;
    }

    var group = AccountGroupModel(
      id: _uuid.v4(),
      name: name,
      accountIds: accountIds,
    );
    await _dataInterface.setAccountGroup(group);

    return group;
  }

  /// Retrieves an account group by its ID.
  ///
  /// Retrieves and returns the account group with the specified
  /// [accountGroupId] from the data interface.
  ///
  /// Returns a [Future] that completes with the retrieved [AccountGroupModel],
  /// or `null` if no group is found.
  Future<AccountGroupModel?> getAccountGroupById(String accountGroupId) async =>
      _dataInterface.getAccountGroupById(accountGroupId);

  /// Retrieves an account group by its name.
  ///
  /// Retrieves and returns the account group with the specified
  /// [accountGroupName] from the data interface.
  ///
  /// Returns a [Future] that completes with the retrieved [AccountGroupModel],
  /// or `null` if no group is found.
  Future<AccountGroupModel?> getAccountGroupByName(
    String accountGroupName,
  ) async =>
      _dataInterface.getAccountGroupByName(accountGroupName);

  Future<List<AccountGroupModel>> getAccountGroupsByAccountIds(
    List<String> accountIds,
  ) async =>
      _dataInterface.getAccountGroupsByAccountIds(accountIds);

  /// Retrieves all account groups.
  ///
  /// Retrieves and returns a list of all account groups stored in the data
  /// interface.
  ///
  /// Returns a [Future] that completes with a list of [AccountGroupModel].
  Future<List<AccountGroupModel>> getAllAccountGroups() async =>
      _dataInterface.getAllAccountGroups();

  /// Updates an existing account group.
  ///
  /// Updates the account group specified by [accountGroupId] with the provided
  /// [newName] and/or [accountIds]. At least one of [newName] or [accountIds]
  /// must be provided.
  ///
  /// If both [newName] and [accountIds] are `null`, the function returns `null`
  /// .
  ///
  /// Returns a [Future] that completes with the updated [AccountGroupModel],
  /// or `null`
  /// if the account group is not found or if both [newName] and [accountIds]
  /// are `null`.
  Future<AccountGroupModel?> updateAccountGroup(
    String accountGroupId, {
    String? newName,
    Set<String>? accountIds,
  }) async {
    if (newName == null && accountIds == null) {
      debugPrint(
          'Make sure to either update with a new name or new account ids: '
          '(ID: $accountGroupId');
      return null;
    }

    var group = await _dataInterface.getAccountGroupById(accountGroupId);

    if (group == null) {
      debugPrint('Account group not found: (ID: $accountGroupId');
      return null;
    }

    group = group.copyWith(name: newName, accountIds: accountIds);

    await _dataInterface.setAccountGroup(group);

    return group;
  }

  /// Deletes an account group.
  ///
  /// Deletes the account group specified by [accountGroupId]. This operation
  /// also deletes any associated role assignments related to the account group.
  ///
  /// Returns a [Future] that completes with a list of IDs of the deleted role
  /// assignments.
  Future<List<String>> deleteAccountGroup(String accountGroupId) async {
    var deletedAssignments = <String>[];

    var assignments = await _dataInterface.getRoleAssignmentsByReference(
      accountGroupId: accountGroupId,
    );

    for (var assignment in assignments) {
      await _dataInterface.deleteRoleAssignment(assignment.id);

      deletedAssignments.add(assignment.id);
    }

    await _dataInterface.deleteAccountGroup(accountGroupId);

    return deletedAssignments;
  }

  /// Adds accounts to an account group.
  ///
  /// Adds the accounts specified by [accountIds] to the account group specified
  /// by [accountgroupId]. If the account group doesn't exist, returns null.
  ///
  /// Returns a [Future] that completes with the updated [AccountGroupModel]
  /// after adding the accounts, or null if the account group was not found.
  Future<AccountGroupModel?> addAccountsToAccountGroup(
    String accountgroupId,
    List<String> accountIds,
  ) async {
    var group = await _dataInterface.getAccountGroupById(accountgroupId);

    if (group == null) {
      debugPrint('Account group not found: (ID: $accountgroupId');
      return null;
    }

    group.accountIds.addAll(accountIds);

    await _dataInterface.setAccountGroup(group);

    return group;
  }

  /// Removes accounts from an account group.
  ///
  /// Removes the accounts specified by [accountIds] from the account group
  /// specified by [accountGroupId]. If the account group doesn't exist, returns
  /// null.
  ///
  /// Returns a [Future] that completes with the updated [AccountGroupModel]
  /// after removing the accounts, or null if the account group was not found.
  Future<AccountGroupModel?> removeAccountsFromAccountsGroup(
    String accountGroupId,
    List<String> accountIds,
  ) async {
    var group = await _dataInterface.getAccountGroupById(accountGroupId);

    if (group == null) {
      debugPrint('Account group not found: (ID: $accountGroupId');
      return null;
    }

    group.accountIds.removeAll(accountIds);

    await _dataInterface.setAccountGroup(group);

    return group;
  }

  // Permissions ///////////////////////////////////////////////////////////////

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

    var groups = await _dataInterface.getPermissionGroupsByPermissionIds(
      [permissionId],
    );

    for (var group in groups) {
      group.permissionIds.remove(permissionId);

      await _dataInterface.setPermissionGroup(group);
    }

    await _dataInterface.deletePermission(permissionId);

    return deletedAssignments;
  }

  // Permission Groups /////////////////////////////////////////////////////////

  Future<PermissionGroupModel> createPermissionGroup(
    String name,
    Set<String> permissionIds,
  ) async {
    var foundGroup = await _dataInterface
        .getPermissionGroupsByPermissionIds(permissionIds.toList());

    if (foundGroup.isNotEmpty) {
      debugPrint('Permission group already exists: (ID: ${foundGroup.first.id},'
          ' Name: ${foundGroup.first.name},'
          ' PermissionIDs: ${foundGroup.first.permissionIds})');

      return foundGroup.first;
    }

    var group = PermissionGroupModel(
      id: _uuid.v4(),
      name: name,
      permissionIds: permissionIds,
    );
    await _dataInterface.setPermissionGroup(group);

    return group;
  }

  /// Retrieves a permission group by ID.
  ///
  /// Retrieves the permission group with the specified [permissionGroupId].
  ///
  /// Returns a [Future] that completes with the [PermissionGroupModel] if
  /// found, otherwise returns `null`.
  Future<PermissionGroupModel?> getPermissionGroupById(
    String permissionGroupId,
  ) async =>
      _dataInterface.getPermissionGroupById(permissionGroupId);

  /// Retrieves a permission group by name.
  ///
  /// Retrieves the permission group with the specified [permissionGroupName].
  ///
  /// Returns a [Future] that completes with the [PermissionGroupModel] if
  /// found, otherwise returns `null`.
  Future<PermissionGroupModel?> getPermissionGroupByName(
    String permissionGroupName,
  ) async =>
      _dataInterface.getPermissionGroupByName(permissionGroupName);

  /// Retrieves all permission groups.
  ///
  /// Returns a [Future] that completes with a list of [PermissionGroupModel]s
  /// representing all permission groups stored in the data interface.
  Future<List<PermissionGroupModel>> getAllPermissionGroups() async =>
      _dataInterface.getAllPermissionGroups();

  /// Updates a permission group.
  ///
  /// If [newName] and [newPermissionIds] are both `null`, returns `null`.
  /// If [newName] is `null`, only updates the permission IDs.
  /// If [newPermissionIds] is `null`, only updates the name.
  ///
  /// Returns a [Future] that completes with the updated [PermissionGroupModel].
  Future<PermissionGroupModel?> updatePermissionGroup(
    String permissionGroupId, {
    String? newName,
    Set<String>? newPermissionIds,
  }) async {
    if (newName == null && newPermissionIds == null) {
      debugPrint(
          'Make sure to either update with a new name or new permission ids: '
          '(ID: $permissionGroupId');
      return null;
    }

    var group = await _dataInterface.getPermissionGroupById(permissionGroupId);

    if (group == null) {
      debugPrint('Permission group not found: (ID: $permissionGroupId');
      return null;
    }

    group = group.copyWith(name: newName, permissionIds: newPermissionIds);

    await _dataInterface.setPermissionGroup(group);

    return group;
  }

  /// Deletes a permission group and all its related assignments.
  ///
  /// Returns a [Future] that completes with a list of IDs of deleted
  /// assignments.
  Future<List<String>> deletePermissionGroup(String permissionGroupId) async {
    var deletedAssignments = <String>[];

    var assignments = await _dataInterface.getRoleAssignmentsByReference(
      permissionGroupId: permissionGroupId,
    );

    for (var assignment in assignments) {
      await _dataInterface.deleteRoleAssignment(assignment.id);

      deletedAssignments.add(assignment.id);
    }

    await _dataInterface.deletePermissionGroup(permissionGroupId);

    return deletedAssignments;
  }

  /// Adds permissions to a permission group.
  ///
  /// Retrieves the permission group with the given [permissiongroupId]
  /// from the data interface. If the group is not found, returns null.
  ///
  /// Adds the provided [permissionIds] to the permission group's existing
  /// permissions.
  ///
  /// Persists the updated permission group using the data interface.
  ///
  /// Returns a [Future] that completes with the updated permission group if
  /// successful,
  /// otherwise null.
  Future<PermissionGroupModel?> addPermissionsToPermissionGroup(
    String permissiongroupId,
    List<String> permissionIds,
  ) async {
    var group = await _dataInterface.getPermissionGroupById(permissiongroupId);

    if (group == null) {
      debugPrint('Permission group not found: (ID: $permissiongroupId');
      return null;
    }

    group.permissionIds.addAll(permissionIds);

    await _dataInterface.setPermissionGroup(group);

    return group;
  }

  /// Removes permissions from a permission group.
  ///
  /// Retrieves the permission group with the given [permissionGroupId] from
  /// the data interface. If the group is not found, returns null.
  ///
  /// Removes the provided [permissionIds] from the permission group's existing
  /// permissions.
  ///
  /// Persists the updated permission group using the data interface.
  ///
  /// Returns a [Future] that completes with the updated permission group if
  /// successful, otherwise null.
  Future<PermissionGroupModel?> removePermissionsFromPermissionGroup(
    String permissionGroupId,
    List<String> permissionIds,
  ) async {
    var group = await _dataInterface.getPermissionGroupById(permissionGroupId);

    if (group == null) {
      debugPrint('Permission group not found: (ID: $permissionGroupId');
      return null;
    }

    group.permissionIds.removeAll(permissionIds);

    await _dataInterface.setPermissionGroup(group);

    return group;
  }

  // Role Assignments //////////////////////////////////////////////////////////

  /// Creates a role assignment.
  ///
  /// Creates a new role assignment with the specified parameters.
  ///
  /// - If both [permissionGroupId] and [permissionId] are provided, returns
  /// null.
  /// - If both [accountId] and [accountGroupId] are provided, returns null.
  ///
  /// Retrieves the role assignment with the provided parameters from the data
  /// interface. If a matching assignment is found, returns it.
  ///
  /// Otherwise, creates a new role assignment with a unique ID and the provided
  /// parameters.
  ///
  /// Persists the new role assignment using the data interface.
  ///
  /// Returns a [Future] that completes with the created role assignment if
  /// successful, otherwise null.
  Future<RoleAssignmentModel?> createRoleAssignment({
    required String objectId,
    String? accountId,
    String? accountGroupId,
    String? permissionId,
    String? permissionGroupId,
  }) async {
    if (permissionGroupId != null && permissionId != null) {
      debugPrint('A role assignment should only contain either a '
          'role or permission, not both!');

      return null;
    }

    if (accountId != null && accountGroupId != null) {
      debugPrint('A role assignment should only contain either a '
          'account or account group, not both!');

      return null;
    }

    var foundAssignment = (await _dataInterface.getRoleAssignmentsByReference(
      objectId: objectId,
      accountId: accountId,
      accountGroupId: accountGroupId,
      permissionId: permissionId,
      permissionGroupId: permissionGroupId,
    ))
        .firstOrNull;

    if (foundAssignment != null) {
      debugPrint('Role assignment already exists: (ID: ${foundAssignment.id}');

      return foundAssignment;
    }

    var assignment = RoleAssignmentModel(
      id: _uuid.v4(),
      objectId: objectId,
      accountId: accountId,
      accountGroupId: accountGroupId,
      permissionId: permissionId,
      permissionGroupId: permissionGroupId,
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

  /// Retrieves role assignments by reference.
  ///
  /// Retrieves role assignments based on the provided parameters.
  ///
  /// The parameters specify filters to match against the properties of the role
  /// assignments:
  /// - [objectId]: Object ID to filter role assignments by.
  /// - [accountId]: Account ID to filter role assignments by.
  /// - [accountGroupId]: Account group ID to filter role assignments by.
  /// - [permissionId]: Permission ID to filter role assignments by.
  /// - [permissionGroupId]: Permission group ID to filter role assignments by.
  ///
  /// Returns a [Future] that completes with a list of role assignments that
  /// match the provided filters.
  Future<List<RoleAssignmentModel>> getRoleAssignmentsByReference({
    String? objectId,
    String? accountId,
    String? accountGroupId,
    String? permissionId,
    String? permissionGroupId,
  }) async =>
      _dataInterface.getRoleAssignmentsByReference(
        objectId: objectId,
        accountId: accountId,
        accountGroupId: accountGroupId,
        permissionId: permissionId,
        permissionGroupId: permissionGroupId,
      );

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

  /// Deletes a role assignment specified by its ID.
  ///
  /// This method deletes the role assignment with the specified [assignmentId].
  ///
  /// Returns `void`.
  Future<void> deleteRoleAssignment(String assignmentId) async =>
      _dataInterface.deleteRoleAssignment(assignmentId);

  /// Grants permissions to an account.
  ///
  /// Grants the specified [permissionIds] to the account identified by
  /// [accountId] for the object identified by [objectId].
  ///
  /// If a role assignment with the same object ID, account ID, and permission
  /// ID already exists, it won't be duplicated.
  ///
  /// Returns a [Future] that completes with a list of role assignments
  /// representing the permissions granted to the account for the specified
  /// object.
  Future<List<RoleAssignmentModel>> grantPermissionsToAccount(
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

  /// Revokes permissions from an account.
  ///
  /// Revokes the specified [permissionIds] from the account identified by
  /// [accountId] for the object identified by [objectId].
  ///
  /// Deletes role assignments corresponding to the specified permissions and
  /// account-object combination.
  ///
  /// Parameters:
  /// - [accountId]: The ID of the account from which permissions are revoked.
  /// - [objectId]: The ID of the object for which permissions are revoked.
  /// - [permissionIds]: The IDs of the permissions to revoke.
  ///
  /// Returns a [Future] that completes when the permissions are successfully
  /// revoked.
  Future<void> revokePermissionsFromAccount(
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

  /// Grants permissions to an account group.
  ///
  /// Grants the specified [permissionIds] to the account group identified by
  /// [accountGroupId] for the object identified by [objectId].
  ///
  /// Creates role assignments corresponding to the specified permissions and
  /// account group-object combination.
  ///
  /// Parameters:
  /// - [accountGroupId]: The ID of the account group to which permissions are
  /// granted.
  /// - [objectId]: The ID of the object for which permissions are granted.
  /// - [permissionIds]: The IDs of the permissions to grant.
  ///
  /// Returns a [Future] containing a list of [RoleAssignmentModel]s
  /// representing the newly created assignments.
  Future<List<RoleAssignmentModel>> grantPermissionsToAccountGroup(
    String accountGroupId,
    String objectId,
    List<String> permissionIds,
  ) async {
    var assignments = <RoleAssignmentModel>[];

    for (var pId in permissionIds) {
      var duplicateAssignments =
          await _dataInterface.getRoleAssignmentsByReference(
        objectId: objectId,
        accountGroupId: accountGroupId,
        permissionId: pId,
      );

      if (duplicateAssignments.isEmpty) {
        var id = _uuid.v4();

        var assignment = RoleAssignmentModel(
          id: id,
          objectId: objectId,
          accountGroupId: accountGroupId,
          permissionId: pId,
        );

        await _dataInterface.setRoleAssignment(assignment);

        assignments.add(assignment);
      } else {
        debugPrint(
          'Duplicate assignment: (ObjectID: $objectId, '
          'AccountGroupID: $accountGroupId, PermissionID: $pId)',
        );
      }
    }

    return assignments;
  }

  /// Revokes permissions from an account group.
  ///
  /// Revokes the specified [permissionIds] from the account group identified by
  /// [accountGroupId] for the object identified by [objectId].
  ///
  /// Removes role assignments corresponding to the specified permissions and
  /// account group-object combination.
  ///
  /// Parameters:
  /// - [accountGroupId]: The ID of the account group from which permissions are
  /// revoked.
  /// - [objectId]: The ID of the object for which permissions are revoked.
  /// - [permissionIds]: The IDs of the permissions to revoke.
  ///
  /// Returns a [Future] that completes when the revocation process is finished.
  Future<void> revokePermissionFromAccountGroup(
    String accountGroupId,
    String objectId,
    List<String> permissionIds,
  ) async {
    for (var pId in permissionIds) {
      var assignments = await _dataInterface.getRoleAssignmentsByReference(
        accountGroupId: accountGroupId,
        objectId: objectId,
        permissionId: pId,
      );

      for (var assignment in assignments) {
        await _dataInterface.deleteRoleAssignment(assignment.id);
      }
    }
  }

  /// Grants a permission group to an account.
  ///
  /// Grants the permissions associated with the [permissionGroupId] to the
  /// account identified by [accountId] for the specified objects.
  ///
  /// If [objectIds] is not provided, permissions are granted to all available
  /// objects.
  ///
  /// Parameters:
  /// - [accountId]: The ID of the account to which the permission group is
  /// granted.
  /// - [permissionGroupId]: The ID of the permission group to grant.
  /// - [objectIds]: (Optional) The IDs of the objects for which permissions are
  /// granted.
  ///
  /// Returns a [Future] containing a list of [RoleAssignmentModel] instances
  /// representing the newly created role assignments.
  Future<List<RoleAssignmentModel>> grantPermissionGroupToAccount(
    String accountId,
    String permissionGroupId, {
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
        permissionGroupId: permissionGroupId,
      );

      if (duplicateAssignments.isEmpty) {
        var id = _uuid.v4();

        var assignment = RoleAssignmentModel(
          id: id,
          objectId: objectId,
          accountId: accountId,
          permissionGroupId: permissionGroupId,
        );

        await _dataInterface.setRoleAssignment(assignment);

        assignments.add(assignment);
      } else {
        debugPrint(
          'Duplicate assignment: (ObjectID: $objectId, '
          'AccountID: $accountId, PermissionGroupID: $permissionGroupId)',
        );
      }
    }

    return assignments;
  }

  /// Revokes a permission group from an account.
  ///
  /// Revokes the permissions associated with the [permissionGroupId] from the
  /// account identified by [accountId] for the specified objects.
  ///
  /// If [objectIds] is not provided, permissions are revoked from all available
  /// objects.
  ///
  /// Parameters:
  /// - [accountId]: The ID of the account from which the permission group is
  /// revoked.
  /// - [permissionGroupId]: The ID of the permission group to revoke.
  /// - [objectIds]: (Optional) The IDs of the objects from which permissions
  /// are revoked.
  ///
  /// Returns a [Future] indicating the completion of the operation.
  Future<void> revokePerissionGroupFromAccount(
    String accountId,
    String permissionGroupId, {
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
        permissionGroupId: permissionGroupId,
      );

      for (var assignment in assignments) {
        await _dataInterface.deleteRoleAssignment(assignment.id);
      }
    }
  }

  /// Grants a permission group to an account group.
  ///
  /// Grants the permissions associated with the [permissionGroupId] to the
  /// account group identified by [accountGroupId] for the specified objects.
  ///
  /// If [objectIds] is not provided, permissions are granted to all available
  /// objects.
  ///
  /// Parameters:
  /// - [accountGroupId]: The ID of the account group to which the permission
  /// group is granted.
  /// - [permissionGroupId]: The ID of the permission group to grant.
  /// - [objectIds]: (Optional) The IDs of the objects to which permissions are
  /// granted.
  ///
  /// Returns a [Future] containing a list of [RoleAssignmentModel] representing
  /// the assignments for each granted permission.
  Future<List<RoleAssignmentModel>> grantPermissionGroupToAccountGroup(
    String accountGroupId,
    String permissionGroupId, {
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
        accountGroupId: accountGroupId,
        permissionGroupId: permissionGroupId,
      );

      if (duplicateAssignments.isEmpty) {
        var id = _uuid.v4();

        var assignment = RoleAssignmentModel(
          id: id,
          objectId: objectId,
          accountGroupId: accountGroupId,
          permissionGroupId: permissionGroupId,
        );

        await _dataInterface.setRoleAssignment(assignment);

        assignments.add(assignment);
      } else {
        debugPrint(
          'Duplicate assignment: (ObjectID: $objectId, AccountGroupID: '
          '$accountGroupId, PermissionGroupID: $permissionGroupId)',
        );
      }
    }

    return assignments;
  }

  /// Revokes a permission group from an account group.
  ///
  /// Revokes the permissions associated with the [permissionGroupId] from the
  /// account group identified by [accountGroupId] for the specified objects.
  ///
  /// If [objectIds] is not provided, permissions are revoked from all available
  /// objects.
  ///
  /// Parameters:
  /// - [accountGroupId]: The ID of the account group from which the permission
  /// group is revoked.
  /// - [permissionGroupId]: The ID of the permission group to revoke.
  /// - [objectIds]: (Optional) The IDs of the objects from which permissions
  /// are revoked.
  ///
  /// Returns a [Future] representing the asynchronous operation.
  Future<void> revokePerissionGroupFromAccountGroup(
    String accountGroupId,
    String permissionGroupId, {
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
        accountGroupId: accountGroupId,
        objectId: objId,
        permissionGroupId: permissionGroupId,
      );

      for (var assignment in assignments) {
        await _dataInterface.deleteRoleAssignment(assignment.id);
      }
    }
  }

  // Other Methods /////////////////////////////////////////////////////////////

  /// Retrieves the permission groups associated with an account for a specific
  /// object.
  ///
  /// Retrieves the permission groups associated with the account identified by
  /// [accountId] for the object identified by [objectId].
  ///
  /// Parameters:
  /// - [accountId]: The ID of the account for which permission groups are
  /// retrieved.
  /// - [objectId]: The ID of the object for which permission groups are
  /// retrieved.
  ///
  /// Returns a [Future] that completes with a [Set] of [PermissionGroupModel].
  Future<Set<PermissionGroupModel>> getPermissionGroupsOfAccount(
    String accountId,
    String objectId,
  ) async {
    var assignments = await _dataInterface.getRoleAssignmentsByReference(
      objectId: objectId,
      accountId: accountId,
    );

    var permissionGroupsIds = <String>{};

    for (var assignment in assignments) {
      if (assignment.permissionGroupId != null) {
        permissionGroupsIds.add(assignment.permissionGroupId!);
      }
    }

    var accountGroups =
        await _dataInterface.getAccountGroupsByAccountIds([accountId]);

    for (var ag in accountGroups) {
      var groupAssignments = await _dataInterface.getRoleAssignmentsByReference(
        objectId: objectId,
        accountGroupId: ag.id,
      );

      for (var assignment in groupAssignments) {
        if (assignment.permissionGroupId != null) {
          permissionGroupsIds.add(assignment.permissionGroupId!);
        }
      }
    }

    var permissionGroups =
        await _getPermissionGroupsByIdList(permissionGroupsIds.toList());

    return permissionGroups.toSet();
  }

  /// Retrieves the permissions associated with an account for a specific
  /// object.
  ///
  /// Retrieves the permissions associated with the account identified by
  /// [accountId] for the object identified by [objectId].
  ///
  /// Parameters:
  /// - [accountId]: The ID of the account for which permissions are retrieved.
  /// - [objectId]: The ID of the object for which permissions are retrieved.
  ///
  /// Returns a [Future] that completes with a [Set] of [PermissionModel].
  Future<Set<PermissionModel>> getPermissionsOfAccount(
    String accountId,
    String objectId,
  ) async {
    var permissionsIds = <String>{};

    var assignments = await _dataInterface.getRoleAssignmentsByReference(
      accountId: accountId,
      objectId: objectId,
    );

    for (var assignment in assignments) {
      if (assignment.permissionGroupId != null) {
        var group = await _dataInterface
            .getPermissionGroupById(assignment.permissionGroupId!);

        if (group != null) {
          permissionsIds.addAll(group.permissionIds);
        }
      }

      if (assignment.permissionId != null) {
        permissionsIds.add(assignment.permissionId!);
      }
    }

    var accountGroups =
        await _dataInterface.getAccountGroupsByAccountIds([accountId]);

    for (var ag in accountGroups) {
      var assignments = await _dataInterface.getRoleAssignmentsByReference(
        objectId: objectId,
        accountGroupId: ag.id,
      );

      for (var assignment in assignments) {
        if (assignment.permissionGroupId != null) {
          var group = await _dataInterface
              .getPermissionGroupById(assignment.permissionGroupId!);

          if (group != null) {
            permissionsIds.addAll(group.permissionIds);
          }
        }

        if (assignment.permissionId != null) {
          permissionsIds.add(assignment.permissionId!);
        }
      }
    }

    var permissions =
        (await _getPermissionsByIdList(permissionsIds.toList())).toSet();

    return permissions;
  }

  Future<List<PermissionGroupModel>> _getPermissionGroupsByIdList(
    List<String> permissionGroupIds,
  ) async {
    var groups = <PermissionGroupModel>[];

    for (var groupId in permissionGroupIds) {
      var group = await _dataInterface.getPermissionGroupById(groupId);

      if (group != null) {
        groups.add(group);
      }
    }

    return groups;
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
