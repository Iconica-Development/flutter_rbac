abstract class RbacDataInterface {
  RbacDataInterface._();

  Future<void> addUserPermission(String userId, String permission);
  Future<void> revokePermission(String userId, String permission);
  Future<void> grantRole(String userId, String roleName);
}
