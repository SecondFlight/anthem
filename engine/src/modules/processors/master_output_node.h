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

#include <juce_audio_basics/juce_audio_basics.h>

#include "modules/processing_graph/topology/anthem_graph_node.h"
#include "modules/processing_graph/processor/anthem_processor.h"

class MasterOutputNode : public AnthemProcessor {
public:
  juce::AudioSampleBuffer buffer;

  MasterOutputNode(int numChannels, int bufferSize);
  ~MasterOutputNode() override;

  int getInputPortIndex() {
    return 0;
  }

  void process(AnthemProcessContext& context, int numSamples) override;
};
