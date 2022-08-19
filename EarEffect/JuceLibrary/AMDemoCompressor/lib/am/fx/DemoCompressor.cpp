#include "DemoCompressor.hpp"

namespace am
{

namespace fx
{
auto DemoCompressor::parameter(Parameter const& newParameter) -> void
{
    _mode = newParameter.mode;

    auto const mainParameter = am::Compressor<float>::Parameter{
        /* .cutoff    = */ newParameter.filterFrequency,
        /* .threshold = */ newParameter.threshold,
        /* .ratio     = */ newParameter.ratio,
        /* .knee      = */ newParameter.knee,
        /* .attack    = */ newParameter.attack,
        /* .release   = */ newParameter.release,
        /* .makeUp    = */ newParameter.makeUp,
        /* .wet       = */ newParameter.wet,
    };

    auto const sideParameter = am::Compressor<float>::Parameter{
        /* .cutoff    = */ newParameter.filterFrequency,
        /* .threshold = */ newParameter.sideThreshold,
        /* .ratio     = */ newParameter.sideRatio,
        /* .knee      = */ newParameter.sideKnee,
        /* .attack    = */ newParameter.sideAttack,
        /* .release   = */ newParameter.sideRelease,
        /* .makeUp    = */ newParameter.sideMakeUp,
        /* .wet       = */ newParameter.sideWet,
    };

    _midSideCompressor.midProcessor().parameter(mainParameter);
    _midSideCompressor.sideProcessor().parameter(sideParameter);
    _dualMonoCompressor.parameter(mainParameter);
}

auto DemoCompressor::prepare(double sampleRate, int samplesPerBlock) -> void
{
    auto const spec = ProcessSpec{
        sampleRate,
        static_cast<std::size_t>(samplesPerBlock),
        2UL,
    };

    _midSideCompressor.prepare(spec);
    _dualMonoCompressor.prepare(spec);
}

auto DemoCompressor::process(AudioBuffer<float>& buffer) -> void
{
    if (_mode == 1) { _midSideCompressor.process(buffer); }
    else { _dualMonoCompressor.process(buffer); }
}

auto DemoCompressor::reset() -> void
{
    _midSideCompressor.reset();
    _dualMonoCompressor.reset();
}

}  // namespace fx
}  // namespace am
