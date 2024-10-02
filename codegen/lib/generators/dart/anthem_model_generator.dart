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

import 'dart:async';

import 'package:anthem_codegen/include/annotations.dart';
import 'package:anthem_codegen/generators/dart/json_deserialize_generator.dart';
import 'package:anthem_codegen/generators/dart/mobx_generator.dart';
import 'package:anthem_codegen/generators/util/model_class_info.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'json_serialize_generator.dart';

/// Provides code generation for Anthem models.
///
/// Anthem models must be defined like this:
///
/// ```dart
/// // ...
///
/// part 'my_model.g.dart'
///
/// @AnthemModel.all()
/// class MyModel extends _MyModel with _$MyModelAnthemModelMixin;
///
/// class _MyModel {
///   // ...
/// }
/// ```
class AnthemModelGenerator extends Generator {
  final BuilderOptions options;

  AnthemModelGenerator(this.options);

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    var result = '';

    // Looks for @AnthemModel on each class in the file, and generates the
    // appropriate code
    for (final libraryClass in library.classes) {
      final annotationFromAnalyzer = const TypeChecker.fromRuntime(AnthemModel)
          .firstAnnotationOf(libraryClass);

      // If there is no annotation on this class, don't do anything
      if (annotationFromAnalyzer == null) continue;

      // Read properties from @AnthemModel() annotation

      final anthemModelAnnotation = AnthemModel(
        serializable:
            annotationFromAnalyzer.getField('serializable')?.toBoolValue() ??
                false,
        generateCpp:
            annotationFromAnalyzer.getField('generateCpp')?.toBoolValue() ??
                false,
      );

      final context = ModelClassInfo(library, libraryClass);

      result +=
          'mixin _\$${libraryClass.name}AnthemModelMixin on ${context.baseClass.name} {\n';

      if (anthemModelAnnotation.serializable) {
        result += '\n  // JSON serialization\n';
        result += '\n';
        result += generateJsonSerializationCode(context: context);
        result += '\n  // JSON deserialization\n';
        result += '\n';
        result += generateJsonDeserializationCode(context: context);
        result += '\n  // MobX atoms\n';
        result += '\n';
        result += generateMobXAtoms(context: context);
        result += '\n  // Getters and setters\n';
        result += '\n';
        result += _generateGettersAndSetters(context: context);
      }

      result += '}\n';
    }

    // The cache for parsed classes persists across files, so we need to clear
    // it for each file.
    cleanModelClassInfoCache();

    return result;
  }
}

/// Generates getters and setters for model items.
///
/// Note that this will not generate anything for fields in sealed classes.
String _generateGettersAndSetters({required ModelClassInfo context}) {
  var result = '';

  for (final MapEntry(key: fieldName, value: fieldInfo)
      in context.fields.entries) {
    // TODO: Allow getter/setter if generating model sync code
    if (!fieldInfo.isObservable) continue;

    // Getter

    final typeQ = fieldInfo.typeInfo.isNullable ? '?' : '';

    result += '@override\n';
    result += '${fieldInfo.typeInfo.name}$typeQ get $fieldName {\n';
    if (fieldInfo.isObservable) {
      result += generateMobXGetter(fieldName, fieldInfo);
    }
    result += 'return super.$fieldName;\n';
    result += '}\n\n';

    // Setter

    String generateSetter() {
      var result = '';

      result += 'super.$fieldName = value;\n';

      return result;
    }

    result += '@override\n';
    result += 'set $fieldName(${fieldInfo.typeInfo.name}$typeQ value) {\n';
    if (fieldInfo.isObservable) {
      result += wrapCodeWithMobXSetter(fieldName, fieldInfo, generateSetter());
    }
    result += '}\n\n';
  }

  return result;
}
