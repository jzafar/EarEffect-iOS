#pragma once

#include "AudioBuffer.hpp"
#include "Compressor.hpp"
#include "Decibels.hpp"
#include "LinearSmoothed.hpp"
#include "ProcessSpec.hpp"

namespace am
{
template<typename SampleType>
class Limiter
{
public:
    Limiter() = default;

    void setThreshold(SampleType newThreshold);
    void setRelease(SampleType newRelease);

    void prepare(am::ProcessSpec const& spec);

    void reset();

    void process(am::AudioBuffer<SampleType>& buffer) noexcept
    {
        firstStageCompressor.process(buffer);
        secondStageCompressor.process(buffer);

        am::applyGain(buffer, outputVolume);
        am::clip(buffer);
    }

private:
    void update();

    am::Compressor<SampleType> firstStageCompressor{};
    am::Compressor<SampleType> secondStageCompressor{};
    am::LinearSmoothed<SampleType> outputVolume{};

    double _sampleRate{44100.0};
    SampleType _thresholddB{-10.0};
    SampleType _releaseTime{100.0};
};

template<typename SampleType>
void Limiter<SampleType>::setThreshold(SampleType newThreshold)
{
    _thresholddB = newThreshold;
    update();
}

template<typename SampleType>
void Limiter<SampleType>::setRelease(SampleType newRelease)
{
    _releaseTime = newRelease;
    update();
}

template<typename SampleType>
void Limiter<SampleType>::prepare(am::ProcessSpec const& spec)
{
    assert(spec.sampleRate > 0);
    assert(spec.numChannels > 0);

    _sampleRate = spec.sampleRate;

    firstStageCompressor.prepare(spec);
    secondStageCompressor.prepare(spec);

    update();
    reset();
}

template<typename SampleType>
void Limiter<SampleType>::reset()
{
    firstStageCompressor.reset();
    secondStageCompressor.reset();

    outputVolume.reset(_sampleRate, 0.001);
}

template<typename SampleType>
void Limiter<SampleType>::update()
{
    // firstStageCompressor.setThreshold ((SampleType) -10.0);
    // firstStageCompressor.setRatio     ((SampleType) 4.0);
    // firstStageCompressor.setAttack    ((SampleType) 2.0);
    // firstStageCompressor.setRelease   ((SampleType) 200.0);

    // secondStageCompressor.setThreshold (_thresholddB);
    // secondStageCompressor.setRatio     ((SampleType) 1000.0);
    // secondStageCompressor.setAttack    ((SampleType) 0.001);
    // secondStageCompressor.setRelease   (_releaseTime);

    auto firstStageParameter      = am::Compressor<float>::Parameter{};
    firstStageParameter.threshold = (SampleType)-10.0;
    firstStageParameter.ratio     = (SampleType)4.0;
    firstStageParameter.attack    = (SampleType)2.0;
    firstStageParameter.release   = (SampleType)200.0;
    firstStageCompressor.parameter(firstStageParameter);

    auto secondStageParameter      = am::Compressor<float>::Parameter{};
    secondStageParameter.threshold = _thresholddB;
    secondStageParameter.ratio   = (SampleType)31.0f;  // ratio over 30 sets it automatically to limiter with ratio 1000
    secondStageParameter.attack  = (SampleType)0.001;
    secondStageParameter.release = _releaseTime;
    secondStageCompressor.parameter(secondStageParameter);

    auto ratioInverse = (SampleType)(1.0 / 4.0);

    auto gain = (SampleType)std::pow(10.0, 10.0 * (1.0 - ratioInverse) / 40.0);
    gain *= am::decibelsToGain(-_thresholddB);

    outputVolume.setTargetValue(gain);
}

}  // namespace am
