#pragma once

#include "ArrayCoefficients.hpp"

#include <array>
#include <memory>
#include <vector>

namespace am
{
namespace IIR
{

template<typename T>
struct Coefficients
{
    Coefficients();
    Coefficients(T b0, T b1, T a0, T a1);
    Coefficients(T b0, T b1, T b2, T a0, T a1, T a2);
    Coefficients(T b0, T b1, T b2, T b3, T a0, T a1, T a2, T a3);

    template<size_t Num>
    explicit Coefficients(std::array<T, Num> const& values)
    {
        assignImpl<Num>(values.data());
    }

    template<size_t Num>
    Coefficients& operator=(std::array<T, Num> const& values)
    {
        return assignImpl<Num>(values.data());
    }

    Coefficients(Coefficients const&)            = default;
    Coefficients(Coefficients&&)                 = default;
    Coefficients& operator=(Coefficients const&) = default;
    Coefficients& operator=(Coefficients&&)      = default;

    using Ptr = std::shared_ptr<Coefficients>;

    static auto makeFirstOrderLowPass(double sampleRate, T frequency) -> Ptr;
    static auto makeFirstOrderHighPass(double sampleRate, T frequency) -> Ptr;
    static auto makeFirstOrderAllPass(double sampleRate, T frequency) -> Ptr;
    static auto makeLowPass(double sampleRate, T frequency) -> Ptr;
    static auto makeLowPass(double sampleRate, T frequency, T Q) -> Ptr;
    static auto makeHighPass(double sampleRate, T frequency) -> Ptr;
    static auto makeHighPass(double sampleRate, T frequency, T Q) -> Ptr;
    static auto makeBandPass(double sampleRate, T frequency) -> Ptr;
    static auto makeBandPass(double sampleRate, T frequency, T Q) -> Ptr;
    static auto makeNotch(double sampleRate, T frequency) -> Ptr;
    static auto makeNotch(double sampleRate, T frequency, T Q) -> Ptr;
    static auto makeAllPass(double sampleRate, T frequency) -> Ptr;
    static auto makeAllPass(double sampleRate, T frequency, T Q) -> Ptr;
    static auto makeLowShelf(double sampleRate, T cutOffFrequency, T Q, T gainFactor) -> Ptr;
    static auto makeHighShelf(double sampleRate, T cutOffFrequency, T Q, T gainFactor) -> Ptr;
    static auto makePeakFilter(double sampleRate, T centreFrequency, T Q, T gainFactor) -> Ptr;

    size_t getFilterOrder() const noexcept;

    T* getRawCoefficients() noexcept { return coefficients.data(); }

    T const* getRawCoefficients() const noexcept { return coefficients.data(); }

    std::vector<T> coefficients;

private:
    using ArrayCoeffs = ArrayCoefficients<T>;

    template<size_t Num>
    Coefficients& assignImpl(T const* values);

    template<size_t Num>
    Coefficients& assign(const T (&values)[Num])
    {
        return assignImpl<Num>(values);
    }
};

}  // namespace IIR

}  // namespace am
