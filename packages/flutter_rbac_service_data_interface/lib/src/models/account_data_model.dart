// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class AccountDataModel {
  const AccountDataModel({
    required this.id,
    this.email,
  });

  factory AccountDataModel.fromMap(String id, Map<String, dynamic> map) =>
      AccountDataModel(
        id: id,
        email: map['email'],
      );

  final String id;
  final String? email;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'email': email,
      };

  AccountDataModel copyWith({
    String? email,
  }) =>
      AccountDataModel(
        id: id,
        email: email ?? this.email,
      );
}
