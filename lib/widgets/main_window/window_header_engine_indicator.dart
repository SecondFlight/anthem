/*
  Copyright (C) 2023 - 2024 Joshua Wade

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

import 'package:anthem/engine_api/engine.dart';
import 'package:anthem/model/store.dart';
import 'package:anthem/theme.dart';
import 'package:anthem/widgets/basic/button.dart';
import 'package:anthem/widgets/basic/icon.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class EngineIndicator extends StatelessObserverWidget {
  const EngineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AnthemStore.instance;
    final activeProject = store.projects[store.activeProjectId];
    final engineState = activeProject?.engineState;

    return Button(
      hideBorder: true,
      width: 28,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(2),
        bottomLeft: Radius.circular(1),
        bottomRight: Radius.circular(1),
      ),
      onPress: () async {
        if (engineState != EngineState.stopped) {
          activeProject?.engine.stop();
        } else {
          await activeProject?.engine.start();
        }
      },
      contentBuilder: (context, color) {
        late final Widget indicator;

        if (engineState == EngineState.starting) {
          indicator = SizedBox(
            width: 12,
            height: 12,
            child: material.CircularProgressIndicator(
              color: color,
              strokeWidth: 2,
            ),
          );
        } else {
          indicator = SvgIcon(
            icon: Icons.anthem,
            color: activeProject?.engineState == EngineState.running
                ? Theme.primary.main
                : Theme.text.main,
          );
        }

        return material.Center(child: indicator);
      },
    );
  }
}
