# Flutter RBAC

Flutter RBAC is a package that enables to add a RBAC system to an existing project. Currently only a Firebase Firestore datasource is provided, but a custom datasource can be constructed by implementing the `RbacDataInterface` and providing this to the `RbacService`.

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
  dataInterface: FirebaseRbacDatasource(
    firebaseApp: Firebase.app(),
  ),
)
```

From here the following methods can be called from this service to set up and use RBAC:

### Securable Objects
- createSecurableObject(String name): Creates a new securable object with the specified name.
- getSecurableObjectById(String objectId): Retrieves a securable object by its ID.
- getSecurableObjectByName(String name): Retrieves a securable object by its name.
- getAllSecurableObjects(): Retrieves all securable objects.
- updateSecurableObject(String objectId, String newName): Updates the name of a securable object.
- deleteSecurableObject(String objectId): Deletes a securable object and associated role assignments.

### Accounts
- createAccount(String id, String email): Creates a new account with the specified ID and email.
- getAccountById(String accountId): Retrieves an account by its ID.
- getAccountByEmail(String accountEmail): Retrieves an account by its email.
- getAllAccounts(): Retrieves all accounts.
- updateAccount(String accountId, String newEmail): Updates the email of an account.
- deleteAccount(String accountId): Deletes an account and associated data.

### Account Groups
- createAccountGroup(String id, String name, Set<String> accountIds): Creates an account group.
- getAccountGroupById(String accountGroupId): Retrieves an account group by its ID.
- getAccountGroupByName(String accountGroupName): Retrieves an account group by its name.
- getAllAccountGroups(): Retrieves all account groups.
- updateAccountGroup(String accountGroupId, {String? newName, Set<String>? accountIds}): Updates an existing account group.
- deleteAccountGroup(String accountGroupId): Deletes an account group.
- addAccountsToAccountGroup(String accountgroupId, List<String> accountIds): Adds accounts to an account group.
- removeAccountsFromAccountsGroup(String accountGroupId, List<String> accountIds): Removes accounts from an account group.

### Permissions
- createPermission(String name): Creates a new permission with the specified name.
- getPermissionById(String permissionId): Retrieves a permission by its ID.
- getPermissionByName(String permissionName): Retrieves a permission by its name.
- getAllPermissions(): Retrieves all permissions.
- updatePermission(String permissionId, String newName): Updates the name of a permission.
- deletePermission(String permissionId): Deletes a permission and associated role assignments.

### Permission Groups
- createPermissionGroup(String name, Set<String> permissionIds): Creates a new permission group.
- getPermissionGroupById(String permissionGroupId): Retrieves a permission group by ID.
- getPermissionGroupByName(String permissionGroupName): Retrieves a permission group by name.
- getAllPermissionGroups(): Retrieves all permission groups.
- updatePermissionGroup(String permissionGroupId, {String? newName, Set<String>? newPermissionIds}): Updates a permission group.
- deletePermissionGroup(String permissionGroupId): Deletes a permission group and all its related assignments.

### Role Assignments
- createRoleAssignment({String objectId, String? accountId, String? accountGroupId, String? permissionId, String? permissionGroupId}): Creates a role assignment.
- getRoleAssignmentById(String assignmentId): Retrieves a role assignment by its ID.
- getRoleAssignmentsByReference({String? objectId, String? accountId, String? accountGroupId, String? permissionId, String? permissionGroupId}): Retrieves role assignments by reference.
- getAllRoleAssignments(): Retrieves all role assignments.
- deleteRoleAssignment(String assignmentId): Deletes a role assignment specified by its ID.
- grantPermissionsToAccount(String accountId, String objectId, List<String> permissionIds): Grants permissions to an account.
- revokePermissionsFromAccount(String accountId, String objectId, List<String> permissionIds): Revokes permissions from an account.
- grantPermissionsToAccountGroup(String accountGroupId, String objectId, List<String> permissionIds): Grants permissions to an account group.
- revokePermissionFromAccountGroup(String accountGroupId, String objectId, List<String> permissionIds): Revokes permissions from an account group.
- grantPermissionGroupToAccount(String accountId, String permissionGroupId, {List<String>? objectIds}): Grants a permission group to an account.
- revokePerissionGroupFromAccount(String accountId, String permissionGroupId, {List<String>? objectIds}): Revokes a permission group from an account.
- grantPermissionGroupToAccountGroup(String accountGroupId, String permissionGroupId, {List<String>? objectIds}): Grants a permission group to an account group.
- revokePerissionGroupFromAccountGroup(String accountGroupId, String permissionGroupId, {List<String>? objectIds}): Revokes a permission group from an account group.

### Other Methods
- getPermissionGroupsOfAccount(String accountId, String objectId): Retrieves the permission groups associated with an account for a specific object.
- getPermissionsOfAccount(String accountId, String objectId): Retrieves the permissions associated with an account for a specific object. 

## View 
There are multiple ways to use the RBAC management view. All are shown below:

### RbacManagement widget
Route to the `RbacScreen` widget to show the first screen of the view. All futher routing is managed internally:

```
RbacManagement(
  rbacService: RbacService(
    dataInterface: PreferredDataInterface,
  ),
  onQuit: () {},
)
```

### Go Router 
Add go_router as dependency to your project.
Add the following configuration to your flutter_application:

```
List<GoRoute> getRbacViewRoutes() => getRbacViewRoutes(
      closeRoute: '',
      rbacService: RbacService(
        dataInterface: PreferedDataInterface,
      ),
    );
