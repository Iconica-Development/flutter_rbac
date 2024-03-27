import 'package:flutter/material.dart';
import 'package:flutter_rbac_service/flutter_rbac_service.dart';
import 'package:flutter_rbac_service_data_interface/flutter_rbac_service_data_interface.dart';
import 'package:flutter_rbac_view/src/widgets/dialogs/name_dialog.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/rbac_data_table.dart';

class ObjectTable extends StatefulWidget {
  const ObjectTable({
    required this.rbacService,
    required this.onTapObject,
    super.key,
  });

  final RbacService rbacService;
  final void Function(SecurableObjectModel object) onTapObject;

  @override
  State<ObjectTable> createState() => _ObjectTableState();
}

class _ObjectTableState extends State<ObjectTable> {
  late Future<List<SecurableObjectModel>> dataFuture;

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    dataFuture = getData();
  }

  Future<List<SecurableObjectModel>> getData() =>
      widget.rbacService.getAllSecurableObjects();

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: dataFuture,
        builder: (context, snapshot) => RbacDataTable<SecurableObjectModel>(
          title: 'Securable objects',
          tableTitle: 'SECURED OBJECTS',
          items: snapshot.data,
          onTapRefresh: () {
            setState(() {
              // ignore: discarded_futures
              dataFuture = getData();
            });
          },
          rowAmount: 15,
          titleButtonText: 'Create secured object',
          titleButtonOnTap: () async {
            await showDialog(
              context: context,
              builder: (context) => NameDialog(
                title: 'Name your secured object',
                onSuccesfullCommit: (name) async {
                  await widget.rbacService.createSecurableObject(name);

                  setState(() {
                    dataFuture = getData();
                  });
                },
              ),
            );
          },
          // ignore: avoid_annotating_with_dynamic
          listItemBuilder: (dynamic account) {
            if (account is SecurableObjectModel)
              return ListItem(
                data: [(account.name, 1), (account.id, 1), (null, 1)],
                trailingIcon: const Icon(
                  Icons.chevron_right,
                  size: 24,
                ),
                onTap: () {
                  widget.onTapObject(account);
                },
              );

            return null;
          },
        ),
      );
}
