// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class RoleAssignmentModel {
  const RoleAssignmentModel({
    required this.id,
    required this.objectId,
    this.accountId,
    this.accountGroupId,
    this.permissionId,
    this.permissionGroupId,
  });

  factory RoleAssignmentModel.fromMap(String id, Map<String, dynamic> map) =>
      RoleAssignmentModel(
        id: id,
        objectId: map['object_id'] ?? '',
        accountId: map['account_id'],
        accountGroupId: map['account_group_id'],
        permissionId: map['permission_id'],
        permissionGroupId: map['permission_group_id'],
      );

  final String id;
  final String objectId;
  final String? accountId;
  final String? accountGroupId;
  final String? permissionId;
  final String? permissionGroupId;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'object_id': objectId,
        'account_group_id': accountGroupId,
        'account_id': accountId,
        'permission_id': permissionId,
        'permission_group_id': permissionGroupId,
      };
}
