#pragma once

#include <array>

namespace am
{
namespace IIR
{
template<typename T>
struct ArrayCoefficients
{
    static auto makeFirstOrderLowPass(double sampleRate, T frequency) -> std::array<T, 4>;
    static auto makeFirstOrderHighPass(double sampleRate, T frequency) -> std::array<T, 4>;
    static auto makeFirstOrderAllPass(double sampleRate, T frequency) -> std::array<T, 4>;
    static auto makeLowPass(double sampleRate, T frequency) -> std::array<T, 6>;
    static auto makeLowPass(double sampleRate, T frequency, T Q) -> std::array<T, 6>;
    static auto makeHighPass(double sampleRate, T frequency) -> std::array<T, 6>;
    static auto makeHighPass(double sampleRate, T frequency, T Q) -> std::array<T, 6>;
    static auto makeBandPass(double sampleRate, T frequency) -> std::array<T, 6>;
    static auto makeBandPass(double sampleRate, T frequency, T Q) -> std::array<T, 6>;
    static auto makeNotch(double sampleRate, T frequency) -> std::array<T, 6>;
    static auto makeNotch(double sampleRate, T frequency, T Q) -> std::array<T, 6>;
    static auto makeAllPass(double sampleRate, T frequency) -> std::array<T, 6>;
    static auto makeAllPass(double sampleRate, T frequency, T Q) -> std::array<T, 6>;
    static auto makeLowShelf(double sampleRate, T cutOffFrequency, T Q, T gainFactor) -> std::array<T, 6>;
    static auto makeHighShelf(double sampleRate, T cutOffFrequency, T Q, T gainFactor) -> std::array<T, 6>;
    static auto makePeakFilter(double sampleRate, T centreFrequency, T Q, T gainFactor) -> std::array<T, 6>;

private:
    static constexpr T inverseRootTwo = static_cast<T>(0.70710678118654752440L);
};
}  // namespace IIR

}  // namespace am
