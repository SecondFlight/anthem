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

// This file contains messages for syncing the model state between the UI and
// the engine.

part of 'messages.dart';

@AnthemEnum()
enum FieldType { raw, map, list }

@AnthemModel(serializable: true, generateCpp: true)
class FieldAccess extends _FieldAccess with _$FieldAccessAnthemModelMixin {
  FieldAccess.uninitialized() : super(fieldType: FieldType.raw, fieldName: '');

  FieldAccess({
    required super.fieldType,
    required super.fieldName,
    super.serializedMapKey,
    super.listIndex,
  });

  factory FieldAccess.fromJson(Map<String, dynamic> json) =>
      _$FieldAccessAnthemModelMixin.fromJson(json);
}

abstract class _FieldAccess with AnthemModelBase {
  FieldType fieldType;
  String fieldName;
  String? serializedMapKey;
  int? listIndex;

  _FieldAccess({
    required this.fieldType,
    required this.fieldName,
    this.serializedMapKey,
    this.listIndex,
  });
}

@AnthemEnum()
enum FieldUpdateKind { set, add, remove }

class ModelUpdateRequest extends Request {
  /// The kind of update to be performed
  FieldUpdateKind updateKind = FieldUpdateKind.set;

  /// Path to the object to be updated
  List<FieldAccess> fieldAccesses = [];

  /// The name of the field to be updated on the object specified by [fieldAccesses]
  String fieldName = '';

  /// The new value to be used, if the update kind is set
  String? serializedValue;

  /// The index of the list to be updated, if the update kind is add or remove
  int? listIndex;

  /// The key of the map to be updated, if the update kind is add or remove
  String? serializedMapKey;

  ModelUpdateRequest.uninitialized();

  ModelUpdateRequest({
    required int id,
    required this.updateKind,
    required this.fieldAccesses,
    required this.fieldName,
    this.serializedValue,
    this.listIndex,
    this.serializedMapKey,
  }) {
    super.id = id;
  }
}

class ModelInitRequest extends Request {
  String serializedModel = '';

  ModelInitRequest.uninitialized();

  ModelInitRequest({required int id, required this.serializedModel}) {
    super.id = id;
  }
}