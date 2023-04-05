abstract class RbacDataInterface {
  RbacDataInterface._();

  Future<void> addUserPermission(String userId, String permission);
}
