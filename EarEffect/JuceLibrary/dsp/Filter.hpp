#pragma once

#include "AudioBuffer.hpp"
#include "FilterType.hpp"
#include "IIRFilter.hpp"
#include "ProcessSpec.hpp"
#include "ProcessorDuplicator.hpp"

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
    using Band = ProcessorDuplicator<T, IIR::Filter<T>, IIR::Coefficients<T>>;

    std::mutex _mutex{};
    Band _filter{};
    ProcessSpec _spec{44'100, 512, 2};
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

    auto const emptyCoeffs = std::array{1.0F, 1.0F, 1.0F, 1.0F, 1.0F, 1.0F};

    std::lock_guard<std::mutex> lock{_mutex};
    *_filter.state = coeffs;
    _filter.reset();
}

template<typename T>
auto Filter<T>::prepare(ProcessSpec const& spec) -> void
{
    std::lock_guard<std::mutex> lock{_mutex};
    _spec = spec;

    _filter.prepare(spec);
    _filter.reset();
}

template<typename T>
auto Filter<T>::process(AudioBuffer<T>& buffer) -> void
{
    std::lock_guard<std::mutex> lock{_mutex};
    // assert(!containsInvalidFloats(buffer));

    for (auto i = size_t{}; i < buffer.numSamples(); ++i)
    {
        buffer(0, i) = _filter.processSample(0, buffer(0, i));
        buffer(1, i) = _filter.processSample(1, buffer(1, i));
    }

    // _filter.snapToZero();
}

template<typename T>
auto Filter<T>::reset() -> void
{
    std::lock_guard<std::mutex> lock{_mutex};

    _filter.reset();
}
}  // namespace am
