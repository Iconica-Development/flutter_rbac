// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class PermissionGroupModel {
  const PermissionGroupModel({
    required this.id,
    required this.permissionIds,
    this.name,
  });

  factory PermissionGroupModel.fromMap(String id, Map<String, dynamic> map) =>
      PermissionGroupModel(
        id: id,
        name: map["name"],
        permissionIds:
            (map["permission_ids"] as List<dynamic>?)?.cast<String>().toSet() ??
                {},
      );

  final String id;
  final String? name;
  final Set<String> permissionIds;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "name": name,
        "permission_ids": permissionIds,
      };

  PermissionGroupModel copyWith({
    String? name,
    Set<String>? permissionIds,
  }) =>
      PermissionGroupModel(
        id: id,
        name: name ?? this.name,
        permissionIds: permissionIds ?? this.permissionIds,
      );
}
