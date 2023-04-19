import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rbac_services_data_interface/flutter_rbac_services_data_interface.dart';

class FirebaseRbacDatasource implements RbacDataInterface {
  FirebaseRbacDatasource({
    required this.firebaseApp,
  });

  final FirebaseApp firebaseApp;

  late final _roleCollection = FirebaseFirestore.instanceFor(app: firebaseApp)
      .collection('flutter_rbac_roles')
      .withConverter(
    fromFirestore: (snapshot, options) {
      return RoleDataModel.fromMap(snapshot.id, snapshot.data()!);
    },
    toFirestore: (object, options) {
      return object.toMap();
    },
  );

  late final _userCollection = FirebaseFirestore.instanceFor(app: firebaseApp)
      .collection('flutter_rbac_users')
      .withConverter(
    fromFirestore: (snapshot, options) {
      return UserDataModel.fromMap(snapshot.id, snapshot.data()!);
    },
    toFirestore: (object, options) {
      return object.toMap();
    },
  );

  @override
  Future<void> addUserPermission(String userId, String permission) async {
    var userSnapshot = await _userCollection.doc(userId).get();
    if (userSnapshot.exists) {
      await _userCollection.doc(userId).update({
        'permissions': FieldValue.arrayUnion([permission]),
      });
    }
  }

  @override
  Future<void> revokePermission(String userId, String permission) async {
    var userSnapshot = await _userCollection.doc(userId).get();
    if (!userSnapshot.exists) {
      _userCollection.doc(userId).update({
        'permissions': FieldValue.arrayRemove([permission]),
      });
    }
  }

  @override
  Future<void> grantRole(String userId, RoleDataModel role) async {
    var roleSnapshot = await _roleCollection.doc(role.id).get();
    if (!roleSnapshot.exists) {
      _roleCollection.doc(role.id).set(role);
    }

    var userSnapshot = await _userCollection.doc(userId).get();
    if (!userSnapshot.exists) {
      _userCollection.doc(userId).update({
        'roles': FieldValue.arrayUnion([role.id]),
      });
    }
  }

  @override
  Future<void> revokeRole(String userId, RoleDataModel role) async {
    var userSnapshot = await _userCollection.doc(userId).get();
    if (!userSnapshot.exists) {
      _userCollection.doc(userId).update({
        'roles': FieldValue.arrayRemove([role.id]),
      });
    }
  }

  Future<List<RoleDataModel>> _getRolesByIdList(List<String> roleIds) async {
    var roles = await _roleCollection.get();
    return roles.docs
        .map((e) => e.data())
        .where((role) => roleIds.contains(role.id))
        .toList();
  }

  @override
  Future<Set<String>> getUserRoles(String userId) async {
    var userSnapshot = await _userCollection.doc(userId).get();
    var userDoc = userSnapshot.data()!;
    List<String> listOfRoles = userDoc.roles;
    return listOfRoles.toSet();
  }

  @override
  Future<List> getUserRolePermissions(String roleName) async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('flutter_rbac_roles')
        .doc(roleName)
        .get();
    List<dynamic> listOfUserRolePermissions =
        userSnapshot.data()!['permissions'];
    return listOfUserRolePermissions;
  }

  @override
  Future<Set<String>> getUserPermissions(String userId) async {
    Set<String> listOfPermissions = {};
    var snapshot = await _userCollection
        .doc(userId)
        .get();

    if (!snapshot.exists) {
      return {};
    }

    var user = snapshot.data()!;

    //Get permission linked to user
    listOfPermissions = user.permissions.toSet();

    //Get permissions linked to user roles
    //Merge permissions
    var roles = await _getRolesByIdList(user.roles);
    for (var role in roles) {
      listOfPermissions = {
        ...listOfPermissions,
        ...role.permissions,
      };
    }
    return listOfPermissions;
  }
}
