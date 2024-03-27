// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';

class FirebaseRbacDatasource implements RbacDataInterface {
  FirebaseRbacDatasource({
    required this.firebaseApp,
    this.securableObjectCollectionName = 'rbac_securable_objects',
    this.accountCollectionName = 'rbac_accounts',
    this.accountGroupCollectionName = 'rbac_account_groups',
    this.permissionCollectionName = 'rbac_permissions',
    this.permissionGroupCollectionName = 'rbac_permission_groups',
    this.roleAssignmentObjectCollectionName = 'rbac_role_assignments',
  });

  final FirebaseApp firebaseApp;
  final String securableObjectCollectionName;
  final String accountCollectionName;
  final String accountGroupCollectionName;
  final String permissionCollectionName;
  final String permissionGroupCollectionName;
  final String roleAssignmentObjectCollectionName;

  ///////////////////////// CRUD Securable Objects /////////////////////////////
  late final _objectCollection = FirebaseFirestore.instanceFor(app: firebaseApp)
      .collection(securableObjectCollectionName)
      .withConverter(
        fromFirestore: (snapshot, options) =>
            SecurableObjectModel.fromMap(snapshot.id, snapshot.data()!),
        toFirestore: (object, options) => object.toMap(),
      );

  @override
  Future<void> setSecurableObject(
    SecurableObjectModel object,
  ) async =>
      _objectCollection.doc(object.id).set(object);

  @override
  Future<SecurableObjectModel?> getSecurableObjectById(
    String objectId,
  ) async {
    var snapshot = await _objectCollection.doc(objectId).get();

    return snapshot.data();
  }

