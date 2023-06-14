/*
  Copyright (C) 2022 - 2023 Joshua Wade

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

import 'package:anthem/model/project.dart';
import 'package:anthem/theme.dart';
import 'package:anthem/widgets/basic/button_tabs.dart';
import 'package:anthem/widgets/basic/button.dart';
import 'package:anthem/widgets/basic/icon.dart';
import 'package:anthem/widgets/project/project_controller.dart';
import 'package:anthem/widgets/project/project_view_model.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProjectFooter extends StatelessWidget {
  const ProjectFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectController = Provider.of<ProjectController>(context);
    final projectModel = Provider.of<ProjectModel>(context);
    final viewModel = Provider.of<ProjectViewModel>(context);

    final separator = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: Container(color: const Color(0xFF5E5E5E), height: 24, width: 2),
    );

    return SizedBox(
      height: 32,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Observer(builder: (context) {
              return ButtonTabs(
                expandToFit: false,
                variant: ButtonVariant.label,
                tabs: [
                  ButtonTabDef.withIcon(icon: Icons.projectPanel, id: false),
                  ButtonTabDef.withIcon(icon: Icons.detailEditor, id: true),
                ],
                selected: projectModel.isDetailViewSelected,
                onChange: (selected) {
                  projectController.setActiveDetailView(selected);
                },
              );
            }),
            separator,
            // This widget aligns the text. The text is centered "correctly"
            // without it, except that the text here is all-caps and so doesn't
            // have any content below the baseline. This adjustment means the
            // text is centered properly when taking the lack of baseline into
            // account.
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: ButtonTabs(
                // selected: ProjectLayoutKind.arrange,
                spaceBetween: 8,
                expandToFit: false,
                variant: ButtonVariant.label,
                tabs: [
                  ButtonTabDef.withText(
                    text: 'ARRANGE',
                    id: ProjectLayoutKind.arrange,
                  ),
                  ButtonTabDef.withText(
                    text: 'EDIT',
                    id: ProjectLayoutKind.edit,
                  ),
                  ButtonTabDef.withText(
                    text: 'MIX',
                    id: ProjectLayoutKind.mix,
                  ),
                ],
              ),
            ),
            separator,
            Observer(builder: (context) {
              return Button(
                variant: ButtonVariant.label,
                hideBorder: true,
                icon: Icons.patternEditor,
                toggleState: projectModel.isPatternEditorVisible,
                onPress: () => projectModel.isPatternEditorVisible =
                    !projectModel.isPatternEditorVisible,
                hint: projectModel.isPatternEditorVisible
                    ? 'Hide pattern editor'
                    : 'Show pattern editor',
              );
            }),
            separator,
            ButtonTabs(
              // selected: EditorKind.detail,
              expandToFit: false,
              variant: ButtonVariant.label,
              tabs: [
                ButtonTabDef.withIcon(
                  icon: Icons.detailEditor,
                  id: EditorKind.detail,
                ),
                ButtonTabDef.withIcon(
                  icon: Icons.automation,
                  id: EditorKind.automation,
                ),
                ButtonTabDef.withIcon(
                  icon: Icons.channelRack,
                  id: EditorKind.channelRack,
                ),
                ButtonTabDef.withIcon(
                  icon: Icons.mixer,
                  id: EditorKind.mixer,
                ),
              ],
            ),
            separator,
            Container(
              width: 304,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Observer(builder: (context) {
                  return Text(
                    viewModel.hintText,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.text.main,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
              ),
            ),
            const Expanded(child: SizedBox()),
            Button(
              variant: ButtonVariant.label,
              icon: Icons.automationMatrixPanel,
            ),
          ],
        ),
      ),
    );
  }
}
