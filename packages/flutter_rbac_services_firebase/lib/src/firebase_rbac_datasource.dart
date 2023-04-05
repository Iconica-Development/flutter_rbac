import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_rbac_services_data_interface/flutter_rbac_services_data_interface.dart';

class FirebaseRbacDatasource implements RbacDataInterface {
  FirebaseRbacDatasource({
    required this.firebaseApp,
  });

  final FirebaseApp firebaseApp;

  @override
  Future<void> addUserPermission(String userId, String permission) async {
    var doc = FirebaseFirestore.instanceFor(app: firebaseApp)
        .collection('flutter_rbac_users')
        .doc(userId);
    var snapshot = await doc.get();
    if (snapshot.exists) {
      await doc.update({
        'permissions': FieldValue.arrayUnion([permission]),
      });
    } else {
      await doc.set({
        'permissions': [
          permission,
        ]
      });
    }
  }

  @override
  Future<void> revokePermission(String userId, String permission) async {
    var doc = FirebaseFirestore.instanceFor(app: firebaseApp)
        .collection('flutter_rbac_users')
        .doc(userId);
    var snapshot = await doc.get();
    if (snapshot.exists) {
      await doc.update({
        'permissions': FieldValue.arrayRemove([permission]),
      });
    } else {
      print('This permissions does not exsist');
    }
  }
}
