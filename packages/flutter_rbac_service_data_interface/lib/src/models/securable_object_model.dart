// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class SecurableObjectModel {
  const SecurableObjectModel({
    required this.id,
    required this.name,
  });

  factory SecurableObjectModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) =>
      SecurableObjectModel(
        id: id,
        name: map["name"] ?? "",
      );

  final String id;
  final String name;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "name": name,
      };

  SecurableObjectModel copyWith({
    String? name,
  }) =>
      SecurableObjectModel(
        id: id,
        name: name ?? this.name,
      );
}
