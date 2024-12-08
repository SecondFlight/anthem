/*
  Copyright (C) 2024 Joshua Wade

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

import 'package:anthem/helpers/id.dart';
import 'package:anthem/model/anthem_model_base_mixin.dart';
import 'package:anthem/model/collections.dart';
import 'package:anthem/model/processing_graph/node.dart';
import 'package:anthem/model/processing_graph/node_config.dart';
import 'package:anthem/model/processing_graph/node_port.dart';
import 'package:anthem/model/processing_graph/node_port_config.dart';
import 'package:anthem/model/processing_graph/parameter_config.dart';
import 'package:anthem_codegen/include/annotations.dart';
import 'package:mobx/mobx.dart';

part 'tone_generator.g.dart';

/// A processor that generates a tone.
@AnthemModel.syncedModel(
  cppBehaviorClassName: 'ToneGeneratorProcessor',
  cppBehaviorClassIncludePath: 'modules/processors/tone_generator.h',
)
class ToneGeneratorProcessorModel extends _ToneGeneratorProcessorModel
    with
        _$ToneGeneratorProcessorModel,
        _$ToneGeneratorProcessorModelAnthemModelMixin {
  ToneGeneratorProcessorModel({
    required super.nodeId,
  });

  ToneGeneratorProcessorModel.uninitialized() : super(nodeId: '');

  factory ToneGeneratorProcessorModel.fromJson(Map<String, dynamic> json) =>
      _$ToneGeneratorProcessorModelAnthemModelMixin.fromJson(json);

  /// The node that this processor represents.
  NodeModel get node => (project.processingGraph.nodes[nodeId])!;

  /// Creates a node for this processor.
  static NodeModel createNode() {
    final id = 'tone-generator-${getId()}';

    return NodeModel(
      config: NodeConfigModel(),
      id: id,
      audioOutputPorts: AnthemObservableList.of([
        NodePortModel(
          id: 0,
          config: NodePortConfigModel(
            dataType: NodePortDataType.audio,
            parameterConfig: ParameterConfigModel(
              id: 0,
              defaultValue: 440,
              minimumValue: 1,
              maximumValue: 22500,
              smoothingDurationSeconds: 0.5,
            ),
          ),
          nodeId: id,
        ),
      ]),
    );
  }
}

abstract class _ToneGeneratorProcessorModel with Store, AnthemModelBase {
  String nodeId;

  _ToneGeneratorProcessorModel({
    required this.nodeId,
  });
}
