// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class PermissionModel {
  const PermissionModel({
    required this.id,
    required this.name,
  });
  factory PermissionModel.fromMap(String id, Map<String, dynamic> map) =>
      PermissionModel(
        id: id,
        name: map['name'] ?? '',
      );

  final String id;
  final String name;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
      };

  PermissionModel copyWith({
    String? name,
  }) =>
      PermissionModel(
        id: id,
        name: name ?? this.name,
      );
}
