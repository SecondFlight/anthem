/*
  Copyright (C) 2022 - 2024 Joshua Wade

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

import 'package:anthem/model/anthem_model_base_mixin.dart';
import 'package:anthem_codegen/include/annotations.dart';
import 'package:mobx/mobx.dart';

part 'anthem_color.g.dart';

@AnthemModel.syncedModel()
class AnthemColor extends _AnthemColor
    with _$AnthemColor, _$AnthemColorAnthemModelMixin {
  AnthemColor({
    required super.hue,
    super.lightnessMultiplier = 1,
    super.saturationMultiplier = 1,
  });

  AnthemColor.uninitialized()
      : super(
          hue: 0,
          lightnessMultiplier: 1,
          saturationMultiplier: 1,
        );

  factory AnthemColor.fromJson(Map<String, dynamic> json) =>
      _$AnthemColorAnthemModelMixin.fromJson(json);
}

abstract class _AnthemColor with Store, AnthemModelBase {
  @anthemObservable
  double hue;

  @anthemObservable
  double lightnessMultiplier; // 1 is normal, + is brighter, - is dimmer

  @anthemObservable
  double saturationMultiplier; // 1 is normal, 0 is unsaturated

  _AnthemColor({
    required this.hue,
    required this.lightnessMultiplier,
    required this.saturationMultiplier,
  }) : super();
}
