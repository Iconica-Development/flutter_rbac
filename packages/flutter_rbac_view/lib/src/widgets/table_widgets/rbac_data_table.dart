// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_rbac_view/src/widgets/block_header.dart';
import 'package:flutter_rbac_view/src/widgets/primary_button.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/list_item.dart';
import 'package:flutter_rbac_view/src/widgets/table_widgets/pagination_buttons.dart';

class RbacDataTable<T> extends StatefulWidget {
  const RbacDataTable({
    required this.title,
    required this.tableTitle,
    required this.items,
    required this.listItemBuilder,
    required this.onTapRefresh,
    super.key,
    this.titleButtonText,
    this.titleButtonOnTap,
    this.rowAmount = 6,
  });

  final String title;
  final String tableTitle;
  final String? titleButtonText;
  final Future<void> Function()? titleButtonOnTap;
  final Function() onTapRefresh;
  final List<T>? items;
  final ListItem? Function(T value) listItemBuilder;
  final int rowAmount;

  @override
  State<RbacDataTable> createState() => _RbacDataTableState();
}

class _RbacDataTableState extends State<RbacDataTable> {
  var selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    var data = widget.items?.asMap();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w800,
                fontSize: 32,
              ),
            ),
            const Spacer(),
            if (widget.titleButtonText != null) ...[
              PrimaryButton(
                onPressed: widget.titleButtonOnTap ?? () {},
                text: widget.titleButtonText!,
                enableAddIcon: true,
              ),
            ],
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        BlockHeader(
          titles: [(widget.tableTitle, 1)],
          trailingIcon: IconButton(
            onPressed: () => widget.onTapRefresh(),
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
          rightPadding: 15,
        ),
        const SizedBox(
          height: 6,
        ),
        SizedBox(
          height: 384,
          child: data == null
              ? const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (var i = selectedPage * widget.rowAmount;
                        i < (selectedPage + 1) * widget.rowAmount;
                        i++) ...[
                      if (data[i] != null) ...[
                        widget.listItemBuilder(data[i]) ??
                            const SizedBox.shrink(),
                      ] else ...[
                        const SizedBox.shrink(),
                      ],
                    ],
                    const Spacer(),
                    PaginationButtons(
                      amountOfPages: (data.length / widget.rowAmount).ceil(),
                      currentPage: selectedPage,
                      onPressed: (int page) {
                        setState(() {
                          selectedPage = page;
                        });
                      },
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
