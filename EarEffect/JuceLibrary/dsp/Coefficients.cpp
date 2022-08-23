#include "Coefficients.hpp"

#include <algorithm>
#include <cassert>
#include <cmath>

namespace am
{

namespace IIR
{

template<typename T>
Coefficients<T>::Coefficients()
{
    assign({T(), T(), T(), T(), T(), T()});
}

template<typename T>
Coefficients<T>::Coefficients(T b0, T b1, T a0, T a1)
{
    assign({b0, b1, a0, a1});
}

template<typename T>
Coefficients<T>::Coefficients(T b0, T b1, T b2, T a0, T a1, T a2)
{
    assign({b0, b1, b2, a0, a1, a2});
}

template<typename T>
Coefficients<T>::Coefficients(T b0, T b1, T b2, T b3, T a0, T a1, T a2, T a3)
{
    assign({b0, b1, b2, b3, a0, a1, a2, a3});
}

template<typename T>
auto Coefficients<T>::makeFirstOrderLowPass(double sampleRate, T frequency) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeFirstOrderLowPass(sampleRate, frequency));
}

template<typename T>
auto Coefficients<T>::makeFirstOrderHighPass(double sampleRate, T frequency) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeFirstOrderHighPass(sampleRate, frequency));
}

template<typename T>
auto Coefficients<T>::makeFirstOrderAllPass(double sampleRate, T frequency) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeFirstOrderAllPass(sampleRate, frequency));
}

template<typename T>
auto Coefficients<T>::makeLowPass(double sampleRate, T frequency) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeLowPass(sampleRate, frequency));
}

template<typename T>
auto Coefficients<T>::makeLowPass(double sampleRate, T frequency, T Q) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeLowPass(sampleRate, frequency, Q));
}

template<typename T>
auto Coefficients<T>::makeHighPass(double sampleRate, T frequency) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeHighPass(sampleRate, frequency));
}

template<typename T>
auto Coefficients<T>::makeHighPass(double sampleRate, T frequency, T Q) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeHighPass(sampleRate, frequency, Q));
}

template<typename T>
auto Coefficients<T>::makeBandPass(double sampleRate, T frequency) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeBandPass(sampleRate, frequency));
}

template<typename T>
auto Coefficients<T>::makeBandPass(double sampleRate, T frequency, T Q) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeBandPass(sampleRate, frequency, Q));
}

template<typename T>
auto Coefficients<T>::makeNotch(double sampleRate, T frequency) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeNotch(sampleRate, frequency));
}

template<typename T>
auto Coefficients<T>::makeNotch(double sampleRate, T frequency, T Q) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeNotch(sampleRate, frequency, Q));
}

template<typename T>
auto Coefficients<T>::makeAllPass(double sampleRate, T frequency) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeAllPass(sampleRate, frequency));
}

template<typename T>
auto Coefficients<T>::makeAllPass(double sampleRate, T frequency, T Q) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeAllPass(sampleRate, frequency, Q));
}

template<typename T>
auto Coefficients<T>::makeLowShelf(double sampleRate, T cutOffFrequency, T Q, T gainFactor) ->
    typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeLowShelf(sampleRate, cutOffFrequency, Q, gainFactor));
}

template<typename T>
auto Coefficients<T>::makeHighShelf(double sampleRate, T cutOffFrequency, T Q, T gainFactor) ->
    typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makeHighShelf(sampleRate, cutOffFrequency, Q, gainFactor));
}

template<typename T>
auto Coefficients<T>::makePeakFilter(double sampleRate, T frequency, T Q, T gainFactor) -> typename Coefficients<T>::Ptr
{
    return std::make_shared<Coefficients>(ArrayCoeffs::makePeakFilter(sampleRate, frequency, Q, gainFactor));
}

template<typename T>
size_t Coefficients<T>::getFilterOrder() const noexcept
{
    return (static_cast<size_t>(coefficients.size()) - 1) / 2;
}

template<typename T>
template<size_t Num>
Coefficients<T>& Coefficients<T>::assignImpl(T const* values)
{
    static_assert(Num % 2 == 0, "Must supply an even number of coefficients");
    auto const a0Index = Num / 2;
    auto const a0      = values[a0Index];
    auto const a0Inv   = a0 != T() ? static_cast<T>(1) / values[a0Index] : T();

    coefficients.clear();
    coefficients.reserve(std::max((size_t)8, Num));

    for (size_t i = 0; i < Num; ++i)
        if (i != a0Index) coefficients.push_back(values[i] * a0Inv);

    return *this;
}

template struct Coefficients<float>;
template struct Coefficients<double>;

}  // namespace IIR

}  // namespace am