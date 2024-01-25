class AccountDataModel {
  final String id;
  final String accountName;
  final String password;
  AccountDataModel({
    required this.id,
    required this.accountName,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountName': accountName,
      'password': password,
    };
  }

  factory AccountDataModel.fromMap(String id, Map<String, dynamic> map) {
    return AccountDataModel(
      id: id,
      accountName: map['accountName'] as String,
      password: map['accountName'] as String,
    );
  }
}
