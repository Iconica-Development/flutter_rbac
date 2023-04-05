// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_rbac_services/flutter_rbac_services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    expect(1 + 1, equals(2));
  });

  test('permissions allows', () {
    var givenPermission = Permission.root('car').any().child('delete');
    var car = Car(id: '10', name: 'mercedes');
    var requiredPermission = Permission.fromPermissable(car).child('delete');

    expect(givenPermission.allows(requiredPermission), isTrue);
  });
}

class Car implements Permissable {
  final String id;
  final String name;
  Car({
    required this.id,
    required this.name,
  });

  @override
  String get resourceId => id;

  @override
  String get resourceName => 'car';
}
