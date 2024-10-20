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

#include "anthem_process_context.h"

#include "modules/processing_graph/topology/anthem_graph_node.h"
#include "modules/core/constants.h"

AnthemProcessContext::AnthemProcessContext(std::shared_ptr<AnthemGraphNode> graphNode, ArenaBufferAllocator<AnthemProcessorEvent>* eventAllocator) : graphNode(graphNode) {
  for (int i = 0; i < graphNode->audioInputs.size(); i++) {
    inputAudioBuffers.push_back(juce::AudioSampleBuffer(2, MAX_AUDIO_BUFFER_SIZE));
  }

  for (int i = 0; i < graphNode->audioOutputs.size(); i++) {
    outputAudioBuffers.push_back(juce::AudioSampleBuffer(2, MAX_AUDIO_BUFFER_SIZE));
  }

  for (int i = 0; i < graphNode->controlInputs.size(); i++) {
    inputControlBuffers.push_back(juce::AudioSampleBuffer(1, MAX_AUDIO_BUFFER_SIZE));
  }

  for (int i = 0; i < graphNode->controlOutputs.size(); i++) {
    outputControlBuffers.push_back(juce::AudioSampleBuffer(1, MAX_AUDIO_BUFFER_SIZE));
  }

  for (int i = 0; i < graphNode->noteEventInputs.size(); i++) {
    inputNoteEventBuffers.push_back(AnthemEventBuffer(eventAllocator, 1024));
  }

  for (int i = 0; i < graphNode->noteEventOutputs.size(); i++) {
    outputNoteEventBuffers.push_back(AnthemEventBuffer(eventAllocator, 1024));
  }

  // Because parameter values use std::atomic, we need to initialize them in an odd way

  parameterValues = std::vector<std::atomic<float>>(graphNode->controlInputs.size());

  for (int i = 0; i < graphNode->controlInputs.size(); i++) {
    std::atomic<float> value(graphNode->parameters[i]);
    parameterValues[i] = value.load();
  }

  parameterSmoothers = std::vector<std::unique_ptr<LinearParameterSmoother>>();

  for (int i = 0; i < graphNode->controlInputs.size(); i++) {
    auto parameterValue = graphNode->parameters[i];
    auto& parameterConfig = graphNode->processor->config.getParameterByIndex(i);

    auto smoother = std::make_unique<LinearParameterSmoother>(parameterValue, parameterConfig->smoothingDurationSeconds);
    parameterSmoothers.push_back(std::move(smoother));
  }
}

void AnthemProcessContext::setParameterValue(size_t index, float value) {
  // Throw if not on the JUCE message thread
  if (!juce::MessageManager::getInstance()->isThisTheMessageThread()) {
    throw std::runtime_error("AnthemProcessContext::setParameterValue() must be called on the JUCE message thread.");
  }

  parameterValues[index].store(value);
}

float AnthemProcessContext::getParameterValue(size_t index) {
  return parameterValues[index].load();
}

void AnthemProcessContext::setAllInputAudioBuffers(const std::vector<juce::AudioSampleBuffer>& buffers) {
  inputAudioBuffers = buffers;
}

void AnthemProcessContext::setAllOutputAudioBuffers(const std::vector<juce::AudioSampleBuffer>& buffers) {
  outputAudioBuffers = buffers;
}

juce::AudioSampleBuffer& AnthemProcessContext::getInputAudioBuffer(size_t index) {
  return inputAudioBuffers[index];
}

juce::AudioSampleBuffer& AnthemProcessContext::getOutputAudioBuffer(size_t index) {
  return outputAudioBuffers[index];
}

size_t AnthemProcessContext::getNumInputAudioBuffers() {
  return inputAudioBuffers.size();
}

size_t AnthemProcessContext::getNumOutputAudioBuffers() {
  return outputAudioBuffers.size();
}

void AnthemProcessContext::setAllInputControlBuffers(const std::vector<juce::AudioSampleBuffer>& buffers) {
  inputControlBuffers = buffers;
}

void AnthemProcessContext::setAllOutputControlBuffers(const std::vector<juce::AudioSampleBuffer>& buffers) {
  outputControlBuffers = buffers;
}

juce::AudioSampleBuffer& AnthemProcessContext::getInputControlBuffer(size_t index) {
  return inputControlBuffers[index];
}

juce::AudioSampleBuffer& AnthemProcessContext::getOutputControlBuffer(size_t index) {
  return outputControlBuffers[index];
}

size_t AnthemProcessContext::getNumInputControlBuffers() {
  return inputControlBuffers.size();
}

size_t AnthemProcessContext::getNumOutputControlBuffers() {
  return outputControlBuffers.size();
}

void AnthemProcessContext::setAllInputNoteEventBuffers(const std::vector<AnthemEventBuffer>& buffers) {
  inputNoteEventBuffers = buffers;
}

void AnthemProcessContext::setAllOutputNoteEventBuffers(const std::vector<AnthemEventBuffer>& buffers) {
  outputNoteEventBuffers = buffers;
}

AnthemEventBuffer& AnthemProcessContext::getInputNoteEventBuffer(size_t index) {
  return inputNoteEventBuffers[index];
}

AnthemEventBuffer& AnthemProcessContext::getOutputNoteEventBuffer(size_t index) {
  return outputNoteEventBuffers[index];
}

size_t AnthemProcessContext::getNumInputNoteEventBuffers() {
  return inputNoteEventBuffers.size();
}

size_t AnthemProcessContext::getNumOutputNoteEventBuffers() {
  return outputNoteEventBuffers.size();
}
