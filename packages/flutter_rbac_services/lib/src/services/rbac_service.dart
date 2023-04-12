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

  Future<void> grantRole(String userId, String roleName) async {
    await _dataInterface.grantRole(userId, roleName);
  }

  Future<void> revokeRole(String userId, String roleName) async {
    await _dataInterface.revokeRole(userId, roleName);
  }

  Future<bool> hasRole(String userId, String requiredRole) async {
    var roles = await _dataInterface.getUserRoles(userId);

    return roles.contains(requiredRole);
  }

  Future<bool> hasPermission(String userId, Permission requiredPermission) async {
    // var permissions = await _dataInterface.getUserPermissions(userId);
    // var roles = await _dataInterface.getUserRoles(userId);

    // for(role in roles) {

    // }

    // var permissions = 


    // return <Permission>[].any((element) => element.allows(requiredPermission));    
  }
}
