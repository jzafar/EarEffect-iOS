#pragma once

#include <cassert>
#include <cmath>

#include "MathConstants.hpp"
#include "ProcessSpec.hpp"

namespace am
{

enum struct StateVariableFilterType
{
    Lowpass,
    Bandpass,
    Highpass,
    Notch,
    Allpass,
    Bell,
    LowShelf,
    HighShelf,
};

template<typename SampleType, StateVariableFilterType type>
struct StateVariableFilter
{
    static constexpr int Order = 2;
    static constexpr auto Type = type;

    using FilterType  = StateVariableFilterType;
    using NumericType = SampleType;

    StateVariableFilter();

    template<bool shouldUpdate = true>
    void setCutoffFrequency(SampleType newFrequencyHz);

    template<bool shouldUpdate = true>
    void setQValue(SampleType newResonance);

    template<bool shouldUpdate = true>
    void setGain(SampleType newGainLinear);

    template<bool shouldUpdate = true>
    void setGainDecibels(SampleType newGainDecibels);

    [[nodiscard]] SampleType getCutoffFrequency() const noexcept { return cutoffFrequency; }
    [[nodiscard]] SampleType getQValue() const noexcept { return resonance; }
    [[nodiscard]] SampleType getGain() const noexcept { return gain; }

    void prepare(ProcessSpec spec);
    void reset();

    void snapToZero() noexcept;

    inline SampleType processSample(int channel, SampleType inputValue) noexcept
    {
        return processSampleInternal(inputValue, ic1eq[(size_t)channel], ic2eq[(size_t)channel]);
    }

private:
    void update();

    inline SampleType processSampleInternal(SampleType x, SampleType& s1, SampleType& s2) noexcept
    {
        auto const [v0, v1, v2] = processCore(x, s1, s2);

        (void)v0;
        if constexpr (type == FilterType::Lowpass)
            return v2;
        else if constexpr (type == FilterType::Bandpass)
            return v1;
        else if constexpr (type == FilterType::Highpass)
            return v0;
        else if constexpr (type == FilterType::Notch)
            return v2 + v0;  // low + high
        else if constexpr (type == FilterType::Allpass)
            return v2 + v0 - k0 * v1;  // low + high - k * band
        else if constexpr (type == FilterType::Bell)
            return v2 + v0 + k0A * v1;  // low + high + k0 * A * band
        else if constexpr (type == FilterType::LowShelf)
            return Asq * v2 + k0A * v1 + v0;  // Asq * low + k0 * A * band + high
        else if constexpr (type == FilterType::HighShelf)
            return Asq * v0 + k0A * v1 + v2;  // Asq * high + k0 * A * band + low
        else
        {
            assert(false);  // unknown filter type!
            return {};
        }
    }

    inline auto processCore(SampleType x, SampleType& s1, SampleType& s2) noexcept
    {
        auto const v3 = x - s2;
        auto const v0 = a1 * v3 - ak * s1;
        auto const v1 = a2 * v3 + a1 * s1;
        auto const v2 = a3 * v3 + a2 * s1 + s2;

        // update state
        s1 = (NumericType)2 * v1 - s1;
        s2 = (NumericType)2 * v2 - s2;

        return std::make_tuple(v0, v1, v2);
    }

    SampleType cutoffFrequency, resonance, gain;  // parameters
    SampleType g0, k0, A, sqrtA;                  // parameter intermediate values
    SampleType a1, a2, a3, ak, k0A, Asq;          // coefficients
    std::vector<SampleType> ic1eq, ic2eq;         // state variables

    NumericType lowpassMult{0};
    NumericType bandpassMult{0};
    NumericType highpassMult{0};

