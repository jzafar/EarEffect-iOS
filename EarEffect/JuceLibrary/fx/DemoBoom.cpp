#include "DemoBoom.hpp"

namespace am::fx
{

auto DemoBoom::parameter(Parameter const& newParameter) -> void { _parameter = newParameter; }

auto DemoBoom::prepare(double sampleRate, int samplesPerBlock) -> void
{
    auto const spec = ProcessSpec{
        sampleRate,
        static_cast<std::size_t>(samplesPerBlock),
        2UL,
    };

    _boom.prepare(spec);
}

auto DemoBoom::process(AudioBuffer<float>& buffer) -> void
{
    _boom.parameter(_parameter);
    _boom.process(buffer);
}

auto DemoBoom::reset() -> void { _boom.reset(); }

}  // namespace am::fx
