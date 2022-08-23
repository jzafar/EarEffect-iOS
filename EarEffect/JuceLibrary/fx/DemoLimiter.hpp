#pragma once

#include "AudioBuffer.hpp"
#include "JuceLimiter.hpp"
#include "Limiter.hpp"

namespace am::fx
{

class DemoLimiter
{
public:
    struct Parameter
    {
        int mode;
        float threshold;
        float ceiling;
        float release;
    };

    DemoLimiter() = default;

    auto parameter(Parameter const& newParameter) -> void;

    auto prepare(double sampleRate, int samplesPerBlock) -> void;
    auto process(AudioBuffer<float>& buffer) -> void;
    auto reset() -> void;

private:
    am::Limiter<float> _customLimiter{};
    am::JuceLimiter<float> _juceLimiter{};
    Parameter _parameter{};
};
}  // namespace am::fx
