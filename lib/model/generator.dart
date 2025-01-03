/*
  Copyright (C) 2021 - 2024 Joshua Wade

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
import 'package:anthem/engine_api/messages/messages.dart'
    show ProcessorConnectionType;
import 'package:anthem/model/anthem_model_base_mixin.dart';
import 'package:anthem/model/project.dart';
import 'package:anthem/model/shared/hydratable.dart';
import 'package:anthem_codegen/include/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'processing_graph/processor.dart';

part 'generator.g.dart';

// Note: I'm not sure about how we're differentiating generator types here. This
// deals with the actual audio engine side of things which is not sketched out.
// For now, we're just marking each generator with an enum saying what kind it
// is, and we can rethink later.

@AnthemEnum()
enum GeneratorType { instrument, automation }

@AnthemModel.syncedModel()
class GeneratorModel extends _GeneratorModel
    with _$GeneratorModel, _$GeneratorModelAnthemModelMixin {
  GeneratorModel.uninitialized()
      : super(
            color: Colors.black,
            id: '',
            name: '',
            generatorType: GeneratorType.instrument,
            processor: ProcessorModel.uninitialized());

  GeneratorModel({
    required super.id,
    required super.name,
    required super.generatorType,
    required super.color,
    required super.processor,
  });

  GeneratorModel.create({
    required super.id,
    required super.name,
    required super.generatorType,
    required super.color,
    required super.processor,
    required super.project,
  }) : super.create();

  factory GeneratorModel.fromJson(Map<String, dynamic> json) =>
      _$GeneratorModelAnthemModelMixin.fromJson(json);
}

abstract class _GeneratorModel extends Hydratable with Store, AnthemModelBase {
  String id;

  @anthemObservable
  String name;

  @anthemObservable
  GeneratorType generatorType;

  @anthemObservable
  Color color;

  @anthemObservable
  ProcessorModel processor;

  @anthemObservable
  ProcessorModel gainNode;

  @anthemObservable
  ProcessorModel midiGeneratorNode;

  @hide
  ProjectModel? _project;

  _GeneratorModel({
    required this.id,
    required this.name,
    required this.generatorType,
    required this.color,
    required this.processor,
  })  : gainNode = ProcessorModel(processorKey: 'Gain'),
        midiGeneratorNode = ProcessorModel(processorKey: 'SimpleMidiGenerator'),
        super();

  _GeneratorModel.create({
    required this.id,
    required this.name,
    required this.generatorType,
    required this.color,
    required this.processor,
    required ProjectModel project,
  })  : gainNode = ProcessorModel(processorKey: 'Gain'),
        midiGeneratorNode = ProcessorModel(processorKey: 'SimpleMidiGenerator'),
        super() {
    hydrate(project: project);
  }

  void hydrate({
    required ProjectModel project,
  }) {
    _project = project;
    isHydrated = true;
  }

  Future<void> createInEngine(Engine engine) async {
    await processor.createInEngine(engine);

    await gainNode.createInEngine(engine);
    // await midiGeneratorNode.createInEngine(engine);

    // await engine.processingGraphApi.connectProcessors(
    //   connectionType: ProcessorConnectionType.NoteEvent,
    //   sourceId: midiGeneratorNode.idInEngine!,
    //   sourcePortIndex: 0,
    //   destinationId: processor.idInEngine!,
    //   destinationPortIndex: 0,
    // );

    await engine.processingGraphApi.connectProcessors(
      connectionType: ProcessorConnectionType.audio,
      sourceId: processor.idInEngine!,
      sourcePortIndex: 0,
      destinationId: gainNode.idInEngine!,
      destinationPortIndex: 0,
    );

    await engine.processingGraphApi.connectProcessors(
      connectionType: ProcessorConnectionType.audio,
      sourceId: gainNode.idInEngine!,
      sourcePortIndex: 0,
      destinationId: _project!.masterOutputNodeId!,
      destinationPortIndex: 0,
    );
  }
}
