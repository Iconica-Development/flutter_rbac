import 'package:flutter/material.dart';
import 'package:flutter_rbac_view/src/widgets/primary_button.dart';

class SureDialog extends StatelessWidget {
  const SureDialog({
    this.title = 'Are you sure?',
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 52,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF212121)),
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            PrimaryButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              text: 'Yes',
            ),
            const SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                child: Text(
                  'No',
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF8D8D8D),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

Future<bool> showSureDialog(context, {String title = 'Are you sure?'}) async {
  var result = await showDialog(
    context: context,
    builder: (context) => SureDialog(
      title: title,
    ),
  );

  return (result as bool?) ?? false;
}
