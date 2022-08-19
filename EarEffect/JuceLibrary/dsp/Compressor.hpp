#pragma once

#include "AudioBuffer.hpp"
#include "ProcessSpec.hpp"
#include "StateVariableFilter.hpp"

#include <algorithm>

namespace am {
template<typename T>
struct Compressor
{
    using SampleType = T;

    struct Parameter
    {
        T cutoff{20};
        T threshold{0};
        T ratio{1};
        T knee{0};
        T attack{0};
        T release{0};
        T makeUp{0};
        T wet{0};
    };

    auto parameter(Parameter const& parameter) -> void;

    auto prepare(ProcessSpec const& spec) -> void;

    auto process(AudioBuffer<T>& buffer) -> void;

    auto reset() -> void;

private:
    using Filter = StateVariableFilter<T>;

    [[nodiscard]] auto calculateAttackOrRelease(T value) const noexcept -> T;

    ProcessSpec _spec{};
    Parameter _parameter{};

    T _ylPrev{};
    Filter _sideChainFilter{};
};

template<typename T>
auto Compressor<T>::parameter(Parameter const& newParameter) -> void
{
    _parameter = newParameter;
}

template<typename T>
auto Compressor<T>::prepare(ProcessSpec const& spec) -> void
{
    _spec = spec;

    _sideChainFilter.prepare({_spec.sampleRate, _spec.maximumBlockSize, 1U});
    reset();
}

template<typename T>
auto Compressor<T>::process(AudioBuffer<T>& buffer) -> void
{
    auto const numSamples  = buffer.numSamples();
    auto const numChannels = buffer.numChannels();

    _sideChainFilter.parameter({Filter::Type::highPass, _parameter.cutoff});

    auto const threshold = _parameter.threshold;
    auto const ratio     = _parameter.ratio > T{30} ? T{200} : _parameter.ratio;
    auto const knee      = _parameter.knee;
    auto const alphaA    = calculateAttackOrRelease(_parameter.attack * static_cast<T>(0.001));
    auto const alphaR    = calculateAttackOrRelease(_parameter.release * static_cast<T>(0.001));

    for (auto sampleIdx{0U}; sampleIdx < numSamples; ++sampleIdx) {
        auto mono = T{0};
        for (auto ch{0U}; ch < numChannels; ++ch) { mono += buffer(ch, sampleIdx); }
        mono /= static_cast<T>(numChannels);
        mono = _sideChainFilter.processSample(0, mono);

        auto const inputSquared = mono * mono;
        auto const env          = (inputSquared <= static_cast<T>(1e-6)) ? T{-60} : T{10} * std::log10(inputSquared);

        auto const halfKneeRange  = -(knee * (T{-60} - threshold) / T{4});
        auto const fullKneeRange  = halfKneeRange + halfKneeRange / ratio;
        auto const kneedThreshold = threshold - halfKneeRange;
        auto const ceilThreshold  = threshold + halfKneeRange / ratio;
        auto const limit          = std::clamp(env, kneedThreshold, ceilThreshold);
        auto const factor         = -((limit - kneedThreshold) / fullKneeRange) + T{1};
        auto const ratioQuotient  = knee > T{0} ? ratio * factor + T{1} * (-factor + T{1}) : T{1};

        auto yg = T{0};
        if (env < kneedThreshold) {
            yg = env;
        } else {
            yg = kneedThreshold + (env - kneedThreshold) / (ratio / ratioQuotient);
        }

        auto yl       = T{0};
        auto const xl = env - yg;
        if (xl > _ylPrev) {
            yl = alphaA * _ylPrev + (T{1} - alphaA) * xl;
        } else {
            yl = alphaR * _ylPrev + (T{1} - alphaR) * xl;
        }

        auto const controlCompressor = std::pow(T{10}, (T{1} - yl) * static_cast<T>(0.05));

        _ylPrev = yl;

        for (auto ch{0U}; ch < numChannels; ++ch) {
            auto const wet    = _parameter.wet;
            auto const makeup = _parameter.makeUp;

            auto const channelData = buffer.channel(ch);
            auto const wetSample   = channelData[sampleIdx] * controlCompressor * makeup;
            auto const drySample   = channelData[sampleIdx];

            buffer(ch, sampleIdx) = wetSample * wet + drySample * (T{1} - wet);
        }
    }
}

template<typename T>
auto Compressor<T>::reset() -> void
{
    _ylPrev = T{0};
}

template<typename T>
auto Compressor<T>::calculateAttackOrRelease(T value) const noexcept -> T
{
    auto const euler = static_cast<T>(2.71828182845904523536L);
    if (value == T{0}) { return T{0}; }
    return std::pow(T{1} / euler, T{1} / static_cast<T>(_spec.sampleRate) / value);
}

}  // namespace am