```

Add the `getRbacViewRoutes()` to your go_router routes like so:

```
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage(
          title: "home",
        );
      },
    ),
    ...getRbacViewRoutes()
  ],
);
```

### Screens and Corresponding onTap Routes
#### AccountOverviewScreen
- **onTapPermissions**: Navigate to PermissionOverviewScreen
- **onTapObjects**: Navigate to ObjectOverviewScreen
- **onTapCreateLink**: Navigate to CreateLinkScreen
- **onTapAccount**: Navigate to AccountDetailScreen with specific account ID
- **onTapAccountGroup**: Navigate to AccountGroupScreen with specific group ID

#### AccountDetailScreen
- **onTapPermissions**: Navigate to PermissionOverviewScreen
- **onTapObjects**: Navigate to ObjectOverviewScreen
- **onTapCreateLink**: Navigate to CreateLinkScreen
- **onBack**: Navigate back

#### AccountGroupScreen
- **onTapPermissions**: Navigate to PermissionOverviewScreen
- **onTapObjects**: Navigate to ObjectOverviewScreen
- **onTapCreateLink**: Navigate to CreateLinkScreen
- **onBack**: Navigate back

#### PermissionOverviewScreen
- **onTapAccounts**: Navigate to AccountOverviewScreen
- **onTapObjects**: Navigate to ObjectOverviewScreen
- **onTapCreateLink**: Navigate to CreateLinkScreen

#### ObjectOverviewScreen
- **onTapAccounts**: Navigate to AccountOverviewScreen
- **onTapPermissions**: Navigate to PermissionOverviewScreen
- **onTapCreateLink**: Navigate to CreateLinkScreen
- **onTapObject**: Navigate to ObjectDetailScreen with specific object ID

#### ObjectDetailScreen
- **onTapAccounts**: Navigate to AccountOverviewScreen
- **onTapPermissions**: Navigate to PermissionOverviewScreen
- **onTapCreateLink**: Navigate to CreateLinkScreen
- **onBack**: Navigate back

#### CreateLinkScreen
- **onTapAccounts**: Navigate to AccountOverviewScreen
- **onTapPermissions**: Navigate to PermissionOverviewScreen
- **onTapObjects**: Navigate to ObjectOverviewScreen
- **onBack**: Navigate back

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_rbac_service/pulls) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_rbac_service/pulls).

## Author

This `flutter_rbac_service` for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>