abstract class RbacDataInterface {
  RbacDataInterface._();

  Future<void> addUserPermission(String userId, String permission);
  Future<void> revokePermission(String userId, String permission);
  Future<void> grantRole(String userId, String roleName);
  Future<void> revokeRole(String userId, String roleName);
  Future<List> getUserRoles(String userId);
  Future<void> getUserPermissions(String userId);
}
