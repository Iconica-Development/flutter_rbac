class SecurableObjectDataModel {
  final String id;
  final String securableObjectName;
  SecurableObjectDataModel({
    required this.id,
    required this.securableObjectName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'securableObjectName': securableObjectName,
    };
  }

  factory SecurableObjectDataModel.fromMap(
      String id, Map<String, dynamic> map) {
    return SecurableObjectDataModel(
      id: id,
      securableObjectName: map['securableObjectName'] as String,
    );
  }
}
