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

part of 'messages.dart';

class SetParameterRequest extends Request {
  late int nodeId;
  late int parameterId;
  late double value;

  SetParameterRequest.uninitialized();

  SetParameterRequest({
    required int id,
    required this.nodeId,
    required this.parameterId,
    required this.value,
  }) {
    super.id = id;
  }
}

class SetParameterResponse extends Response {
  late bool success;

  SetParameterResponse.uninitialized();

  SetParameterResponse({
    required int id,
    required this.success,
  }) {
    super.id = id;
  }
}
