/*
  Copyright (C) 2022 - 2023 Joshua Wade, Budislav Stepanov

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

import 'package:anthem/widgets/basic/background.dart';
import 'package:anthem/widgets/basic/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'icon.dart';

class ButtonTabs<T> extends StatefulWidget {
  final bool expandToFit;
  final List<ButtonTabDef<T>> tabs;
  final T? selected;
  final Function(T id)? onChange;
  final ButtonVariant? variant;
  final int spaceBetween;

  const ButtonTabs({
    Key? key,
    required this.tabs,
    this.selected,
    this.onChange,
    this.expandToFit = true,
    this.variant,
    this.spaceBetween = 0,
  }) : super(key: key);

  @override
  State<ButtonTabs<T>> createState() => _ButtonTabsState<T>();
}

class _ButtonTabsState<T> extends State<ButtonTabs<T>> {
  T? selectedFallback;

  @override
  Widget build(BuildContext context) {
    selectedFallback ??= widget.tabs.first.id;

    final rowChildren = <Widget>[];

    final backgroundType = Provider.of<BackgroundType>(context);

    final buttonStyle = widget.variant ??
        (backgroundType == BackgroundType.light
            ? ButtonVariant.light
            : ButtonVariant.dark);

    final AnthemButtonTheme buttonTheme;

    switch (buttonStyle) {
      case ButtonVariant.light:
        buttonTheme = buttonLightTheme;
        break;
      case ButtonVariant.dark:
        buttonTheme = buttonDarkTheme;
        break;
      case ButtonVariant.ghost:
        buttonTheme = buttonGhostTheme;
        break;
      case ButtonVariant.label:
        buttonTheme = buttonLabelTheme;
        break;
    }

    final borderColor = buttonTheme.border.base;

    for (final tab in widget.tabs) {
      var borderRadius = const BorderRadius.all(Radius.zero);

      if (tab == widget.tabs.first) {
        borderRadius = const BorderRadius.horizontal(left: Radius.circular(3));
      } else if (tab == widget.tabs.last) {
        borderRadius = const BorderRadius.horizontal(right: Radius.circular(3));
      }

      final button = Button(
        icon: tab.type == ButtonTabType.icon ? tab.icon! : null,
        text: tab.type == ButtonTabType.text ? tab.text! : null,
        hideBorder: true,
        borderRadius: borderRadius,
        toggleState: tab.id == (widget.selected ?? selectedFallback),
        expand: widget.expandToFit,
        variant: buttonStyle,
        onPress: () {
          widget.onChange?.call(tab.id);
          setState(() {
            selectedFallback = tab.id;
          });
        },
      );

      rowChildren.add(
        widget.expandToFit
            ? Flexible(
                flex: 1,
                child: button,
              )
            : button,
      );
      if (tab != widget.tabs.last) {
        if (widget.spaceBetween > 0) {
          rowChildren.add(
            SizedBox(width: widget.spaceBetween / 2),
          );
        }
        rowChildren.add(
          Container(
            width: 1,
            color: borderColor,
          ),
        );
        if (widget.spaceBetween > 0) {
          rowChildren.add(
            SizedBox(width: widget.spaceBetween / 2),
          );
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rowChildren,
      ),
    );
  }
}

enum ButtonTabType { text, icon }

class ButtonTabDef<T> {
  T id;
  String? text;
  IconDef? icon;

  ButtonTabDef.withText({required String this.text, required this.id});
  ButtonTabDef.withIcon({required IconDef this.icon, required this.id});

  ButtonTabType get type {
    if (text != null) {
      return ButtonTabType.text;
    } else if (icon != null) {
      return ButtonTabType.icon;
    } else {
      throw Exception('Malformed ButtonTabDef');
    }
  }
}
