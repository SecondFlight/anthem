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

import 'dart:math';
import 'package:anthem/theme.dart';
import 'package:anthem/widgets/project/project_controller.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';

import 'package:flutter/widgets.dart';

import 'background.dart';
import 'icon.dart';

enum ButtonVariant {
  light,
  dark,
  label,
  ghost,
}

class ButtonColors {
  late Color base;
  late Color hover;
  late Color press;

  ButtonColors({
    required this.base,
    required this.hover,
    required this.press,
  });

  ButtonColors.all(Color color) {
    base = color;
    hover = color;
    press = color;
  }

  Color getColor(bool hovered, bool pressed) {
    if (pressed) return press;
    if (hovered) return hover;
    return base;
  }
}

class AnthemButtonTheme {
  final ButtonColors background;
  final ButtonColors border;
  final ButtonColors content;

  const AnthemButtonTheme({
    required this.background,
    required this.border,
    required this.content,
  });
}

final buttonLightTextColors = ButtonColors(
  base: const Color(0xFFCFCFCF),
  hover: const Color(0xFFCFCFCF),
  press: Theme.control.active,
);
final buttonDarkTextColors = ButtonColors(
  base: const Color(0xFFB5B5B5),
  hover: const Color(0xFFB5B5B5),
  press: Theme.control.active,
);

final buttonLightTheme = AnthemButtonTheme(
  background: ButtonColors(
    base: const Color(0xFF666666),
    hover: const Color(0xFF666666), // TODO
    press: const Color(0xFF666666), // TODO
  ),
  border: ButtonColors.all(
    const Color(0xFF2F2F2F),
  ),
  content: buttonLightTextColors,
);
final buttonDarkTheme = AnthemButtonTheme(
  background: ButtonColors(
    base: const Color(0xFF4A4A4A),
    hover: const Color(0xFF4A4A4A), // TODO
    press: const Color(0xFF4A4A4A), // TODO
  ),
  border: ButtonColors.all(
    const Color(0xFF2F2F2F),
  ),
  content: buttonDarkTextColors,
);
final buttonLabelTheme = AnthemButtonTheme(
  background: ButtonColors(
    base: const Color(0x00000000),
    hover: const Color(0x00000000),
    press: const Color(0x00000000),
  ),
  border: ButtonColors(
    base: const Color(0x00000000),
    hover: const Color(0xFF293136),
    press: const Color(0xFF293136),
  ),
  content: buttonLightTextColors,
);
final buttonGhostTheme = AnthemButtonTheme(
  background: ButtonColors(
    base: const Color(0x00000000),
    hover: const Color(0xFF3C484F),
    press: const Color(0xFF3C484F),
  ),
  border: ButtonColors.all(
    const Color(0xFF293136),
  ),
  content: buttonLightTextColors,
);

class Button extends StatefulWidget {
  final ButtonVariant? variant;

  final String? text;
  final IconDef? icon;

  final Widget Function(BuildContext context, Color contentColor)?
      contentBuilder;

  final double? width;
  final double? height;
  final bool? expand;
  final EdgeInsets contentPadding;

  final bool? showMenuIndicator;
  final Color? backgroundColor;
  final Color? backgroundHoverColor;
  final Color? backgroundPressColor;
  final bool? hideBorder;
  final BorderRadius? borderRadius;

  final Function? onPress;
  final bool? toggleState;

  final String? hint;

  const Button({
    Key? key,
    this.variant,
    this.text,
    this.icon,
    this.contentBuilder,
    this.width,
    this.height,
    this.expand,
    this.contentPadding = const EdgeInsets.only(left: 5, right: 5),
    this.showMenuIndicator,
    this.backgroundColor,
    this.backgroundHoverColor,
    this.backgroundPressColor,
    this.hideBorder,
    this.borderRadius,
    this.onPress,
    this.toggleState,
    this.hint,
  }) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  var hovered = false;
  var pressed = false;

  _ButtonState();

  @override
  void didUpdateWidget(Button oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (hovered && oldWidget.hint != widget.hint) {
      Provider.of<ProjectController>(context, listen: false)
          .setHintText(widget.hint ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    AnthemButtonTheme theme;

    final backgroundType = Provider.of<BackgroundType>(context);

    final variant = widget.variant ??
        (backgroundType == BackgroundType.light
            ? ButtonVariant.light
            : ButtonVariant.dark);

    switch (variant) {
      case ButtonVariant.light:
        theme = buttonLightTheme;
        break;
      case ButtonVariant.dark:
        theme = buttonDarkTheme;
        break;
      case ButtonVariant.label:
        theme = buttonLabelTheme;
        break;
      case ButtonVariant.ghost:
        theme = buttonGhostTheme;
        break;
    }

    final toggleState = pressed || (widget.toggleState ?? false);

    var backgroundColor = theme.background.getColor(hovered, toggleState);

    if (!hovered && !toggleState && widget.backgroundColor != null) {
      backgroundColor = widget.backgroundColor!;
    }

    if (hovered && !toggleState && widget.backgroundHoverColor != null) {
      backgroundColor = widget.backgroundHoverColor!;
    }

    if (toggleState && widget.backgroundHoverColor != null) {
      backgroundColor = widget.backgroundHoverColor!;
    }

    final contentColor = theme.content.getColor(hovered, toggleState);

    Widget? buttonContent;

    if (widget.contentBuilder != null) {
      buttonContent = widget.contentBuilder!(context, contentColor);
    } else if (widget.text != null) {
      buttonContent = Text(
        widget.text!,
        style: TextStyle(
          color: contentColor,
          fontSize: 11,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else if (widget.icon != null) {
      buttonContent = SvgIcon(icon: widget.icon!, color: contentColor);
    }

    final List<Widget> stackChildren = [
      Padding(
        padding: widget.contentPadding,
        child: buttonContent,
      ),
    ];

    if (widget.showMenuIndicator == true) {
      stackChildren.add(
        Positioned(
          right: 0,
          bottom: 0,
          child: Transform(
            transform: Matrix4.rotationZ(pi / 4)..translate(Vector3(8, -4, 0)),
            child: Container(
              width: 6 * sqrt2,
              height: 6 * sqrt2,
              color: contentColor,
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (e) {
        if (!mounted) return;
        setState(() {
          hovered = true;
        });
        if (widget.hint != null) {
          Provider.of<ProjectController>(context, listen: false)
              .setHintText(widget.hint!);
        }
      },
      onExit: (e) {
        if (!mounted) return;
        setState(() {
          hovered = false;
        });
        if (widget.hint != null) {
          Provider.of<ProjectController>(context, listen: false)
              .clearHintText();
        }
      },
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerUp,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            border: widget.hideBorder == true
                ? null
                : Border.all(
                    color: theme.border.getColor(hovered, pressed),
                  ),
            color: backgroundColor,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: Stack(
              fit: widget.expand == true
                  ? StackFit.expand
                  : StackFit.passthrough,
              children: stackChildren,
            ),
          ),
        ),
      ),
    );
  }

  void _onPointerDown(PointerEvent e) {
    if (!mounted) return;
    setState(() {
      pressed = true;
    });
  }

  void _onPointerUp(PointerEvent e) {
    if (!mounted) return;
    setState(() {
      pressed = false;
      widget.onPress?.call();
    });
  }
}
