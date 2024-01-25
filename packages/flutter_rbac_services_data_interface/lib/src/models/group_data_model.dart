class GroupDataModel {
  final String id;
  final String groupName;
  final List<dynamic> users;
  GroupDataModel({
    required this.id,
    required this.groupName,
    required this.users,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupName': groupName,
      'users': users,
    };
  }

  factory GroupDataModel.fromMap(String id, Map<String, dynamic> map) {
    return GroupDataModel(
      id: id,
      groupName: map['groupName'] as String,
      users: List<dynamic>.from((map['users'] as List<dynamic>)),
    );
  }
}
