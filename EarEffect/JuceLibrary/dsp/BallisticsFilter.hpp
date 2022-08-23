#pragma once

#include "ProcessSpec.hpp"

#include <cassert>

namespace am
{

enum class BallisticsFilterLevelCalculationType
{
    peak,
    RMS
};

/**
    A processor to apply standard attack / release ballistics to an input signal.
    This is useful in dynamics processors, envelope followers, modulated audio
    effects and for smoothing animation in data visualisation.

    @tags{DSP}
*/
template<typename SampleType>
class BallisticsFilter
{
public:
    using LevelCalculationType = BallisticsFilterLevelCalculationType;

    /** Constructor. */
    BallisticsFilter();

    /** Sets the attack time in ms.

        Attack times less than 0.001 ms will be snapped to zero and very long attack
        times will eventually saturate depending on the numerical precision used.
    */
    void setAttackTime(SampleType attackTimeMs);

    /** Sets the release time in ms.

        Release times less than 0.001 ms will be snapped to zero and very long
        release times will eventually saturate depending on the numerical precision
        used.
    */
    void setReleaseTime(SampleType releaseTimeMs);

    /** Sets how the filter levels are calculated.

        Level calculation in digital envelope followers is usually performed using
        peak detection with a rectifier function (like std::abs) and filtering,
        which returns an envelope dependant on the peak or maximum values of the
        signal amplitude.

        To perform an estimation of the average value of the signal you can use
        an RMS (root mean squared) implementation of the ballistics filter instead.
        This is useful in some compressor and noise-gate designs, or in specific
        types of volume meters.
    */
    void setLevelCalculationType(LevelCalculationType newCalculationType);

    /** Initialises the filter. */
    void prepare(ProcessSpec const& spec);

    /** Resets the internal state variables of the filter. */
    void reset();

    /** Resets the internal state variables of the filter to the given initial value. */
    void reset(SampleType initialValue);

    /** Processes one sample at a time on a given channel. */
    SampleType processSample(int channel, SampleType inputValue);

private:
    SampleType calculateLimitedCte(SampleType) const noexcept;

    std::vector<SampleType> yold;
    double sampleRate = 44100.0, expFactor = -0.142;
    SampleType attackTime = 1.0, releaseTime = 100.0, cteAT = 0.0, cteRL = 0.0;
    LevelCalculationType levelType = LevelCalculationType::peak;
};

template<typename SampleType>
BallisticsFilter<SampleType>::BallisticsFilter()
{
    setAttackTime(attackTime);
    setReleaseTime(releaseTime);
}

template<typename SampleType>
void BallisticsFilter<SampleType>::setAttackTime(SampleType attackTimeMs)
{
    attackTime = attackTimeMs;
    cteAT      = calculateLimitedCte(static_cast<SampleType>(attackTime));
}

template<typename SampleType>
void BallisticsFilter<SampleType>::setReleaseTime(SampleType releaseTimeMs)
{
    releaseTime = releaseTimeMs;
    cteRL       = calculateLimitedCte(static_cast<SampleType>(releaseTime));
}

template<typename SampleType>
void BallisticsFilter<SampleType>::setLevelCalculationType(LevelCalculationType newLevelType)
{
    levelType = newLevelType;
    reset();
}

template<typename SampleType>
void BallisticsFilter<SampleType>::prepare(ProcessSpec const& spec)
{
    assert(spec.sampleRate > 0);
    assert(spec.numChannels > 0);

    sampleRate = spec.sampleRate;
    expFactor  = -2.0 * 3.14159265359 * 1000.0 / sampleRate;

    setAttackTime(attackTime);
    setReleaseTime(releaseTime);

    yold.resize(spec.numChannels);

    reset();
}

template<typename SampleType>
void BallisticsFilter<SampleType>::reset()
{
    reset(0);
}

template<typename SampleType>
void BallisticsFilter<SampleType>::reset(SampleType initialValue)
{
    for (auto& old : yold) old = initialValue;
}

template<typename SampleType>
SampleType BallisticsFilter<SampleType>::processSample(int channel, SampleType inputValue)
{
    if (levelType == LevelCalculationType::RMS)
        inputValue *= inputValue;
    else
        inputValue = std::abs(inputValue);

    SampleType cte = (inputValue > yold[(size_t)channel] ? cteAT : cteRL);

    SampleType result     = inputValue + cte * (yold[(size_t)channel] - inputValue);
    yold[(size_t)channel] = result;

    if (levelType == LevelCalculationType::RMS) return std::sqrt(result);

    return result;
}

template<typename SampleType>
SampleType BallisticsFilter<SampleType>::calculateLimitedCte(SampleType timeMs) const noexcept
{
    return timeMs < static_cast<SampleType>(1.0e-3) ? 0 : static_cast<SampleType>(std::exp(expFactor / timeMs));
}

}  // namespace am
