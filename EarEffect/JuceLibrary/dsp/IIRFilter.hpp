#pragma once

#include "Coefficients.hpp"
#include "ProcessSpec.hpp"

#include <cassert>
#include <vector>

namespace am
{

namespace util
{
inline void snapToZero(float& x) noexcept
{
    if (!(x < -1.0e-8f || x > 1.0e-8f)) x = 0;
}
inline void snapToZero(double& x) noexcept
{
    if (!(x < -1.0e-8f || x > 1.0e-8f)) x = 0;
}
inline void snapToZero(long double& x) noexcept
{
    if (!(x < -1.0e-8f || x > 1.0e-8f)) x = 0;
}
}  // namespace util

namespace IIR
{

template<typename T>
class Filter
{
public:
    using CoefficientsPtr = typename Coefficients<T>::Ptr;

    Filter();
    Filter(CoefficientsPtr coefficientsToUse);

    Filter(Filter const&)            = default;
    Filter(Filter&&)                 = default;
    Filter& operator=(Filter const&) = default;
    Filter& operator=(Filter&&)      = default;

    CoefficientsPtr coefficients;

    void reset() { reset(T{0}); }
    void reset(T resetToValue);

    void prepare(ProcessSpec const&) noexcept;

    template<typename ProcessContext>
    void process(ProcessContext const& context) noexcept
    {
        if (context.isBypassed)
            processInternal<ProcessContext, true>(context);
        else
            processInternal<ProcessContext, false>(context);

#if JUCE_DSP_ENABLE_SNAP_TO_ZERO
        snapToZero();
#endif
    }

    T processSample(T sample) noexcept;

    void snapToZero() noexcept;

private:
    void check();

    /** Processes a block of samples */
    template<typename ProcessContext, bool isBypassed>
    void processInternal(ProcessContext const& context) noexcept;

    std::vector<T> memory;
    T* state     = nullptr;
    size_t order = 0;
};

template<typename T>
template<typename ProcessContext, bool bypassed>
void Filter<T>::processInternal(ProcessContext const& context) noexcept
{
    static_assert(std::is_same<typename ProcessContext::T, T>::value,
                  "The sample-type of the IIR filter must match the sample-type supplied to this process callback");
    check();

    auto&& inputBlock  = context.getInputBlock();
    auto&& outputBlock = context.getOutputBlock();

    // This class can only process mono signals. Use the ProcessorDuplicator class
    // to apply this filter on a multi-channel audio stream.
    assert(inputBlock.getNumChannels() == 1);
    assert(outputBlock.getNumChannels() == 1);

    auto numSamples = inputBlock.getNumSamples();
    auto* src       = inputBlock.getChannelPointer(0);
    auto* dst       = outputBlock.getChannelPointer(0);
    auto* coeffs    = coefficients->getRawCoefficients();

    switch (order)
    {
        case 1:
        {
            auto b0 = coeffs[0];
            auto b1 = coeffs[1];
            auto a1 = coeffs[2];

            auto lv1 = state[0];

            for (size_t i = 0; i < numSamples; ++i)
            {
                auto input  = src[i];
                auto output = input * b0 + lv1;

                dst[i] = bypassed ? input : output;

                lv1 = (input * b1) - (output * a1);
            }

            util::snapToZero(lv1);
            state[0] = lv1;
        }
        break;

        case 2:
        {
            auto b0 = coeffs[0];
            auto b1 = coeffs[1];
            auto b2 = coeffs[2];
            auto a1 = coeffs[3];
            auto a2 = coeffs[4];

            auto lv1 = state[0];
            auto lv2 = state[1];

            for (size_t i = 0; i < numSamples; ++i)
            {
                auto input  = src[i];
                auto output = (input * b0) + lv1;
                dst[i]      = bypassed ? input : output;

                lv1 = (input * b1) - (output * a1) + lv2;
                lv2 = (input * b2) - (output * a2);
            }

            util::snapToZero(lv1);
            state[0] = lv1;
            util::snapToZero(lv2);
            state[1] = lv2;
        }
        break;

        case 3:
        {
            auto b0 = coeffs[0];
            auto b1 = coeffs[1];
            auto b2 = coeffs[2];
            auto b3 = coeffs[3];
            auto a1 = coeffs[4];
            auto a2 = coeffs[5];
            auto a3 = coeffs[6];

            auto lv1 = state[0];
            auto lv2 = state[1];
            auto lv3 = state[2];

            for (size_t i = 0; i < numSamples; ++i)
            {
                auto input  = src[i];
                auto output = (input * b0) + lv1;
                dst[i]      = bypassed ? input : output;

                lv1 = (input * b1) - (output * a1) + lv2;
                lv2 = (input * b2) - (output * a2) + lv3;
                lv3 = (input * b3) - (output * a3);
            }

            util::snapToZero(lv1);
            state[0] = lv1;
            util::snapToZero(lv2);
            state[1] = lv2;
            util::snapToZero(lv3);
            state[2] = lv3;
        }
        break;

        default:
        {
            for (size_t i = 0; i < numSamples; ++i)
            {
                auto input  = src[i];
                auto output = (input * coeffs[0]) + state[0];
                dst[i]      = bypassed ? input : output;

                for (size_t j = 0; j < order - 1; ++j)
                    state[j] = (input * coeffs[j + 1]) - (output * coeffs[order + j + 1]) + state[j + 1];

                state[order - 1] = (input * coeffs[order]) - (output * coeffs[order * 2]);
            }

            snapToZero();
        }
    }
}

}  // namespace IIR
}  // namespace am
