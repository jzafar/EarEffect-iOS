#include "DemoLimiter.hpp"

#include "SoftClipper.hpp"

namespace am::fx {

auto DemoLimiter::parameter(Parameter const& newParameter) -> void { _parameter = newParameter; }

auto DemoLimiter::prepare(double sampleRate, int samplesPerBlock) -> void
{
    auto const spec = ProcessSpec{
        sampleRate,
        static_cast<std::size_t>(samplesPerBlock),
        2UL,
    };

    _customLimiter.prepare(spec);
    _juceLimiter.prepare(spec);
}

auto DemoLimiter::process(AudioBuffer<float>& buffer) -> void
{
    auto const thresholdDB = gainToDecibels<float>(_parameter.threshold);
    if (_parameter.mode == 1) {
        _customLimiter.setThreshold(thresholdDB);
        _customLimiter.setRelease(_parameter.release);
        _customLimiter.process(buffer);
    } else {
        _juceLimiter.setThreshold(thresholdDB);
        _juceLimiter.setRelease(_parameter.release);
        _juceLimiter.process(buffer);
    }

    auto const ceiling = _parameter.ceiling;

    for (std::size_t ch = 0; ch < buffer.numChannels(); ++ch) {
        for (std::size_t s = 0; s < buffer.numSamples(); ++s) {
            auto const in          = buffer(ch, s);
            auto const softClipped = am::softClip(in) * decibelsToGain(3.5F);
            buffer(ch, s)          = std::clamp(softClipped, -ceiling, ceiling);
        }
    }
}

auto DemoLimiter::reset() -> void
{
    _customLimiter.reset();
    _juceLimiter.reset();
}

}  // namespace am::fx
