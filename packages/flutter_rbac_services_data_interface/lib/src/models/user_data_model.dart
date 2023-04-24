
class UserDataModel {
  final String? id;
  final List<dynamic> permissions;
  final List<dynamic> roles;
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
      permissions: List<dynamic>.from((map['permissions'] as List<dynamic>)),
      roles: List<dynamic>.from((map['roles'] as List<dynamic>)),
    );
  }
}
