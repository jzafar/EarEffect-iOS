#pragma once

#include "AudioBuffer.hpp"
#include "BallisticsFilter.hpp"
#include "Decibels.hpp"
#include "ProcessSpec.hpp"

#include <cassert>

namespace am {

/**
    A simple compressor with standard threshold, ratio, attack time and release time
    controls.

    @tags{DSP}
*/
template<typename T>
class JuceCompressor
{
public:
    /** Constructor. */
    JuceCompressor();

    /** Sets the threshold in dB of the compressor.*/
    void setThreshold(T newThreshold);

    /** Sets the ratio of the compressor (must be higher or equal to 1).*/
    void setRatio(T newRatio);

    /** Sets the attack time in milliseconds of the compressor.*/
    void setAttack(T newAttack);

    /** Sets the release time in milliseconds of the compressor.*/
    void setRelease(T newRelease);

    /** Initialises the processor. */
    void prepare(ProcessSpec const& spec);

    /** Resets the internal state variables of the processor. */
    void reset();

    /** Processes the input and output samples supplied in the processing context. */
    void process(AudioBuffer<T>& buffer) noexcept
    {
        for (auto ch = size_t{0}; ch < buffer.numChannels(); ++ch) {
            for (auto i = size_t{0}; i < buffer.numSamples(); ++i) {
                buffer(ch, i) = processSample(static_cast<int>(ch), buffer(ch, i));
            }
        }
    }

    /** Performs the processing operation on a single sample at a time. */
    T processSample(int channel, T inputValue);

private:
    void update();

    T threshold, thresholdInverse, ratioInverse;
    BallisticsFilter<T> envelopeFilter;

    double sampleRate = 44100.0;
    T thresholddB = 0.0, ratio = 1.0, attackTime = 1.0, releaseTime = 100.0;
};

template<typename T>
JuceCompressor<T>::JuceCompressor()
{
    update();
}

template<typename T>
void JuceCompressor<T>::setThreshold(T newThreshold)
{
    thresholddB = newThreshold;
    update();
}

template<typename T>
void JuceCompressor<T>::setRatio(T newRatio)
{
    assert(newRatio >= static_cast<T>(1.0));

    ratio = newRatio;
    update();
}

template<typename T>
void JuceCompressor<T>::setAttack(T newAttack)
{
    attackTime = newAttack;
    update();
}

template<typename T>
void JuceCompressor<T>::setRelease(T newRelease)
{
    releaseTime = newRelease;
    update();
}

template<typename T>
void JuceCompressor<T>::prepare(ProcessSpec const& spec)
{
    assert(spec.sampleRate > 0);
    assert(spec.numChannels > 0);

    sampleRate = spec.sampleRate;

    envelopeFilter.prepare(spec);

    update();
    reset();
}

template<typename T>
void JuceCompressor<T>::reset()
{
    envelopeFilter.reset();
}

template<typename T>
T JuceCompressor<T>::processSample(int channel, T inputValue)
{
    // Ballistics filter with peak rectifier
    auto env = envelopeFilter.processSample(channel, inputValue);

    // VCA
    auto gain = (env < threshold) ? static_cast<T>(1.0)
                                  : std::pow(env * thresholdInverse, ratioInverse - static_cast<T>(1.0));

    // Output
    return gain * inputValue;
}

template<typename T>
void JuceCompressor<T>::update()
{
    threshold        = decibelsToGain(thresholddB, static_cast<T>(-200.0));
    thresholdInverse = static_cast<T>(1.0) / threshold;
    ratioInverse     = static_cast<T>(1.0) / ratio;

    envelopeFilter.setAttackTime(attackTime);
    envelopeFilter.setReleaseTime(releaseTime);
}

}  // namespace am
