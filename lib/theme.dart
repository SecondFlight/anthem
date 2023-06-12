/*
  Copyright (C) 2021 - 2023 Joshua Wade, Budislav Stepanov

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

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/widgets.dart';

const white = Color(0xFFFFFFFF);
const black = Color(0xFF000000);

class Theme {
  static _Panel panel = _Panel();
  static _Primary primary = _Primary();
  static _Control control = _Control();
  static _Text text = _Text();
  static Color separator = const Color(0xFF666666);
  static _Grid grid = _Grid();
}

class _Panel {
  Color main = const Color(0xFF4F4F4F);
  Color accent = const Color(0xFF585858);
  Color accentDark = const Color(0xFF3F3F3F);
  Color border = const Color(0xFF232323);
}

class _Primary {
  Color main = const Color(0xFF28D1AA);
  Color subtle = const Color(0xFF20A888).withOpacity(0.11);
  Color subtleBorder = const Color(0xFF25C29D).withOpacity(0.38);
}

class _Control {
  _ByBackgroundType main = _ByBackgroundType(
    dark: const Color(0xFF4A4A4A),
    light: const Color(0xFF666666),
  );
  _ByBackgroundType hover = _ByBackgroundType(
    dark: const Color(0xFF666666),
    light: const Color(0xFF7F7F7F),
  );
  Color active = const Color(0xFF25C29D);
  Color border = const Color(0xFF2F2F2F);
}

const _textMain = Color(0xFFCFCFCF);

class _Text {
  Color main = _textMain;
  Color disabled = _textMain.withAlpha(125);
}

class _ByBackgroundType {
  Color dark;
  Color light;

  _ByBackgroundType({required this.dark, required this.light});
}

// For grid lines in editors
class _Grid {
  Color major = const Color(0xFF2E2E2E);
  Color minor = const Color(0xFF373737);
  Color accent = const Color(0xFF131313);
  Color backgroundLight = const Color(0xFF494949);
  Color backgroundDark = const Color(0xFF434343);
  Color shaded = const Color(0x15000000);
}
