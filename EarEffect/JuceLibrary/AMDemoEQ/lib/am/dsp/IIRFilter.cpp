#include "IIRFilter.hpp"

namespace am
{
namespace IIR
{

template<typename NumericType>
std::array<NumericType, 4> ArrayCoefficients<NumericType>::makeFirstOrderLowPass(double sampleRate,
                                                                                 NumericType frequency)
{
    assert(sampleRate > 0.0);
    assert(frequency > 0 && frequency <= static_cast<float>(sampleRate * 0.5));

    auto n = std::tan(MathConstants<NumericType>::pi * frequency / static_cast<NumericType>(sampleRate));

    return {{n, n, n + 1, n - 1}};
}

template<typename NumericType>
std::array<NumericType, 4> ArrayCoefficients<NumericType>::makeFirstOrderHighPass(double sampleRate,
                                                                                  NumericType frequency)
{
    assert(sampleRate > 0.0);
    assert(frequency > 0 && frequency <= static_cast<float>(sampleRate * 0.5));

    auto n = std::tan(MathConstants<NumericType>::pi * frequency / static_cast<NumericType>(sampleRate));

    return {{1, -1, n + 1, n - 1}};
}

template<typename NumericType>
std::array<NumericType, 4> ArrayCoefficients<NumericType>::makeFirstOrderAllPass(double sampleRate,
                                                                                 NumericType frequency)
{
    assert(sampleRate > 0.0);
    assert(frequency > 0 && frequency <= static_cast<float>(sampleRate * 0.5));

    auto n = std::tan(MathConstants<NumericType>::pi * frequency / static_cast<NumericType>(sampleRate));

    return {{n - 1, n + 1, n + 1, n - 1}};
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeLowPass(double sampleRate, NumericType frequency)
{
    return makeLowPass(sampleRate, frequency, inverseRootTwo);
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeLowPass(double sampleRate, NumericType frequency,
                                                                       NumericType Q)
{
    assert(sampleRate > 0.0);
    assert(frequency > 0 && frequency <= static_cast<float>(sampleRate * 0.5));
    assert(Q > 0.0);

    auto n        = 1 / std::tan(MathConstants<NumericType>::pi * frequency / static_cast<NumericType>(sampleRate));
    auto nSquared = n * n;
    auto invQ     = 1 / Q;
    auto c1       = 1 / (1 + invQ * n + nSquared);

    return {{c1, c1 * 2, c1, 1, c1 * 2 * (1 - nSquared), c1 * (1 - invQ * n + nSquared)}};
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeHighPass(double sampleRate, NumericType frequency)
{
    return makeHighPass(sampleRate, frequency, inverseRootTwo);
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeHighPass(double sampleRate, NumericType frequency,
                                                                        NumericType Q)
{
    assert(sampleRate > 0.0);
    assert(frequency > 0 && frequency <= static_cast<float>(sampleRate * 0.5));
    assert(Q > 0.0);

    auto n        = std::tan(MathConstants<NumericType>::pi * frequency / static_cast<NumericType>(sampleRate));
    auto nSquared = n * n;
    auto invQ     = 1 / Q;
    auto c1       = 1 / (1 + invQ * n + nSquared);

    return {{c1, c1 * -2, c1, 1, c1 * 2 * (nSquared - 1), c1 * (1 - invQ * n + nSquared)}};
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeBandPass(double sampleRate, NumericType frequency)
{
    return makeBandPass(sampleRate, frequency, inverseRootTwo);
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeBandPass(double sampleRate, NumericType frequency,
                                                                        NumericType Q)
{
    assert(sampleRate > 0.0);
    assert(frequency > 0 && frequency <= static_cast<float>(sampleRate * 0.5));
    assert(Q > 0.0);

    auto n        = 1 / std::tan(MathConstants<NumericType>::pi * frequency / static_cast<NumericType>(sampleRate));
    auto nSquared = n * n;
    auto invQ     = 1 / Q;
    auto c1       = 1 / (1 + invQ * n + nSquared);

    return {{c1 * n * invQ, 0, -c1 * n * invQ, 1, c1 * 2 * (1 - nSquared), c1 * (1 - invQ * n + nSquared)}};
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeNotch(double sampleRate, NumericType frequency)
{
    return makeNotch(sampleRate, frequency, inverseRootTwo);
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeNotch(double sampleRate, NumericType frequency,
                                                                     NumericType Q)
{
    assert(sampleRate > 0.0);
    assert(frequency > 0 && frequency <= static_cast<float>(sampleRate * 0.5));
    assert(Q > 0.0);

    auto n        = 1 / std::tan(MathConstants<NumericType>::pi * frequency / static_cast<NumericType>(sampleRate));
    auto nSquared = n * n;
    auto invQ     = 1 / Q;
    auto c1       = 1 / (1 + n * invQ + nSquared);
    auto b0       = c1 * (1 + nSquared);
    auto b1       = 2 * c1 * (1 - nSquared);

    return {{b0, b1, b0, 1, b1, c1 * (1 - n * invQ + nSquared)}};
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeAllPass(double sampleRate, NumericType frequency)
{
    return makeAllPass(sampleRate, frequency, inverseRootTwo);
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeAllPass(double sampleRate, NumericType frequency,
                                                                       NumericType Q)
{
    assert(sampleRate > 0);
    assert(frequency > 0 && frequency <= sampleRate * 0.5);
    assert(Q > 0);

    auto n        = 1 / std::tan(MathConstants<NumericType>::pi * frequency / static_cast<NumericType>(sampleRate));
    auto nSquared = n * n;
    auto invQ     = 1 / Q;
    auto c1       = 1 / (1 + invQ * n + nSquared);
    auto b0       = c1 * (1 - n * invQ + nSquared);
    auto b1       = c1 * 2 * (1 - nSquared);

    return {{b0, b1, 1, 1, b1, b0}};
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeLowShelf(double sampleRate, NumericType cutOffFrequency,
                                                                        NumericType Q, NumericType gainFactor)
{
    assert(sampleRate > 0.0);
    assert(cutOffFrequency > 0.0 && cutOffFrequency <= sampleRate * 0.5);
    assert(Q > 0.0);

    auto A       = std::max(static_cast<NumericType>(0.0), std::sqrt(gainFactor));
    auto aminus1 = A - 1;
    auto aplus1  = A + 1;
    auto omega   = (2 * MathConstants<NumericType>::pi * std::max(cutOffFrequency, static_cast<NumericType>(2.0)))
                 / static_cast<NumericType>(sampleRate);
    auto coso             = std::cos(omega);
    auto beta             = std::sin(omega) * std::sqrt(A) / Q;
    auto aminus1TimesCoso = aminus1 * coso;

    return {{A * (aplus1 - aminus1TimesCoso + beta), A * 2 * (aminus1 - aplus1 * coso),
             A * (aplus1 - aminus1TimesCoso - beta), aplus1 + aminus1TimesCoso + beta, -2 * (aminus1 + aplus1 * coso),
             aplus1 + aminus1TimesCoso - beta}};
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makeHighShelf(double sampleRate, NumericType cutOffFrequency,
                                                                         NumericType Q, NumericType gainFactor)
{
    assert(sampleRate > 0);
    assert(cutOffFrequency > 0 && cutOffFrequency <= static_cast<NumericType>(sampleRate * 0.5));
    assert(Q > 0);

    auto A       = std::max(static_cast<NumericType>(0.0), std::sqrt(gainFactor));
    auto aminus1 = A - 1;
    auto aplus1  = A + 1;
    auto omega   = (2 * MathConstants<NumericType>::pi * std::max(cutOffFrequency, static_cast<NumericType>(2.0)))
                 / static_cast<NumericType>(sampleRate);
    auto coso             = std::cos(omega);
    auto beta             = std::sin(omega) * std::sqrt(A) / Q;
    auto aminus1TimesCoso = aminus1 * coso;

    return {{A * (aplus1 + aminus1TimesCoso + beta), A * -2 * (aminus1 + aplus1 * coso),
             A * (aplus1 + aminus1TimesCoso - beta), aplus1 - aminus1TimesCoso + beta, 2 * (aminus1 - aplus1 * coso),
             aplus1 - aminus1TimesCoso - beta}};
}

template<typename NumericType>
std::array<NumericType, 6> ArrayCoefficients<NumericType>::makePeakFilter(double sampleRate, NumericType frequency,
                                                                          NumericType Q, NumericType gainFactor)
{
    assert(sampleRate > 0);
    assert(frequency > 0 && frequency <= static_cast<NumericType>(sampleRate * 0.5));
    assert(Q > 0);
    assert(gainFactor > 0);

    auto A     = std::max(static_cast<NumericType>(0.0), std::sqrt(gainFactor));
    auto omega = (2 * MathConstants<NumericType>::pi * std::max(frequency, static_cast<NumericType>(2.0)))
                 / static_cast<NumericType>(sampleRate);
    auto alpha       = std::sin(omega) / (Q * 2);
    auto c2          = -2 * std::cos(omega);
    auto alphaTimesA = alpha * A;
    auto alphaOverA  = alpha / A;

    return {{1 + alphaTimesA, c2, 1 - alphaTimesA, 1 + alphaOverA, c2, 1 - alphaOverA}};
}

template struct ArrayCoefficients<float>;
template struct ArrayCoefficients<double>;
}  // namespace IIR
}  // namespace am
