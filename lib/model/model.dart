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

@GenerateCppModuleFile()
library;

import 'package:anthem_codegen/include.dart';

export 'arrangement/arrangement.dart';
export 'arrangement/clip.dart';

export 'pattern/automation_lane.dart';
export 'pattern/automation_point.dart';
export 'pattern/note.dart';
export 'pattern/pattern.dart';

export 'processing_graph/processor.dart';
export 'processing_graph/processor_definition.dart';

export 'shared/anthem_color.dart';
export 'shared/hydratable.dart';
export 'shared/time_signature.dart';

export 'app.dart';
export 'generator.dart';
export 'plugin.dart';
export 'project.dart';
export 'song.dart';
export 'store.dart';
export 'track.dart';
