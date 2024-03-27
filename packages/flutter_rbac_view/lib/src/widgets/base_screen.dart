import 'package:flutter/material.dart';
import 'package:flutter_menu/flutter_menu.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    required this.child,
    this.onTapAccounts,
    this.onTapPermissions,
    this.onTapObjects,
    this.onTapCreateLink,
    this.onQuit,
    super.key,
  });

  final Widget child;

  final void Function()? onTapAccounts;
  final void Function()? onTapPermissions;
  final void Function()? onTapObjects;
  final VoidCallback? onTapCreateLink;
  final void Function()? onQuit;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFAF9F6),
        body: Theme(
          data: ThemeData(
            dividerTheme: const DividerThemeData(
              color: Color(0xFF8D8D8D),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 240,
                child: AppMenu(
                  boxDecoration: const BoxDecoration(color: Colors.black),
                  logout: InkWell(
                    onTap: onQuit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.transparent,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            'Close',
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    MenuAction.custom(
                      builder: (context) => const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 24,
                            top: 12,
                            bottom: 6,
                          ),
                          child: Text(
                            '_rbac',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 32,
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Avenir',
                            ),
                          ),
                        ),
                      ),
                    ),
                    MenuAction.divider(),
                    getMenuAction(
                      title: 'Accounts',
                      onTap: onTapAccounts,
                      icon: Icons.person_2_outlined,
                    ),
                    MenuAction.divider(),
                    getMenuAction(
                      title: 'Permissions',
                      onTap: onTapPermissions,
                      icon: Icons.check,
                    ),
                    MenuAction.divider(),
                    getMenuAction(
                      title: 'Objects',
                      onTap: onTapObjects,
                      icon: Icons.list,
                    ),
                    MenuAction.divider(),
                    getMenuAction(
                      title: 'Create link',
                      onTap: onTapCreateLink,
                      icon: Icons.link,
                      enableChevron: false,
                    ),
                  ],
                  child: const SizedBox.shrink(),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      );

  MenuAction getMenuAction({
    required String title,
    required void Function()? onTap,
    required IconData icon,
    bool enableChevron = true,
  }) =>
      MenuAction.custom(
        builder: (BuildContext context) => InkWell(
          onTap: onTap,
          child: ColoredBox(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 8,
                top: 12,
                bottom: 12,
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: const Color(0xFFFFFFFF),
                    size: 28,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'Avenir',
                    ),
                  ),
                  const Spacer(),
                  if (enableChevron)
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFFFFFFF),
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
