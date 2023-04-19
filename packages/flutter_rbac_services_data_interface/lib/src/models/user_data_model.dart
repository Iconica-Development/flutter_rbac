
class UserDataModel {
  final String? id;
  final List<String> permissions;
  final List<String> roles;
  UserDataModel({
    required this.id,
    required this.permissions,
    required this.roles,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'permissions': permissions,
      'roles': roles,
    };
  }

  factory UserDataModel.fromMap(String id,Map<String, dynamic> map) {
    return UserDataModel(
      id: id,
      permissions: List<String>.from((map['permissions'] as List<String>)),
      roles: List<String>.from((map['roles'] as List<String>)),
    );
  }
}
