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

import 'package:anthem/model/project.dart';
import 'package:anthem/widgets/editors/arranger/arranger_events.dart';
import 'package:anthem/widgets/editors/arranger/arranger_view_model.dart';
import 'package:anthem/widgets/editors/arranger/controller/arranger_controller.dart';
import 'package:anthem/widgets/editors/arranger/helpers.dart';
import 'package:anthem/widgets/editors/shared/helpers/time_helpers.dart';
import 'package:anthem/widgets/editors/shared/scroll_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ArrangerEventListener extends StatefulObserverWidget {
  final Widget? child;

  const ArrangerEventListener({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  State<ArrangerEventListener> createState() => _ArrangerEventListenerState();
}

class _ArrangerEventListenerState extends State<ArrangerEventListener> {
  var _panYStart = double.nan;
  var _panScrollPosStart = double.nan;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      final viewModel = Provider.of<ArrangerViewModel>(context);
      final controller = Provider.of<ArrangerController>(context);

      return EditorScrollManager(
        timeView: viewModel.timeView,
        onVerticalScrollChange: (pixelDelta) {
          viewModel.verticalScrollPosition = (viewModel.verticalScrollPosition +
                  pixelDelta *
                      0.01 *
                      viewModel.baseTrackHeight
                          .clamp(minTrackHeight, maxTrackHeight))
              .clamp(0, double.infinity);
        },
        onVerticalPanStart: (y) {
          _panYStart = y;
          _panScrollPosStart = viewModel.verticalScrollPosition;
        },
        onVerticalPanMove: (y) {
          final delta = -(y - _panYStart);
          viewModel.verticalScrollPosition =
              (_panScrollPosStart + delta).clamp(0, double.infinity);
        },
        child: Listener(
          onPointerDown: (event) {
            controller.pointerDown(
                convertPointerEvent(event, boxConstraints.maxWidth));
          },
          onPointerMove: (event) {
            controller.pointerMove(
                convertPointerEvent(event, boxConstraints.maxWidth));
          },
          onPointerUp: (event) {
            controller
                .pointerUp(convertPointerEvent(event, boxConstraints.maxWidth));
          },
          child: widget.child,
        ),
      );
    });
  }

  ArrangerPointerEvent convertPointerEvent(
      PointerEvent event, double viewWidth) {
    final viewModel = Provider.of<ArrangerViewModel>(context, listen: false);
    final project = Provider.of<ProjectModel>(context, listen: false);

    final offset = pixelsToTime(
      timeViewStart: viewModel.timeView.start,
      timeViewEnd: viewModel.timeView.end,
      viewPixelWidth: viewWidth,
      pixelOffsetFromLeft: event.localPosition.dx,
    );

    final track = posToTrackIndex(
      yOffset: event.localPosition.dy,
      baseTrackHeight: viewModel.baseTrackHeight,
      trackOrder: project.song.trackOrder,
      trackHeightModifiers: viewModel.trackHeightModifiers,
      scrollPosition: viewModel.verticalScrollPosition,
    );

    return ArrangerPointerEvent(offset: offset, track: track);
  }
}
