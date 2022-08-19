#pragma once

#include "AudioBuffer.hpp"
#include "JuceCompressor.hpp"
#include "LinearSmoothed.hpp"
#include "ProcessSpec.hpp"

namespace am {

template<typename SampleType>
class JuceLimiter
{
public:
    /** Constructor. */
    JuceLimiter() = default;

    /** Sets the threshold in dB of the limiter.*/
    void setThreshold(SampleType newThreshold);

    /** Sets the release time in milliseconds of the limiter.*/
    void setRelease(SampleType newRelease);

    /** Initialises the processor. */
    void prepare(am::ProcessSpec const& spec);

    /** Resets the internal state variables of the processor. */
    void reset();

    /** Processes the input and output samples supplied in the processing context. */
    void process(am::AudioBuffer<float>& buffer) noexcept
    {
        firstStageCompressor.process(buffer);
        secondStageCompressor.process(buffer);
        am::applyGain(buffer, outputVolume);
        am::clip(buffer);
    }

private:
    void update();
    am::JuceCompressor<SampleType> firstStageCompressor, secondStageCompressor;
    am::LinearSmoothed<SampleType> outputVolume;
    double _sampleRate      = 44100.0;
    SampleType _thresholddB = -10.0, _releaseTime = 100.0;
};

template<typename SampleType>
void JuceLimiter<SampleType>::setThreshold(SampleType newThreshold)
{
    _thresholddB = newThreshold;
    update();
}

template<typename SampleType>
void JuceLimiter<SampleType>::setRelease(SampleType newRelease)
{
    _releaseTime = newRelease;
    update();
}

template<typename SampleType>
void JuceLimiter<SampleType>::prepare(am::ProcessSpec const& spec)
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
void JuceLimiter<SampleType>::reset()
{
    firstStageCompressor.reset();
    secondStageCompressor.reset();

    outputVolume.reset(_sampleRate, 0.001);
}

template<typename SampleType>
void JuceLimiter<SampleType>::update()
{
    firstStageCompressor.setThreshold((SampleType)-10.0);
    firstStageCompressor.setRatio((SampleType)4.0);
    firstStageCompressor.setAttack((SampleType)2.0);
    firstStageCompressor.setRelease((SampleType)200.0);

    secondStageCompressor.setThreshold(_thresholddB);
    secondStageCompressor.setRatio((SampleType)1000.0);
    secondStageCompressor.setAttack((SampleType)0.001);
    secondStageCompressor.setRelease(_releaseTime);

    auto ratioInverse = (SampleType)(1.0 / 4.0);

    auto gain = (SampleType)std::pow(10.0, 10.0 * (1.0 - ratioInverse) / 40.0);
    gain *= am::decibelsToGain(-_thresholddB);

    outputVolume.setTargetValue(gain);
}

}  // namespace am
