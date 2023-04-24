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

  Future<void> grantRole(String userId, RoleDataModel role) async {
    await _dataInterface.grantRole(userId, role);
  }

  Future<void> revokeRole(String userId, RoleDataModel role) async {
    await _dataInterface.revokeRole(userId, role);
  }

  Future<Set<String>> getUserRolePermissions(String userId) async {
    return await _dataInterface.getUserRolePermissions(userId);
  }

  Future<bool> hasRole(String userId, String requiredRole) async {
    var roles = await _dataInterface.getUserRoles(userId);
    return roles.contains(requiredRole);
  }

  Future<bool> hasPermission(String userId, Permission requiredPermission) async {
    var permissionStrings = await _dataInterface.getUserPermissions(userId);

    //Convert Strings to permissions
    var permissions = permissionStrings
        .map((p) => PermissionConversion.fromRepresentation(p));

    var hasPerm = permissions.any((element) => element.allows(requiredPermission));
    return hasPerm;
  }
}
