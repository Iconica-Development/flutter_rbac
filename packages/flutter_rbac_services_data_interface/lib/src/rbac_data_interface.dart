abstract class RbacDataInterface {
  RbacDataInterface._();

  Future<void> addUserPermission(String userId, String permission);
  Future<void> revokePermission(String userId, String permission);
  Future<void> getUserPermissions(String userId);
  Future<void> grantRole(String userId, String roleName);
  Future<void> revokeRole(String userId, String roleName);
  Future<void> getUserRoles(String userId);
}
