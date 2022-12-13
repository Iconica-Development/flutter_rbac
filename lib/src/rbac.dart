// SPDX-FileCopyrightText: 2022 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Rbac {
  Rbac({
    required this.firebaseApp,
    required this.database,
  });

  final FirebaseApp firebaseApp;
  final FirebaseDatabase database;

  List<String> _groupRoles = [];
  List<String> get groupRoles => _groupRoles;

  void setGroupRoles(List<String> roles) => _groupRoles = roles;

  Future<void> addRole(String role, String userId, String? group) async {
    DatabaseReference ref = database.ref().child('groups');

    final res = (await ref
            .child(group ?? "_AppShell")
            .child('users')
            .child(userId)
            .once())
        .snapshot;

    List newRoles = [];
    var value = res.value;
    if (value is List) {
      newRoles.addAll(value);
    }

    if (!newRoles.contains(role)) {
      newRoles.add(role);
    }

    ref.child(group ?? "_AppShell").child('users').child(userId).set(newRoles);
  }

  Future<String> createGroup(Map<String, dynamic> groupData) async {
    DatabaseReference ref = database.ref().child('groups').push();

    if (groupData.isEmpty) {
      groupData['id'] = ref.key;
    }
    ref.set(groupData);

    User? user = FirebaseAuth.instanceFor(app: firebaseApp).currentUser;

    if (user != null) {
      ref.child('users').child(user.uid).set(["ADMIN"]);
    }

    return ref.key ?? '';
  }

  Future<List<String>> getGroups(String? userId) async {
    DatabaseReference ref = database.ref().child('groups');

    List<String> groups = [];

    var res = await ref.get();
    var result = res.value;

    if (result is Map) {
      result.forEach((groupId, groupVal) {
        if (groupVal['users'] is Map) {
          Map users = groupVal['users'];
          if (userId == null) {
            groups.add(groupId);
          } else if (users.containsKey(userId)) {
            groups.add(groupId);
          }
        }
      });
    }

    return groups;
  }

  Future<List<String>> getRoles(String? userId, String? groupId) async {
    var ref = database.ref().child('groups');
    groupId ??= '_AppShell';
    List<String> roles = [];

    if (userId == null) {
      var snapshot = await ref.child(groupId).get();

      var value = snapshot.value;

      if (value is Map && value['users'] is Map) {
        value['users'].forEach((userId, roles) {
          for (String role in roles) {
            if (!roles.contains(role)) {
              roles.add(role);
            }
          }
        });
      }
    } else {
      var snapshot =
          await ref.child(groupId).child('users').child(userId).get();

      var items = snapshot.value;

      if (items is List) {
        for (var item in items) {
          if (item is String) {
            roles.add(item);
          }
        }
      }
    }

    setGroupRoles(roles);
    return roles;
  }

  Future<void> removeRole(String? role, String userId, String? group) async {
    DatabaseReference ref = database.ref().child('groups');

    if (role != null) {
      final res = (await ref
              .child(group ?? "_AppShell")
              .child('users')
              .child(userId)
              .once())
          .snapshot;
      var value = res.value;
      List newRoles;
      if (value is List) {
        newRoles = value;
      } else {
        newRoles = [];
      }

      newRoles.remove(role);

      ref
          .child(group ?? "_AppShell")
          .child('users')
          .child(userId)
          .set(newRoles);
    } else {
      ref.child(group ?? "_AppShell").child('users').child(userId).remove();
    }
  }

  Future<List<String>> getAllRoles(String? userId) async {
    DatabaseReference ref = database.ref().child('groups');

    List<String> allRoles = [];
    var res = await ref.get();
    var value = res.value;
    if (value is Map) {
      value.forEach((groupId, groupVal) {
        if (groupVal['users'] is Map) {
          Map users = groupVal['users'];
          users.forEach((id, roles) {
            if (roles is List) {
              for (var role in roles) {
                if (!allRoles.contains(role)) {
                  if (userId == null) {
                    allRoles.add(role);
                  } else {
                    if (id == userId) {
                      allRoles.add(role);
                    }
                  }
                }
              }
            }
          });
        }
      });
    }
    return allRoles;
  }
}
