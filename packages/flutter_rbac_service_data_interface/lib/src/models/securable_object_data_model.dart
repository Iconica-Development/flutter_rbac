// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class SecurableObjectDataModel {
  const SecurableObjectDataModel({
    required this.id,
    required this.name,
  });

  factory SecurableObjectDataModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) =>
      SecurableObjectDataModel(
        id: id,
        name: map['name'] ?? '',
      );

  final String id;
  final String name;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'name': name,
      };

  SecurableObjectDataModel copyWith({
    String? name,
  }) =>
      SecurableObjectDataModel(
        id: id,
        name: name ?? this.name,
      );
}
