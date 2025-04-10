// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

class AccountGroupModel {
  const AccountGroupModel({
    required this.id,
    required this.name,
    required this.accountIds,
  });

  factory AccountGroupModel.fromMap(String id, Map<String, dynamic> map) =>
      AccountGroupModel(
        id: id,
        name: map["name"],
        accountIds:
            (map["account_ids"] as List<dynamic>?)?.cast<String>().toSet() ??
                {},
      );

  final String id;
  final String name;
  final Set<String> accountIds;

  Map<String, dynamic> toMap() => <String, dynamic>{
        "name": name,
        "account_ids": accountIds,
      };

  AccountGroupModel copyWith({
    String? name,
    Set<String>? accountIds,
  }) =>
      AccountGroupModel(
        id: id,
        name: name ?? this.name,
        accountIds: accountIds ?? this.accountIds,
      );
}
