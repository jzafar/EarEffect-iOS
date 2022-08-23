#pragma once

#include "AudioBuffer.hpp"
#include "Boom.hpp"

namespace am::fx
{

class DemoBoom
{
public:
    using Parameter = am::Boom<float>::Parameter;

    DemoBoom() = default;

    auto parameter(Parameter const& newParameter) -> void;

    auto prepare(double sampleRate, int samplesPerBlock) -> void;
    auto process(AudioBuffer<float>& buffer) -> void;
    auto reset() -> void;

private:
    am::Boom<float> _boom{};
    Parameter _parameter{};
};

}  // namespace am::fx
