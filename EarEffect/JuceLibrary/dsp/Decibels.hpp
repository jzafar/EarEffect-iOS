#pragma once

#include <algorithm>
#include <cmath>

namespace am
{

template<typename T>
auto decibelsToGain(T decibels, T minusInfinityDb = T(-100)) noexcept -> T
{
    return decibels > minusInfinityDb ? std::pow(T(10.0), decibels * T(0.05)) : T();
}

template<typename T>
auto gainToDecibels(T gain, T minusInfinityDb = T(-100)) noexcept -> T
{
    return gain > T() ? std::max(minusInfinityDb, static_cast<T>(std::log10(gain)) * T(20.0)) : minusInfinityDb;
}

}  // namespace am
