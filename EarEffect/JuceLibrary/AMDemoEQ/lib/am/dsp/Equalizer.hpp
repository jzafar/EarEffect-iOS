#pragma once

#include "Filter.hpp"

#include <array>

namespace am
{

template<typename T>
struct Equalizer
{
    inline static constexpr auto numBands = std::size_t{6};
    using SampleType                      = T;
    using Parameter                       = std::array<typename Filter<SampleType>::Parameter, numBands>;

    Equalizer() = default;

    auto parameter(Parameter const& params) -> void;

    auto prepare(ProcessSpec const& spec) -> void;

    auto process(AudioBuffer<SampleType>& buffer) -> void;

    auto reset() -> void;

private:
    using FilterBand = Filter<SampleType>;
    using Filters    = std::array<FilterBand, 6>;
    Filters _filters;
};

template<typename T>
auto Equalizer<T>::parameter(Parameter const& params) -> void
{
    std::get<0>(_filters).parameter(params[0]);
    std::get<1>(_filters).parameter(params[1]);
    std::get<2>(_filters).parameter(params[2]);
    std::get<3>(_filters).parameter(params[3]);
    std::get<4>(_filters).parameter(params[4]);
    std::get<5>(_filters).parameter(params[5]);
}

template<typename T>
auto Equalizer<T>::prepare(ProcessSpec const& spec) -> void
{
    for (auto& f : _filters) { f.prepare(spec); }
}

template<typename T>
auto Equalizer<T>::process(AudioBuffer<T>& buffer) -> void
{

    for (auto& f : _filters) { f.process(buffer); }
}

template<typename T>
auto Equalizer<T>::reset() -> void
{
    for (auto& f : _filters) { f.reset(); }
}
}  // namespace am
