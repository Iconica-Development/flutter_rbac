import 'package:flutter/material.dart';

class BlockHeader extends StatelessWidget {
  const BlockHeader({
    required this.titles,
    this.trailingIcon,
    this.rightPadding = 24,
    this.leftPadding = 24,
    super.key,
  });

  final List<(String?, int?)> titles;
  final Widget? trailingIcon;
  final double rightPadding;
  final double leftPadding;

  @override
  Widget build(BuildContext context) => Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24)
            .copyWith(right: rightPadding, left: leftPadding),
        child: Row(
          children: [
            for (var title in titles) ...[
              if (title.$1 != null) ...[
                Expanded(
                  flex: title.$2 ?? 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title.$1!,
                      style: const TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Spacer(
                  flex: title.$2 ?? 1,
                ),
              ],
            ],
            if (trailingIcon != null) ...[
              trailingIcon!,
            ],
          ],
        ),
      );
}
