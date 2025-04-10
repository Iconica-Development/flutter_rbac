// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:flutter/material.dart";

class ListItem extends StatelessWidget {
  const ListItem({
    required this.data,
    this.trailingIcon,
    this.onTap,
    this.rightPadding = 24,
    this.selected = false,
    super.key,
  });

  final List<(String?, int?)> data;

  final Widget? trailingIcon;
  final void Function()? onTap;
  final double rightPadding;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD9D9D9) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFF212121),
          ),
        ),
        height: 50,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ).copyWith(right: rightPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (var d in data) ...[
                        if (d.$1 != null) ...[
                          Expanded(
                            flex: d.$2 ?? 1,
                            child: Text(
                              d.$1!,
                              style: const TextStyle(
                                fontFamily: "Avenir",
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ] else ...[
                          Spacer(
                            flex: d.$2 ?? 1,
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                if (trailingIcon != null) ...[trailingIcon!],
              ],
            ),
          ),
        ),
      );
}
