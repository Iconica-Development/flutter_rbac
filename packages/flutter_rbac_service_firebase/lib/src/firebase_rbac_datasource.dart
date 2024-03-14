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
    this.roleCollectionName = 'rbac_roles',
    this.accountCollectionName = 'rbac_accounts',
    this.permissionCollectionName = 'rbac_permissions',
    this.roleAssignmentObjectCollectionName = 'rbac_role_assignments',
  });

  final FirebaseApp firebaseApp;
  final String securableObjectCollectionName;
  final String roleCollectionName;
  final String accountCollectionName;
  final String permissionCollectionName;
  final String roleAssignmentObjectCollectionName;

  ///////////////////////// CRUD Securable Objects /////////////////////////////
  late final _objectCollection = FirebaseFirestore.instanceFor(app: firebaseApp)
      .collection(securableObjectCollectionName)
      .withConverter(
        fromFirestore: (snapshot, options) =>
            SecurableObjectDataModel.fromMap(snapshot.id, snapshot.data()!),
        toFirestore: (object, options) => object.toMap(),
      );

  @override
  Future<void> setSecurableObject(
    SecurableObjectDataModel object,
  ) async =>
      _objectCollection.doc(object.id).set(object);

  @override
  Future<SecurableObjectDataModel?> getSecurableObjectById(
    String objectId,
  ) async {
    var snapshot = await _objectCollection.doc(objectId).get();

    return snapshot.data();
  }

  @override
  Future<SecurableObjectDataModel?> getSecurableObjectByName(
    String objectName,
  ) async {
    var snapshot =
        await _objectCollection.where('name', isEqualTo: objectName).get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<SecurableObjectDataModel>> getAllSecurableObjects() async {
    var snapshot = await _objectCollection.get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> deleteSecurableObject(String objectId) async =>
      _objectCollection.doc(objectId).delete();

  /////////////////////////////// CRUD Roles ///////////////////////////////////
  late final _roleCollection = FirebaseFirestore.instanceFor(app: firebaseApp)
      .collection(roleCollectionName)
      .withConverter(
        fromFirestore: (snapshot, options) =>
            RoleDataModel.fromMap(snapshot.id, snapshot.data()!),
        toFirestore: (object, options) => object.toMap(),
      );

  @override
  Future<void> setRole(
    RoleDataModel role,
  ) async =>
      _roleCollection.doc(role.id).set(role);

  @override
  Future<RoleDataModel?> getRoleById(String roleId) async {
    var snapshot = await _roleCollection.doc(roleId).get();

    return snapshot.data();
  }

  @override
  Future<RoleDataModel?> getRoleByName(String roleName) async {
    var snapshot =
        await _roleCollection.where('name', isEqualTo: roleName).get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<RoleDataModel>> getRolesByPermissionIds(
    List<String> permissionIds,
  ) async {
    var snapshot = await _roleCollection
        .where('permissions_ids', arrayContainsAny: permissionIds)
        .get();

    return snapshot.docs.map((s) => s.data()).toList();
  }

  @override
  Future<List<RoleDataModel>> getAllRoles() async {
    var snapshot = await _roleCollection.get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> deleteRole(String roleId) async =>
      _roleCollection.doc(roleId).delete();

  ///////////////////////////// CRUD Accounts //////////////////////////////////
  late final _accountCollection =
      FirebaseFirestore.instanceFor(app: firebaseApp)
          .collection(accountCollectionName)
          .withConverter(
            fromFirestore: (snapshot, options) =>
                AccountDataModel.fromMap(snapshot.id, snapshot.data()!),
            toFirestore: (object, options) => object.toMap(),
          );

  @override
  Future<void> setAccount(AccountDataModel account) async =>
      _accountCollection.doc(account.id).set(account);

  @override
  Future<AccountDataModel?> getAccountById(String accountId) async {
    var snapshot = await _accountCollection.doc(accountId).get();

    return snapshot.data();
  }

  @override
  Future<AccountDataModel?> getAccountByEmail(String accountEmail) async {
    var snapshot =
        await _accountCollection.where('email', isEqualTo: accountEmail).get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<AccountDataModel>> getAllAccounts() async {
    var snapshot = await _accountCollection.get();

    return snapshot.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> deleteAccount(String accountId) async =>
      _accountCollection.doc(accountId).delete();

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
    String? roleId,
    String? permissionId,
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

    if (roleId != null) {
      if (target == null) {
        target = _assignmentCollection.where('role_id', isEqualTo: roleId);
      } else {
        target = target.where('role_id', isEqualTo: roleId);
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
