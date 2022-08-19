#include "DemoEQ.hpp"

#include "SoftClipper.hpp"

namespace am::fx
{

auto DemoEQ::parameter(Parameter const& newParameter) -> void { _equalizer.parameter(newParameter); }

auto DemoEQ::prepare(double sampleRate, int samplesPerBlock) -> void
{
    _equalizer.prepare(ProcessSpec{sampleRate, static_cast<std::size_t>(samplesPerBlock), 2UL});
}

auto DemoEQ::process(AudioBuffer<float>& buffer) -> void { _equalizer.process(buffer); }

auto DemoEQ::reset() -> void { _equalizer.reset(); }

}  // namespace am::fx
