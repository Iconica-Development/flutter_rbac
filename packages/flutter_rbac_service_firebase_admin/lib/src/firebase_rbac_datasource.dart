// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:dart_firebase_admin/dart_firebase_admin.dart";
import "package:dart_firebase_admin/firestore.dart";
import "package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart";

bool _listEquals(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  var aSorted = List<String>.from(a)..sort();
  var bSorted = List<String>.from(b)..sort();
  for (var i = 0; i < a.length; i++) {
    if (aSorted[i] != bSorted[i]) return false;
  }
  return true;
}

bool _mapEquals(Map<String, List<String>> a, Map<String, List<String>> b) {
  if (a.length != b.length) return false;
  for (var key in a.keys) {
    if (!b.containsKey(key) || !_listEquals(a[key]!, b[key]!)) return false;
  }
  return true;
}

class FirebaseRbacDatasource implements RbacDataInterface {
  FirebaseRbacDatasource({
    required this.firebaseApp,
    this.securableObjectCollectionName = "rbac_securable_objects",
    this.accountCollectionName = "rbac_accounts",
    this.accountGroupCollectionName = "rbac_account_groups",
    this.permissionCollectionName = "rbac_permissions",
    this.permissionGroupCollectionName = "rbac_permission_groups",
    this.roleAssignmentObjectCollectionName = "rbac_role_assignments",
  });

  final FirebaseAdminApp firebaseApp;
  final String securableObjectCollectionName;
  final String accountCollectionName;
  final String accountGroupCollectionName;
  final String permissionCollectionName;
  final String permissionGroupCollectionName;
  final String roleAssignmentObjectCollectionName;

  ///////////////////////// CRUD Securable Objects /////////////////////////////
  late final _objectCollection = Firestore(firebaseApp)
      .collection(securableObjectCollectionName)
      .withConverter(
        fromFirestore: (snapshot) =>
            SecurableObjectModel.fromMap(snapshot.id, snapshot.data()),
        toFirestore: (object) => object.toMap(),
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
    var snapshot = await _objectCollection
        .where("name", WhereFilter.equal, objectName)
        .get();

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
      Firestore(firebaseApp).collection(accountCollectionName).withConverter(
            fromFirestore: (snapshot) =>
                AccountModel.fromMap(snapshot.id, snapshot.data()),
            toFirestore: (object) => object.toMap(),
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
    var snapshot = await _accountCollection
        .where("email", WhereFilter.equal, accountEmail)
        .get();

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
  late final _accountGroupCollection = Firestore(firebaseApp)
      .collection(accountGroupCollectionName)
      .withConverter(
        fromFirestore: (snapshot) =>
            AccountGroupModel.fromMap(snapshot.id, snapshot.data()),
        toFirestore: (object) => object.toMap(),
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
        .where("name", WhereFilter.equal, accountGroupName)
        .get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<AccountGroupModel>> getAccountGroupsByAccountIds(
    List<String> accountIds,
  ) async {
    var snapshot = await _accountGroupCollection
        .where("account_ids", WhereFilter.arrayContainsAny, accountIds)
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

  @override
  Stream<List<String>> getGroupChangesForAccount(String accountId) =>
      Stream.periodic(const Duration(seconds: 10)).asyncMap((_) async {
        var query = await _accountGroupCollection
            .where("account_ids", WhereFilter.arrayContains, accountId)
            .get();

        var groupNames = <String>[];
        for (var doc in query.docs) {
          var data = doc.data();
          groupNames.add(data.name);
        }

        return groupNames;
      }).distinct(_listEquals);

  @override
  Stream<Map<String, List<String>>> getGroupChanges() =>
      Stream.periodic(const Duration(seconds: 10)).asyncMap((_) async {
        var snapshot = await _accountGroupCollection.get();

        var userGroups = <String, List<String>>{};
        for (var doc in snapshot.docs) {
          var data = doc.data();
          var groupId = doc.id;
          var accountIds = List<String>.from(data.accountIds);

          for (var accountId in accountIds) {
            userGroups.putIfAbsent(accountId, () => []).add(groupId);
          }
        }

        return userGroups;
      }).distinct(_mapEquals);

  /////////////////////////// CRUD Permissions /////////////////////////////////
  late final _permissionCollection =
      Firestore(firebaseApp).collection(permissionCollectionName).withConverter(
            fromFirestore: (snapshot) => PermissionModel.fromMap(
              snapshot.id,
              snapshot.data(),
            ),
            toFirestore: (object) => object.toMap(),
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
        .where("name", WhereFilter.equal, permissionName)
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
  late final _permissionGroupCollection = Firestore(firebaseApp)
      .collection(permissionGroupCollectionName)
      .withConverter(
        fromFirestore: (snapshot) =>
            PermissionGroupModel.fromMap(snapshot.id, snapshot.data()),
        toFirestore: (object) => object.toMap(),
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
        .where("name", WhereFilter.equal, permissionGroupName)
        .get();

    return snapshot.docs.firstOrNull?.data();
  }

  @override
  Future<List<PermissionGroupModel>> getPermissionGroupsByPermissionIds(
    List<String> permissionIds,
  ) async {
    var snapshot = await _permissionGroupCollection
        .where("permission_ids", WhereFilter.arrayContainsAny, permissionIds)
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
  late final _assignmentCollection = Firestore(firebaseApp)
      .collection(roleAssignmentObjectCollectionName)
      .withConverter(
        fromFirestore: (snapshot) =>
            RoleAssignmentModel.fromMap(snapshot.id, snapshot.data()),
        toFirestore: (object) => object.toMap(),
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
      target =
          _assignmentCollection.where("object_id", WhereFilter.equal, objectId);
    }

    if (accountId != null) {
      if (target == null) {
        target = _assignmentCollection.where(
          "account_id",
          WhereFilter.equal,
          accountId,
        );
      } else {
        target = target.where("account_id", WhereFilter.equal, accountId);
      }
    }

    if (accountGroupId != null) {
      if (target == null) {
        target = _assignmentCollection.where(
          "account_group_id",
          WhereFilter.equal,
          accountGroupId,
        );
      } else {
        target =
            target.where("account_group_id", WhereFilter.equal, accountGroupId);
      }
    }

    if (permissionId != null) {
      if (target == null) {
        target = _assignmentCollection.where(
          "permission_id",
          WhereFilter.equal,
          permissionId,
        );
      } else {
        target = target.where("permission_id", WhereFilter.equal, permissionId);
      }
    }

    if (permissionGroupId != null) {
      if (target == null) {
        target = _assignmentCollection.where(
          "permission_group_id",
          WhereFilter.equal,
          permissionGroupId,
        );
      } else {
        target = target.where(
          "permission_group_id",
          WhereFilter.equal,
          permissionGroupId,
        );
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
