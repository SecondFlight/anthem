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

// ignore_for_file: non_constant_identifier_names

part of 'messages.dart';

class GetMasterOutputNodeIdRequest extends Request {
  GetMasterOutputNodeIdRequest.uninitialized();

  GetMasterOutputNodeIdRequest({required int id}) {
    super.id = id;
  }
}

class GetMasterOutputNodeIdResponse extends Response {
  late int nodeId;

  GetMasterOutputNodeIdResponse.uninitialized();

  GetMasterOutputNodeIdResponse({
    required int id,
    required this.nodeId,
  }) {
    super.id = id;
  }
}

// Adds a processor to the processing graph
class AddProcessorRequest extends Request {
  late String processorId;

  AddProcessorRequest.uninitialized();

  AddProcessorRequest({
    required int id,
    required this.processorId,
  }) {
    super.id = id;
  }
}

class AddProcessorResponse extends Response {
  // Whether the command succeeded
  late bool success;

  // If the command succeeded, this will contain an ID to look up the processor
  late int processorId;

  // If the command failed, this will contain an error message
  String? error;

  AddProcessorResponse.uninitialized();

  AddProcessorResponse({
    required int id,
    required this.success,
    required this.processorId,
    this.error,
  }) {
    super.id = id;
  }
}

// Removes a processor from the processing graph
class RemoveProcessorRequest extends Request {
  late int nodeId;

  RemoveProcessorRequest.uninitialized();

  RemoveProcessorRequest({
    required int id,
    required this.nodeId,
  }) {
    super.id = id;
  }
}

class RemoveProcessorResponse extends Response {
  late bool success;
  String? error;

  RemoveProcessorResponse.uninitialized();

  RemoveProcessorResponse({
    required int id,
    required this.success,
    this.error,
  }) {
    super.id = id;
  }
}

@AnthemEnum()
enum ProcessorConnectionType { audio, noteEvent, control }

// Connects two processors in the node graph (e.g. an instrument audio output to
// an effect audio input).
class ConnectProcessorsRequest extends Request {
  late int sourceId;
  late int destinationId;

  late ProcessorConnectionType connectionType;

  late int sourcePortIndex;
  late int destinationPortIndex;

  ConnectProcessorsRequest.uninitialized();

  ConnectProcessorsRequest({
    required int id,
    required this.sourceId,
    required this.destinationId,
    required this.connectionType,
    required this.sourcePortIndex,
    required this.destinationPortIndex,
  }) {
    super.id = id;
  }
}

class ConnectProcessorsResponse extends Response {
  late bool success;
  String? error;

  ConnectProcessorsResponse.uninitialized();

  ConnectProcessorsResponse({
    required int id,
    required this.success,
    this.error,
  }) {
    super.id = id;
  }
}

// Disconnects two processors in the node graph.
class DisconnectProcessorsRequest extends Request {
  late int sourceId;
  late int destinationId;

  late ProcessorConnectionType connectionType;

  late int sourcePortIndex;
  late int destinationPortIndex;

  DisconnectProcessorsRequest.uninitialized();

  DisconnectProcessorsRequest({
    required int id,
    required this.sourceId,
    required this.destinationId,
    required this.connectionType,
    required this.sourcePortIndex,
    required this.destinationPortIndex,
  }) {
    super.id = id;
  }
}

class DisconnectProcessorsResponse extends Response {
  late bool success;
  String? error;

  DisconnectProcessorsResponse.uninitialized();

  DisconnectProcessorsResponse({
    required int id,
    required this.success,
    this.error,
  }) {
    super.id = id;
  }
}

// Processor category enum
@AnthemEnum()
enum ProcessorCategory { effect, generator, utility }

@AnthemModel(serializable: true, generateCpp: true)
class ProcessorDescription extends _ProcessorDescription
    with _$ProcessorDescriptionAnthemModelMixin {
  ProcessorDescription.uninitialized();

  factory ProcessorDescription.fromJson(Map<String, dynamic> json) =>
      _$ProcessorDescriptionAnthemModelMixin.fromJson(json);

  ProcessorDescription({
    required String processorId,
    required ProcessorCategory category,
  }) {
    this.processorId = processorId;
    this.category = category;
  }
}

