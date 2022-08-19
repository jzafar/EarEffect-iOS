#pragma once

#include "AudioBuffer.hpp"
#include "FilterType.hpp"
#include "IIRFilter.hpp"
#include "ProcessSpec.hpp"

#include <mutex>

namespace am
{

template<typename T>
struct Filter
{
    using SampleType = T;

    struct Parameter
    {
        FilterType type{FilterType::Peak};
        SampleType frequency{1'000};
        SampleType gain{1};
        SampleType quality{static_cast<SampleType>(0.707)};
    };

    Filter() = default;

    auto parameter(Parameter const& parameter) -> void;

    auto prepare(ProcessSpec const& spec) -> void;

    auto process(AudioBuffer<SampleType>& buffer) -> void;

    auto reset() -> void;

private:
    using Band = std::array<typename IIR::Filter<SampleType>, 2>;

    std::mutex _mutex{};
    Band _filter{};
    ProcessSpec _spec{};
};

template<typename T>
auto Filter<T>::parameter(Parameter const& p) -> void
{
    auto const coeffs = [p, sr = _spec.sampleRate]
    {
        using Coeffs = typename IIR::ArrayCoefficients<SampleType>;
        switch (p.type)
        {
            case FilterType::LowPass: return Coeffs::makeLowPass(sr, p.frequency, p.quality);
            case FilterType::HighPass: return Coeffs::makeHighPass(sr, p.frequency, p.quality);
            case FilterType::Notch: return Coeffs::makeNotch(sr, p.frequency, p.quality);
            case FilterType::Peak: return Coeffs::makePeakFilter(sr, p.frequency, p.quality, p.gain);
            case FilterType::LowShelf: return Coeffs::makeLowShelf(sr, p.frequency, p.quality, p.gain);
            case FilterType::HighShelf: return Coeffs::makeHighShelf(sr, p.frequency, p.quality, p.gain);
        }

        assert(false);
        return Coeffs::makePeakFilter(sr, 1'000.0F, 0.707F, 1.0F);
    }();

    std::lock_guard<std::mutex> lock{_mutex};
    _filter[0].coefficients = coeffs;
    _filter[1].coefficients = coeffs;
}

template<typename T>
auto Filter<T>::prepare(ProcessSpec const& spec) -> void
{
    _spec = spec;
    _filter[0].prepare(spec);
    _filter[1].prepare(spec);
}

template<typename T>
auto Filter<T>::process(AudioBuffer<T>& buffer) -> void
{
    for (auto i = size_t{}; i < buffer.numSamples(); ++i)
    {
        buffer(0, i) = _filter[0].processSample(buffer(0, i));
        buffer(1, i) = _filter[0].processSample(buffer(1, i));
    }
}

template<typename T>
auto Filter<T>::reset() -> void
{
    _filter[0].reset();
    _filter[1].reset();
}
}  // namespace am
