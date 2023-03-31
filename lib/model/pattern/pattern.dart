/*
  Copyright (C) 2021 - 2023 Joshua Wade

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

import 'package:anthem/helpers/id.dart';
import 'package:anthem/model/project.dart';
import 'package:anthem/model/shared/anthem_color.dart';
import 'package:anthem/model/shared/hydratable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

import '../shared/time_signature.dart';
import 'note.dart';

part 'pattern.g.dart';

@JsonSerializable()
class PatternModel extends _PatternModel with _$PatternModel {
  PatternModel() : super();

  PatternModel.create({required String name, required ProjectModel project})
      : super.create(name: name, project: project);

  factory PatternModel.fromJson(Map<String, dynamic> json) =>
      _$PatternModelFromJson(json);
}

abstract class _PatternModel extends Hydratable with Store {
  ID id = getID();

  @observable
  String name = '';

  @observable
  AnthemColor color = AnthemColor(hue: 0);

  /// The ID here is channel ID `Map<ChannelID, List<NoteModel>>`
  @observable
  @JsonKey(fromJson: _notesFromJson, toJson: _notesToJson)
  ObservableMap<ID, ObservableList<NoteModel>> notes = ObservableMap();

  @observable
  @JsonKey(
      fromJson: _timeSignatureChangesFromJson,
      toJson: _timeSignatureChangesToJson)
  ObservableList<TimeSignatureChangeModel> timeSignatureChanges =
      ObservableList();

  @JsonKey(includeFromJson: false, includeToJson: false)
  ProjectModel? _project;

  ProjectModel get project {
    return _project!;
  }

  /// For deserialization. Use `PatternModel.create()` instead.
  _PatternModel();

  _PatternModel.create({
    required this.name,
    required ProjectModel project,
  }) {
    color = AnthemColor(
      hue: 0,
      saturationMultiplier: 0,
    );
    timeSignatureChanges = ObservableList();
    hydrate(project: project);
  }

  Map<String, dynamic> toJson() => _$PatternModelToJson(this as PatternModel);

  void hydrate({required ProjectModel project}) {
    _project = project;
    isHydrated = true;
  }

  /// Gets the time position of the end of the last item in this pattern
  /// (note, audio clip, automation point), rounded upward to the nearest
  /// `barMultiple` bars.
  int getWidth({
    int barMultiple = 1,
    int minPaddingInBarMultiples = 1,
  }) {
    final ticksPerBar = project.song.ticksPerQuarter ~/
        (_project!.song.defaultTimeSignature.denominator ~/ 4) *
        _project!.song.defaultTimeSignature.numerator;
    final lastContent = notes.values.expand((e) => e).fold<int>(
        ticksPerBar * barMultiple * minPaddingInBarMultiples,
        (previousValue, note) =>
            max(previousValue, (note.offset + note.length)));

    return (max(lastContent, 1) / (ticksPerBar * barMultiple)).ceil() *
        ticksPerBar *
        barMultiple;
  }

  @computed
  int get lastContent {
    return getWidth(barMultiple: 4, minPaddingInBarMultiples: 4);
  }

  @computed
  bool get hasTimeMarkers {
    return timeSignatureChanges.isNotEmpty;
  }
}

// JSON serialization and deserialization functions

typedef NotesJsonType = Map<String, List<Map<String, dynamic>>>;
typedef NotesModelType = ObservableMap<ID, ObservableList<NoteModel>>;

NotesModelType _notesFromJson(Map<String, dynamic> json) {
  return ObservableMap.of(
    json.cast<String, List<dynamic>>().map(
          (key, value) => MapEntry(
            key,
            ObservableList.of(
              value
                  .cast<Map<String, dynamic>>()
                  .map((e) => NoteModel.fromJson(e)),
            ),
          ),
        ),
  );
}

NotesJsonType _notesToJson(NotesModelType model) {
  return model.map(
    (key, value) =>
        MapEntry(key, value.map((element) => element.toJson()).toList()),
  );
}

ObservableList<TimeSignatureChangeModel> _timeSignatureChangesFromJson(
    List<dynamic> json) {
  return ObservableList.of(
    json.map((e) => TimeSignatureChangeModel.fromJson(e)),
  );
}

List<dynamic> _timeSignatureChangesToJson(
    ObservableList<TimeSignatureChangeModel> model) {
  return model.map((value) => value.toJson()).toList();
}