class _ProcessorDescription {
  late String processorId;
  late ProcessorCategory category;
}

class GetProcessorsRequest extends Request {
  GetProcessorsRequest.uninitialized();

  GetProcessorsRequest({required int id}) {
    super.id = id;
  }
}

class GetProcessorsResponse extends Response {
  late List<ProcessorDescription> processors;

  GetProcessorsResponse.uninitialized();

  GetProcessorsResponse({
    required int id,
    required this.processors,
  }) {
    super.id = id;
  }
}

@AnthemModel(serializable: true, generateCpp: true)
class ProcessorPortDescription extends _ProcessorPortDescription
    with _$ProcessorPortDescriptionAnthemModelMixin {
  ProcessorPortDescription.uninitialized();

  factory ProcessorPortDescription.fromJson(Map<String, dynamic> json) =>
      _$ProcessorPortDescriptionAnthemModelMixin.fromJson(json);

  ProcessorPortDescription({required int id}) {
    this.id = id;
  }
}

class _ProcessorPortDescription {
  late int id;
}

@AnthemModel(serializable: true, generateCpp: true)
class ProcessorParameterDescription extends _ProcessorParameterDescription
    with _$ProcessorParameterDescriptionAnthemModelMixin {
  ProcessorParameterDescription.uninitialized();

  factory ProcessorParameterDescription.fromJson(Map<String, dynamic> json) =>
      _$ProcessorParameterDescriptionAnthemModelMixin.fromJson(json);

  ProcessorParameterDescription({
    required int id,
    required double defaultValue,
    required double minValue,
    required double maxValue,
  }) {
    this.id = id;
    this.defaultValue = defaultValue;
    this.minValue = minValue;
    this.maxValue = maxValue;
  }
}

class _ProcessorParameterDescription {
  late int id;
  late double defaultValue;
  late double minValue;
  late double maxValue;
}

// Gets the ports of a node instance with the given ID
class GetProcessorPortsRequest extends Request {
  late int nodeId;

  GetProcessorPortsRequest.uninitialized();

  GetProcessorPortsRequest({
    required int id,
    required this.nodeId,
  }) {
    super.id = id;
  }
}

class GetProcessorPortsResponse extends Response {
  // Whether the command succeeded
  late bool success;

  // If the command failed, this will contain an error message
  String? error;

  List<ProcessorPortDescription> inputAudioPorts = [];
  List<ProcessorPortDescription> inputControlPorts = [];
  List<ProcessorPortDescription> inputNoteEventPorts = [];

  List<ProcessorPortDescription> outputAudioPorts = [];
  List<ProcessorPortDescription> outputControlPorts = [];
  List<ProcessorPortDescription> outputNoteEventPorts = [];

  List<ProcessorParameterDescription> parameters = [];

  GetProcessorPortsResponse.uninitialized();

  GetProcessorPortsResponse({
    required int id,
    required this.success,
    this.error,
    this.inputAudioPorts = const [],
    this.inputControlPorts = const [],
    this.inputNoteEventPorts = const [],
    this.outputAudioPorts = const [],
    this.outputControlPorts = const [],
    this.outputNoteEventPorts = const [],
    this.parameters = const [],
  }) {
    super.id = id;
  }
}

// Compiles the processing graph and sends the result to the audio thread. This
// must be called after any graph changes.
class CompileProcessingGraphRequest extends Request {
  CompileProcessingGraphRequest.uninitialized();

  CompileProcessingGraphRequest({required int id}) {
    super.id = id;
  }
}

class CompileProcessingGraphResponse extends Response {
  late bool success;
  String? error;

  CompileProcessingGraphResponse.uninitialized();

  CompileProcessingGraphResponse({
    required int id,
    required this.success,
    this.error,
  }) {
    super.id = id;
  }
}
