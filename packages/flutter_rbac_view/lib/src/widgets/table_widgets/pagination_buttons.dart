// SPDX-FileCopyrightText: 2024 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class PaginationButtons extends StatelessWidget {
  const PaginationButtons({
    required this.amountOfPages,
    required this.currentPage,
    required this.onPressed,
    super.key,
  });
  final int amountOfPages;
  final int currentPage;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    var amountOfButtons = amountOfPages > 3 ? 3 : amountOfPages;
    var theme = Theme.of(context);
    return amountOfButtons == 1 || amountOfButtons == 0
        ? const SizedBox.shrink()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (currentPage > 0) onPressed(currentPage - 1);
                },
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              if (currentPage == 0)
                for (var i = 0; i < amountOfButtons; i++) ...[
                  _PaginationButton(
                    theme: theme,
                    pageNumber: i + 1,
                    onTap: () {
                      onPressed(i);
                    },
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              if (currentPage + 1 == amountOfPages)
                for (var i = amountOfPages - amountOfButtons;
                    i < amountOfPages;
                    i++) ...[
                  _PaginationButton(
                    theme: theme,
                    pageNumber: i + 1,
                    onTap: () {
                      onPressed(i);
                    },
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              if (currentPage > 0 && currentPage + 1 < amountOfPages)
                for (var i = currentPage - 1; i < currentPage + 2; i++) ...[
                  _PaginationButton(
                    theme: theme,
                    pageNumber: i + 1,
                    onTap: () {
                      onPressed(i);
                    },
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              IconButton(
                onPressed: () {
                  if (currentPage < amountOfPages - 1)
                    onPressed(currentPage + 1);
                },
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ],
          );
  }
}

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({
    required this.theme,
    required this.pageNumber,
    required this.onTap,
  });

  final ThemeData theme;
  final int pageNumber;
  final Function() onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          height: 32,
          width: 32,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black,
          ),
          child: Center(
            child: Text(
              '$pageNumber',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
}
