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

#include "write_parameters_to_control_inputs_action.h"

void WriteParametersToControlInputsAction::execute(int numSamples) {
  auto& parameterValues = processContext->getParameterValues();
  auto& parameterSmoothers = processContext->getParameterSmoothers();

  for (auto& [id, valueAtomic] : parameterValues) {
    auto& smoother = parameterSmoothers[id];
    auto value = valueAtomic->load();

    if (smoother->getTargetValue() != value) {
      smoother->setTargetValue(value);
    }

    for (int j = 0; j < numSamples; j++) {
      smoother->process(1.0f / sampleRate);
      auto currentValue = smoother->getCurrentValue();
      processContext->getInputControlBuffer(id).setSample(0, j, currentValue);
    }
  }
}

void WriteParametersToControlInputsAction::debugPrint() {
  std::cout << "WriteParametersToControlInputsAction: " << processContext->getGraphNode()->id() << std::endl;
}
