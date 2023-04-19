
class RoleDataModel {
  final String? id;
  final String roleName;
  final List<String> permissions;
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
      permissions: List<String>.from((map['permissions'] as List<String>)),
    );
  }
}
