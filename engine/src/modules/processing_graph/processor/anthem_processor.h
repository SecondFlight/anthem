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

#include "anthem_processor_config.h"

class AnthemGraphNode;
class AnthemProcessContext;

// This class is used to process audio, MIDI and control data. It can produce
// and/or consume any of these data types.
//
// This serves as a base class for internal and external plugins, but also for
// several internal processing modules that interact with the processing graph.
class AnthemProcessor {
public:
  // TODO: Remove this, as the configuration will happen in the model. This
  // class is now just a base class for processors.
  AnthemProcessorConfig config;

  AnthemProcessor(std::string name) : config(AnthemProcessorConfig(name)) {}

  virtual ~AnthemProcessor() = default;

  // This method is called by the processing graph to process audio, MIDI and
  // control data. It is called once per processing block.
  virtual void process(AnthemProcessContext& context, int numSamples) = 0;

  static void assignProcessorToNode(std::string nodeId, std::shared_ptr<AnthemProcessor> processor) {
    auto& processingGraphModel = Anthem::getInstance().project->processingGraph();
    auto node = (*processingGraphModel->nodes())[id];
    node->processor = processor;
  }
};
