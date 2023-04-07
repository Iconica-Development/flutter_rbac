import 'package:flutter_rbac_services/src/models/permission.dart';
import 'package:flutter_rbac_services_data_interface/flutter_rbac_services_data_interface.dart';

class RbacService {
  final RbacDataInterface _dataInterface;

  RbacService(RbacDataInterface dataInterface) : _dataInterface = dataInterface;

  Future<void> addPermission(String userId, Permission permission) async {
    await _dataInterface.addUserPermission(userId, permission.representation);
  }

  Future<void> revokePermission(String userId, Permission permission) async {
    await _dataInterface.revokePermission(userId, permission.representation);
  }
  
  Future<void> getUserPermissions(String userId) async {
    await _dataInterface.getUserPermissions(userId);
  }

  Future<void> grantRole(String userId, String roleName) async {
    await _dataInterface.grantRole(userId, roleName);
  }

  Future<void> revokeRole(String userId, String roleName) async {
    await _dataInterface.revokeRole(userId, roleName);
  }

  Future<void> getUserRoles(String userId) async {
    await _dataInterface.getUserRoles(userId);
  }


}
