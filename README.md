# Flutter RBAC Service

Flutter RBAC Service is a package that enables to add a RBAC system to an existing project. Currently only a Firebase Firestore datasource is provided, but a custom datasource can be constructed by implementing the `RbacDataInterface` and providing this to the `RbacService`.

## Setup
To use this package, add flutter_rbac_service as a dependency in your pubspec.yaml file:

```
  flutter_rbac_service:
    git:
      url: https://github.com/Iconica-Development/flutter_rbac_service.git
      path: packages/flutter_rbac_service
```

If you are going to use Firebase as the datasource, you should also add the following package as a dependency to your pubspec.yaml file:

```
  flutter_rbac_services_firebase:
    git:
      url: https://github.com/Iconica-Development/flutter_rbac_service.git
      path: packages/flutter_rbac_services_firebase  
```

## How to use
To use this package initialize the `RBACService` with your prefered datasource. A local datasource is used as a standard. In the example below the provided `FirebaseRbacDatasource` is used. 

```
RbacService(
        FirebaseRbacDatasource(
          firebaseApp: Firebase.app(),
        ),
      ),
```

From here the following methods can be called from this service to set up and use RBAC:

### Securable Objects
- createSecurableObject(String name): Creates a new securable object with the specified name.
- getSecurableObjectById(String objectId): Retrieves a securable object by its ID.
- getSecurableObjectByName(String name): Retrieves a securable object by its name.
- getAllSecurableObjects(): Retrieves all securable objects.
- updateSecurableObject(String objectId, String newName): Updates the name of a securable object.
- deleteSecurableObject(String objectId): Deletes a securable object and associated role assignments.

### Roles
- createRole(String name, Set<String> permissionIds): Creates a new role with the specified name and permissions.
- getRoleById(String roleId): Retrieves a role by its ID.
- getRoleByName(String roleName): Retrieves a role by its name.
- getAllRoles(): Retrieves all roles.
- updateRole(String roleId, String newName): Updates the name of a role.
- deleteRole(String roleId): Deletes a role and associated role assignments.

### Accounts
- createAccount(String id, String email): Creates a new account with the specified ID and email.
- getAccountById(String accountId): Retrieves an account by its ID.
- getAccountByEmail(String accountEmail): Retrieves an account by its email.
- getAllAccounts(): Retrieves all accounts.
- updateAccount(String accountId, String newEmail): Updates the email of an account.
- deleteAccount(String accountId): Deletes an account and associated role assignments.

### Permissions
- createPermission(String name): Creates a new permission with the specified name.
- getPermissionById(String permissionId): Retrieves a permission by its ID.
- getPermissionByName(String permissionName): Retrieves a permission by its name.
- getAllPermissions(): Retrieves all permissions.
- updatePermission(String permissionId, String newName): Updates the name of a permission.
- deletePermission(String permissionId): Deletes a permission and associated role assignments.

### Role Assignments
- setRoleAssignment(RoleAssignmentModel assignment): Sets a role assignment.
- getRoleAssignmentById(String assignmentId): Retrieves a role assignment by its ID.
- getRoleAssignmentsByReference({String? objectId, String? accountId, String? roleId, String? permissionId}): Retrieves role assignments based on reference criteria.
- deleteRoleAssignment(String assignmentId): Deletes a role assignment.

### Other Methods
- addPermissionsToRole(String roleId, List<String> permissionIds): Adds permissions to a role.
- removePermissionsFromRole(String roleId, List<String> permissionIds): Removes permissions from a role.
- grantAccountPermissions(String accountId, String objectId, List<String> permissionIds): Grants - permissions to an account for a specific object.
- revokeAccountPermissions(String accountId, String objectId, List<String> permissionIds): Revokes permissions from an account for a specific object.
- grantRole(String accountId, String roleId, {List<String>? objectIds}): Grants a role to an account for multiple objects.
- revokeRole(String accountId, String roleId, {List<String>? objectIds}): Revokes a role from an account for multiple objects.
- getAccountRoles(String accountId, String objectId): Retrieves roles assigned to an account for a specific object.
- getAccountRolePermissions(String accountId, String objectId): Retrieves permissions granted to an account based on assigned roles for a specific object.
- getAccountDirectPermissions(String accountId, String objectId): Retrieves permissions directly granted to an account for a specific object.
- getObjectRoles(String objectId): Retrieves roles assigned to a securable object.
- getObjectRolePermissions(String objectId): Retrieves permissions granted to a securable object based on assigned roles.
- getObjectDirectPermissions(String objectId): Retrieves permissions directly granted to a securable object.
- getAccountRolesById(String accountId): Retrieves roles assigned to an account.
- getAccountRolePermissionsById(String accountId): Retrieves permissions granted to an account based on assigned roles.
- getAccountDirectPermissionsById(String accountId): Retrieves permissions directly granted to an account.
- These methods provide comprehensive functionality for managing RBAC within an application, enabling fine-grained control over access to resources based on roles and permissions.  

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_rbac_service/pulls) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_rbac_service/pulls).

## Author

This `flutter_rbac_service` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>