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

#include "model_sync_command_handler.h"

#include <string>

std::optional<Response> handleModelSyncCommand(Request& request) {
  auto& anthem = Anthem::getInstance();

  if (rfl::holds_alternative<ModelInitRequest>(request.variant())) {
    std::cout << "Loading project model..." << std::endl;

    auto& modelInitRequest = rfl::get<ModelInitRequest>(request.variant());

    // std::cout << modelInitRequest.serializedModel << std::endl;

    auto result = rfl::json::read<std::shared_ptr<Project>>(
      modelInitRequest.serializedModel
    );

    auto err = result.error();

    if (err.has_value()) {
      std::cout << "Error during deserialize:" << std::endl;
      std::cout << err.value().what() << std::endl;
    }
    else {
      anthem.project = std::move(
        result.value()
      );

      anthem.project->initialize(
        anthem.project,
        nullptr
      );

      std::cout << "Loaded project model" << std::endl;
      std::cout << "id: " << anthem.project->id() << std::endl;
    }
  }
  else if (rfl::holds_alternative<ModelUpdateRequest>(request.variant())) {
    std::cout << "Model update received. Applying..." << std::endl;

    auto& modelUpdateRequest = rfl::get<ModelUpdateRequest>(request.variant());

    anthem.project->handleModelUpdate(
      modelUpdateRequest,
      0
    );

    std::cout << "Model update applied." << std::endl;
  }
  else if (rfl::holds_alternative<ModelDebugPrintRequest>(request.variant())) {
    std::cout << rfl::json::write(
      anthem.project.get()
    ) << std::endl;
  }

  return std::nullopt;
}