  @override
  Future<SecurableObjectModel?> getSecurableObjectByName(
    String objectName,
  ) async {
    var snapshot =
        await _objectCollection.where('name', isEqualTo: objectName).get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<SecurableObjectModel>> getAllSecurableObjects() async {
    var snapshot = await _objectCollection.get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> deleteSecurableObject(String objectId) async =>
      _objectCollection.doc(objectId).delete();

  ///////////////////////////// CRUD Accounts //////////////////////////////////
  late final _accountCollection =
      FirebaseFirestore.instanceFor(app: firebaseApp)
          .collection(accountCollectionName)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                AccountModel.fromMap(snapshot.id, snapshot.data()!),
            toFirestore: (object, options) => object.toMap(),
          );

  @override
  Future<void> setAccount(AccountModel account) async =>
      _accountCollection.doc(account.id).set(account);

  @override
  Future<AccountModel?> getAccountById(String accountId) async {
    var snapshot = await _accountCollection.doc(accountId).get();

    return snapshot.data();
  }

  @override
  Future<AccountModel?> getAccountByEmail(String accountEmail) async {
    var snapshot =
        await _accountCollection.where('email', isEqualTo: accountEmail).get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<AccountModel>> getAllAccounts() async {
    var snapshot = await _accountCollection.get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> deleteAccount(String accountId) async =>
      _accountCollection.doc(accountId).delete();

  ////////////////////////// CRUD Account Groups ///////////////////////////////
  late final _accountGroupCollection =
      FirebaseFirestore.instanceFor(app: firebaseApp)
          .collection(accountGroupCollectionName)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                AccountGroupModel.fromMap(snapshot.id, snapshot.data()!),
            toFirestore: (object, options) => object.toMap(),
          );

  @override
  Future<void> setAccountGroup(AccountGroupModel accountGroup) async =>
      _accountGroupCollection.doc(accountGroup.id).set(accountGroup);

  @override
  Future<AccountGroupModel?> getAccountGroupById(String accountGroupId) async {
    var snapshot = await _accountGroupCollection.doc(accountGroupId).get();

    return snapshot.data();
  }

  @override
  Future<AccountGroupModel?> getAccountGroupByName(
    String accountGroupName,
  ) async {
    var snapshot = await _accountGroupCollection
        .where('name', isEqualTo: accountGroupName)
        .get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<AccountGroupModel>> getAccountGroupsByAccountIds(
    List<String> accountIds,
  ) async {
    var snapshot = await _accountGroupCollection
        .where('account_ids', arrayContainsAny: accountIds)
        .get();

    return snapshot.docs.map((s) => s.data()).toList();
  }

  @override
  Future<List<AccountGroupModel>> getAllAccountGroups() async {
    var snapshot = await _accountGroupCollection.get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> deleteAccountGroup(String accountGroupId) async =>
      _accountGroupCollection.doc(accountGroupId).delete();

  /////////////////////////// CRUD Permissions /////////////////////////////////
  late final _permissionCollection =
      FirebaseFirestore.instanceFor(app: firebaseApp)
          .collection(permissionCollectionName)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                PermissionModel.fromMap(snapshot.id, snapshot.data()!),
            toFirestore: (object, options) => object.toMap(),
          );

  @override
  Future<void> setPermission(PermissionModel permission) async =>
      _permissionCollection.doc(permission.id).set(permission);

  @override
  Future<PermissionModel?> getPermissionById(String permissionId) async {
    var snapshot = await _permissionCollection.doc(permissionId).get();

    return snapshot.data();
  }

  @override
  Future<PermissionModel?> getPermissionByName(String permissionName) async {
    var snapshot = await _permissionCollection
        .where('name', isEqualTo: permissionName)
        .get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<PermissionModel>> getAllPermissions() async {
    var snapshot = await _permissionCollection.get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> deletePermission(String permissionId) async =>
      _permissionCollection.doc(permissionId).delete();

  ///////////////////////// CRUD Permission Groups  ////////////////////////////
  late final _permissionGroupCollection =
      FirebaseFirestore.instanceFor(app: firebaseApp)
          .collection(permissionGroupCollectionName)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                PermissionGroupModel.fromMap(snapshot.id, snapshot.data()!),
            toFirestore: (object, options) => object.toMap(),
          );

  @override
  Future<void> setPermissionGroup(
    PermissionGroupModel permissionGroup,
  ) async =>
      _permissionGroupCollection.doc(permissionGroup.id).set(permissionGroup);

  @override
  Future<PermissionGroupModel?> getPermissionGroupById(
    String permissionGroupId,
  ) async {
    var snapshot =
        await _permissionGroupCollection.doc(permissionGroupId).get();

    return snapshot.data();
  }

  @override
  Future<PermissionGroupModel?> getPermissionGroupByName(
    String permissionGroupName,
  ) async {
    var snapshot = await _permissionGroupCollection
        .where('name', isEqualTo: permissionGroupName)
        .get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<PermissionGroupModel>> getPermissionGroupsByPermissionIds(
    List<String> permissionIds,
  ) async {
    var snapshot = await _permissionGroupCollection
        .where('permission_ids', arrayContainsAny: permissionIds)
        .get();

    return snapshot.docs.map((s) => s.data()).toList();
  }

  @override
  Future<List<PermissionGroupModel>> getAllPermissionGroups() async {
    var snapshot = await _permissionGroupCollection.get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> deletePermissionGroup(String permissionGroupId) async =>
      _permissionGroupCollection.doc(permissionGroupId).delete();

  /////////////////////////// CRUD Assignments /////////////////////////////////
  late final _assignmentCollection =
      FirebaseFirestore.instanceFor(app: firebaseApp)
          .collection(roleAssignmentObjectCollectionName)
          .withConverter(
            fromFirestore: (snapshot, options) => RoleAssignmentModel.fromMap(
              snapshot.id,
              snapshot.data()!,
            ),
            toFirestore: (object, options) => object.toMap(),
          );

  @override
  Future<void> setRoleAssignment(
    RoleAssignmentModel assignment,
  ) async =>
      _assignmentCollection.doc(assignment.id).set(assignment);

  @override
  Future<RoleAssignmentModel?> getRoleAssignmentById(
    String assignmentId,
  ) async {
    var snapshot = await _assignmentCollection.doc(assignmentId).get();

    return snapshot.data();
  }

  @override
  Future<List<RoleAssignmentModel>> getRoleAssignmentsByReference({
    String? objectId,
    String? accountId,
    String? accountGroupId,
    String? permissionId,
    String? permissionGroupId,
  }) async {
    Query<RoleAssignmentModel>? target;

    if (objectId != null) {
      target = _assignmentCollection.where('object_id', isEqualTo: objectId);
    }

    if (accountId != null) {
      if (target == null) {
        target =
            _assignmentCollection.where('account_id', isEqualTo: accountId);
      } else {
        target = target.where('account_id', isEqualTo: accountId);
      }
    }

    if (accountGroupId != null) {
      if (target == null) {
        target = _assignmentCollection.where(
          'account_group_id',
          isEqualTo: accountGroupId,
        );
      } else {
        target = target.where('account_group_id', isEqualTo: accountGroupId);
      }
    }

    if (permissionId != null) {
      if (target == null) {
        target = _assignmentCollection.where(
          'permission_id',
          isEqualTo: permissionId,
        );
      } else {
        target = target.where('permission_id', isEqualTo: permissionId);
      }
    }

    if (permissionGroupId != null) {
      if (target == null) {
        target = _assignmentCollection.where(
          'permission_group_id',
          isEqualTo: permissionGroupId,
        );
      } else {
        target =
            target.where('permission_group_id', isEqualTo: permissionGroupId);
      }
    }

    if (target != null) {
      var snapshot = await target.get();

      return snapshot.docs.map((d) => d.data()).toList();
    }

    var snapshot = await _assignmentCollection.get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> deleteRoleAssignment(String assignmentId) async =>
      _assignmentCollection.doc(assignmentId).delete();
}