    double sampleRate{44100.0};
};

template<typename SampleType = float>
using SVFLowpass = StateVariableFilter<SampleType, StateVariableFilterType::Lowpass>;

template<typename SampleType = float>
using SVFHighpass = StateVariableFilter<SampleType, StateVariableFilterType::Highpass>;

template<typename SampleType = float>
using SVFBandpass = StateVariableFilter<SampleType, StateVariableFilterType::Bandpass>;

template<typename SampleType = float>
using SVFAllpass = StateVariableFilter<SampleType, StateVariableFilterType::Allpass>;

template<typename SampleType = float>
using SVFNotch = StateVariableFilter<SampleType, StateVariableFilterType::Notch>;

template<typename SampleType = float>
using SVFBell = StateVariableFilter<SampleType, StateVariableFilterType::Bell>;

template<typename SampleType = float>
using SVFLowShelf = StateVariableFilter<SampleType, StateVariableFilterType::LowShelf>;

template<typename SampleType = float>
using SVFHighShelf = StateVariableFilter<SampleType, StateVariableFilterType::HighShelf>;

template<typename SampleType, StateVariableFilterType type>
StateVariableFilter<SampleType, type>::StateVariableFilter()
{
    setCutoffFrequency(static_cast<NumericType>(1000.0));
    setQValue(static_cast<NumericType>(1.0 / MathConstants<double>::sqrt2));
    setGain(static_cast<NumericType>(1.0));
}

template<typename SampleType, StateVariableFilterType type>
template<bool shouldUpdate>
void StateVariableFilter<SampleType, type>::setCutoffFrequency(SampleType newCutoffFrequencyHz)
{
    assert(newCutoffFrequencyHz >= static_cast<NumericType>(0));
    assert(newCutoffFrequencyHz < static_cast<NumericType>(sampleRate * 0.5));

    cutoffFrequency = newCutoffFrequencyHz;
    auto const w    = MathConstants<NumericType>::pi * cutoffFrequency / (NumericType)sampleRate;

    g0 = std::tan(w);

    if constexpr (shouldUpdate) { update(); }
}

template<typename SampleType, StateVariableFilterType type>
template<bool shouldUpdate>
void StateVariableFilter<SampleType, type>::setQValue(SampleType newResonance)
{
    assert(newResonance > static_cast<NumericType>(0));

    resonance = newResonance;
    k0        = (NumericType)1.0 / resonance;
    k0A       = k0 * A;

    if constexpr (shouldUpdate) { update(); }
}

template<typename SampleType, StateVariableFilterType type>
template<bool shouldUpdate>
void StateVariableFilter<SampleType, type>::setGain(SampleType newGainLinear)
{
    assert(newGainLinear > static_cast<NumericType>(0));

    gain = newGainLinear;

    A     = std::sqrt(gain);
    sqrtA = std::sqrt(A);
    Asq   = A * A;
    k0A   = k0 * A;

    if constexpr (shouldUpdate) { update(); }
}

template<typename SampleType, StateVariableFilterType type>
template<bool shouldUpdate>
void StateVariableFilter<SampleType, type>::setGainDecibels(SampleType newGainDecibels)
{
    setGain<shouldUpdate>(decibelsToGain(newGainDecibels));
}

template<typename SampleType, StateVariableFilterType type>
void StateVariableFilter<SampleType, type>::prepare(ProcessSpec spec)
{
    assert(spec.sampleRate > 0);
    assert(spec.numChannels > 0);

    sampleRate = spec.sampleRate;

    ic1eq.resize(spec.numChannels);
    ic2eq.resize(spec.numChannels);

    reset();

    setCutoffFrequency(cutoffFrequency);
}

template<typename SampleType, StateVariableFilterType type>
void StateVariableFilter<SampleType, type>::reset()
{
    for (auto v : {&ic1eq, &ic2eq}) std::fill(v->begin(), v->end(), static_cast<SampleType>(0));
}

template<typename SampleType, StateVariableFilterType type>
void StateVariableFilter<SampleType, type>::snapToZero() noexcept
{
#if JUCE_SNAP_TO_ZERO
    for (auto v : {&ic1eq, &ic2eq})
        for (auto& element : *v) juce::dsp::util::snapToZero(element);
#endif
}

template<typename SampleType, StateVariableFilterType type>
void StateVariableFilter<SampleType, type>::update()
{
    SampleType g, k;
    if constexpr (type == FilterType::Bell)
    {
        g = g0;
        k = k0 / A;
    }
    else if constexpr (type == FilterType::LowShelf)
    {
        g = g0 / sqrtA;
        k = k0;
    }
    else if constexpr (type == FilterType::HighShelf)
    {
        g = g0 * sqrtA;
        k = k0;
    }
    else
    {
        g = g0;
        k = k0;
    }

    auto const gk = g + k;
    a1            = (NumericType)1.0 / ((NumericType)1.0 + g * gk);
    a2            = g * a1;
    a3            = g * a2;
    ak            = gk * a1;
}

}  // namespace am
