#pragma once

#include "BallisticsFilter.hpp"
#include "Decibels.hpp"
#include "IIRFilter.hpp"
#include "MathConstants.hpp"
#include "MidSide.hpp"
#include "StateVariableFilter.hpp"

#include <cassert>

namespace am
{

template<typename T>
struct BoomParameter
{
    T boost{0};
    T frequency{40};
    T time{10};
};

template<typename T>
struct Boom
{
    using Parameter = BoomParameter<T>;

    Boom() = default;

    auto parameter(Parameter const& newParameter) -> void;

    auto prepare(ProcessSpec const& spec) -> void;

    auto process(AudioBuffer<T>& buffer) -> void;

    auto reset() -> void;

private:
    Parameter _parameter;
    ProcessSpec _spec{};

    SVFBandpass<T> _detectionFilter;
    BallisticsFilter<T> _detectionBallistics;
    SVFBell<T> _boostFilter{};
    T _minBoost{decibelsToGain(T{-10})};
    T _maxBoost{decibelsToGain(T{10})};
};

template<typename T>
auto Boom<T>::parameter(Parameter const& newParameter) -> void
{
    _parameter = newParameter;
    _detectionFilter.template setCutoffFrequency<true>(_parameter.frequency);
}

template<typename T>
auto Boom<T>::prepare(ProcessSpec const& spec) -> void
{
    assert(spec.numChannels == 2);
    _spec = spec;
    _detectionFilter.prepare({spec.sampleRate, spec.maximumBlockSize, 1U});
    _detectionBallistics.prepare({spec.sampleRate, spec.maximumBlockSize, 1U});
    _detectionBallistics.setLevelCalculationType(BallisticsFilterLevelCalculationType::peak);
    _boostFilter.prepare({spec.sampleRate, spec.maximumBlockSize, 1U});
}

template<typename T>
auto Boom<T>::process(AudioBuffer<T>& buffer) -> void
{
    _detectionBallistics.setAttackTime(_parameter.time);
    _detectionBallistics.setReleaseTime(_parameter.time);

    for (auto i = size_t{0}; i < buffer.numSamples(); ++i)
    {
        auto leftChannel  = buffer.channel(0);
        auto rightChannel = buffer.channel(1);

        auto const [originalMid, originalSide] = toMidSide(StereoFrame<T>{leftChannel[i], rightChannel[i]});

        auto const controlMid    = _detectionFilter.processSample(0, originalMid);
        auto const controlEnv    = _detectionBallistics.processSample(0, controlMid);
        auto const normalizedRMS = std::clamp(T(0.5) + controlEnv * (_parameter.boost * T{10}), T{0}, T{1});

        auto const boostGain = lerp(_minBoost, _maxBoost, normalizedRMS);
        _boostFilter.setGain(boostGain);

        auto const processedMid        = _boostFilter.processSample(0, originalMid);
        auto const [leftOut, rightOut] = toStereo(MidSideFrame<T>{processedMid, originalSide});

        leftChannel[i]  = leftOut;
        rightChannel[i] = rightOut;
    }

    _detectionFilter.snapToZero();
    // _detectionBallistics.snapToZero();
    _boostFilter.snapToZero();
}

template<typename T>
auto Boom<T>::reset() -> void
{
    _detectionFilter.reset();
    _detectionBallistics.reset();
    _boostFilter.reset();
}

}  // namespace am
