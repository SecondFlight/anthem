/*
  Copyright (C) 2023 Joshua Wade

  This file is part of Anthem.

  Anthem is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Anthem is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with Anthem. If not, see <https://www.gnu.org/licenses/>.
*/

import 'package:flutter/widgets.dart';

class ControlledScrollbarOverlay extends StatefulWidget {
  final Widget? child;
  final double handleStart;
  final double handleEnd;
  final double scrollRegionStart;
  final double scrollRegionEnd;

  const ControlledScrollbarOverlay({
    Key? key,
    this.child,
    this.handleStart = 0,
    this.handleEnd = 1,
    this.scrollRegionStart = 0,
    this.scrollRegionEnd = 1,
  }) : super(key: key);

  @override
  State<ControlledScrollbarOverlay> createState() =>
      _ControlledScrollbarOverlayState();
}

class _ControlledScrollbarOverlayState
    extends State<ControlledScrollbarOverlay> {
  bool visible = false;
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, layout) {
      final scrollRegionSize =
          widget.scrollRegionEnd - widget.scrollRegionStart;
      final normalizedHandleStart =
          (widget.handleStart - widget.scrollRegionStart) / scrollRegionSize;
      final normalizedHandleEnd =
          (widget.handleEnd - widget.scrollRegionStart) / scrollRegionSize;

      return MouseRegion(
        onEnter: (e) {
          setState(() {
            visible = true;
          });
        },
        onExit: (e) {
          setState(() {
            visible = false;
          });
        },
        child: Stack(
          children: [
            if (widget.child != null) Positioned.fill(child: widget.child!),
            Positioned(
              right: 0,
              top: layout.maxHeight * normalizedHandleStart,
              bottom: layout.maxHeight * (1 - normalizedHandleEnd),
              child: Padding(
                padding: const EdgeInsets.only(top: 1, right: 1, bottom: 1),
                child: SizedBox(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                      color: const Color(0xFFFFFFFF).withOpacity(hovered
                          ? 0.4
                          : visible
                              ? 0.2
                              : 0),
                    ),
                    width: 6,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
