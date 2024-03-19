// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class AccountModel {
  const AccountModel({
    required this.id,
    this.email,
  });

  factory AccountModel.fromMap(String id, Map<String, dynamic> map) =>
      AccountModel(
        id: id,
        email: map['email'],
      );

  final String id;
  final String? email;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'email': email,
      };

  AccountModel copyWith({
    String? email,
  }) =>
      AccountModel(
        id: id,
        email: email ?? this.email,
      );
}
