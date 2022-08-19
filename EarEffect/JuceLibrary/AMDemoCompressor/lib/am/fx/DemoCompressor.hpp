#pragma once

#include "AudioBuffer.hpp"
#include "Compressor.hpp"
#include "MidSideCompressor.hpp"

namespace am
{

namespace fx
{
class DemoCompressor
{
public:
    struct Parameter
    {
        float filterFrequency;
        int mode;

        // compressor - primary
        float threshold;
        float ratio;
        float knee;
        float attack;
        float release;
        float makeUp;
        float wet;

        // compressor - side
        float sideThreshold;
        float sideRatio;
        float sideKnee;
        float sideAttack;
        float sideRelease;
        float sideMakeUp;
        float sideWet;
    };

    DemoCompressor() = default;

    auto parameter(Parameter const& newParameter) -> void;

    auto prepare(double sampleRate, int samplesPerBlock) -> void;
    auto process(AudioBuffer<float>& buffer) -> void;
    auto reset() -> void;

private:
    am::Compressor<float> _dualMonoCompressor;
    am::MidSideCompressor<float> _midSideCompressor;
    int _mode;
};
}  // namespace fx
}  // namespace am
