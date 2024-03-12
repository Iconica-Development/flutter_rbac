// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class RoleAssignmentModel {
  const RoleAssignmentModel({
    required this.id,
    required this.objectId,
    required this.accountId,
    this.roleId,
    this.permissionId,
  });

  factory RoleAssignmentModel.fromMap(String id, Map<String, dynamic> map) =>
      RoleAssignmentModel(
        id: id,
        accountId: map['account_id'] ?? '',
        roleId: map['role_id'],
        objectId: map['object_id'] ?? '',
        permissionId: map['permission_id'],
      );

  final String id;
  final String objectId;
  final String accountId;
  final String? roleId;
  final String? permissionId;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'account_id': accountId,
        'role_id': roleId,
        'object_id': objectId,
        'permission_id': permissionId,
      };
}
