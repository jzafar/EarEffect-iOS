#pragma once

#include "ProcessSpec.hpp"

#include <cassert>
#include <cmath>

namespace am
{

enum struct StateVariableFilterType
{
    lowPass,
    bandPass,
    highPass
};

template<typename T>
struct StateVariableFilterParameter
{
    StateVariableFilterType type{StateVariableFilterType::lowPass};
    T cutoff{static_cast<T>(1000.0)};
    T resonance{static_cast<T>(1.0 / std::sqrt(2.0))};
};

template<typename T>
struct StateVariableFilter
{
    using Type      = StateVariableFilterType;
    using Parameter = StateVariableFilterParameter<T>;

    StateVariableFilter();

    void parameter(Parameter newParameter);

    void prepare(ProcessSpec const& spec);
    void reset();
    void reset(T newValue);

    T processSample(int channel, T inputValue);

private:
    void update();

    T g, h, R2;
    std::vector<T> s1{2}, s2{2};

    double _sampleRate = 44100.0;
    Parameter _parameter;
};

template<typename T>
StateVariableFilter<T>::StateVariableFilter()
{
    update();
}

template<typename T>
void StateVariableFilter<T>::parameter(Parameter newParameter)
{
    _parameter = newParameter;
    update();
}

template<typename T>
void StateVariableFilter<T>::prepare(ProcessSpec const& spec)
{
    assert(spec.sampleRate > 0);
    assert(spec.numChannels > 0);

    _sampleRate = spec.sampleRate;

    s1.resize(spec.numChannels);
    s2.resize(spec.numChannels);

    reset();
    update();
}

template<typename T>
void StateVariableFilter<T>::reset()
{
    for (auto v : {&s1, &s2}) std::fill(v->begin(), v->end(), static_cast<T>(0));
}

template<typename T>
T StateVariableFilter<T>::processSample(int channel, T inputValue)
{
    auto& ls1 = s1[(size_t)channel];
    auto& ls2 = s2[(size_t)channel];

    auto yHP = h * (inputValue - ls1 * (g + R2) - ls2);

    auto yBP = yHP * g + ls1;
    ls1      = yHP * g + yBP;

    auto yLP = yBP * g + ls2;
    ls2      = yBP * g + yLP;

    switch (_parameter.type)
    {
        case Type::lowPass: return yLP;
        case Type::bandPass: return yBP;
        case Type::highPass: return yHP;
        default: return yLP;
    }
}

template<typename T>
void StateVariableFilter<T>::update()
{
    auto const pi = static_cast<T>(3.141592653589793238L);
    g             = static_cast<T>(std::tan(pi * _parameter.cutoff / _sampleRate));
    R2            = static_cast<T>(1.0 / _parameter.resonance);
    h             = static_cast<T>(1.0 / (1.0 + R2 * g + g * g));
}

}  // namespace am
