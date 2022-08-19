#pragma once

#include "AudioBuffer.hpp"
#include "Equalizer.hpp"

namespace am::fx
{

class DemoEQ
{
public:
    using Parameter = am::Equalizer<float>::Parameter;

    DemoEQ() = default;

    auto parameter(Parameter const& newParameter) -> void;

    auto prepare(double sampleRate, int samplesPerBlock) -> void;
    auto process(AudioBuffer<float>& buffer) -> void;
    auto reset() -> void;

private:
    am::Equalizer<float> _equalizer;
    Parameter _parameter{};
};
}  // namespace am::fx
