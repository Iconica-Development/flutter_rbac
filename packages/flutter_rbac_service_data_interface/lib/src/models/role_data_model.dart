// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class RoleDataModel {
  const RoleDataModel({
    required this.id,
    required this.name,
    required this.permissionIds,
  });

  factory RoleDataModel.fromMap(String id, Map<String, dynamic> map) =>
      RoleDataModel(
        id: id,
        name: map['name'] ?? '',
        permissionIds: (map['permissions_ids'] as List<dynamic>?)
                ?.cast<String>()
                .toSet() ??
            {},
      );

  final String id;
  final String name;
  final Set<String> permissionIds;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
        'permissions_ids': permissionIds,
      };

  RoleDataModel copyWith({
    String? name,
    Set<String>? permissionIds,
  }) =>
      RoleDataModel(
        id: id,
        name: name ?? this.name,
        permissionIds: permissionIds ?? this.permissionIds,
      );
}
