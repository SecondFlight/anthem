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

#pragma once

#include <memory>

class AnthemGraphNodePort;

// Represents a connection between two ports in the node graph
class AnthemGraphNodeConnection {
public:
  std::weak_ptr<AnthemGraphNodePort> source;
  std::weak_ptr<AnthemGraphNodePort> destination;

  AnthemGraphNodeConnection(
    std::weak_ptr<AnthemGraphNodePort> source,
    std::weak_ptr<AnthemGraphNodePort> destination
  ) : source(source), destination(destination) {}

  // Delete the copy constructor
  AnthemGraphNodeConnection(const AnthemGraphNodeConnection&) = delete;

  // Delete the copy assignment operator
  AnthemGraphNodeConnection& operator=(const AnthemGraphNodeConnection&) = delete;
};
