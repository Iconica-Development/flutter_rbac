
class RoleDataModel {
  final String? id;
  final String roleName;
  final List<dynamic> permissions;
  RoleDataModel({
    required this.id,
    required this.roleName,
    required this.permissions,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roleName': roleName,
      'permissions': permissions,
    };
  }

  factory RoleDataModel.fromMap(String id, Map<String, dynamic> map) {
    return RoleDataModel(
      id: id,
      roleName: map['roleName'] as String,
      permissions: List<dynamic>.from((map['permissions'] as List<dynamic>)),
    );
  }
}
