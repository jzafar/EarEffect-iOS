#pragma once

#include "MathConstants.hpp"
#include "ProcessSpec.hpp"

#include <algorithm>
#include <array>
#include <cassert>
#include <vector>
#include <cmath>

namespace am
{

/**
    Classes for IIR filter processing.
*/
namespace IIR
{
/** A set of coefficients for use in an Filter object.

    @tags{DSP}
*/
template<typename NumericType>
struct ArrayCoefficients
{
    /** Returns the coefficients for a first order low-pass filter. */
    static std::array<NumericType, 4> makeFirstOrderLowPass(double sampleRate, NumericType frequency);

    /** Returns the coefficients for a first order high-pass filter. */
    static std::array<NumericType, 4> makeFirstOrderHighPass(double sampleRate, NumericType frequency);

    /** Returns the coefficients for a first order all-pass filter. */
    static std::array<NumericType, 4> makeFirstOrderAllPass(double sampleRate, NumericType frequency);

    /** Returns the coefficients for a low-pass filter. */
    static std::array<NumericType, 6> makeLowPass(double sampleRate, NumericType frequency);

    /** Returns the coefficients for a low-pass filter with variable Q. */
    static std::array<NumericType, 6> makeLowPass(double sampleRate, NumericType frequency, NumericType Q);

    /** Returns the coefficients for a high-pass filter. */
    static std::array<NumericType, 6> makeHighPass(double sampleRate, NumericType frequency);

    /** Returns the coefficients for a high-pass filter with variable Q. */
    static std::array<NumericType, 6> makeHighPass(double sampleRate, NumericType frequency, NumericType Q);

    /** Returns the coefficients for a band-pass filter. */
    static std::array<NumericType, 6> makeBandPass(double sampleRate, NumericType frequency);

    /** Returns the coefficients for a band-pass filter with variable Q. */
    static std::array<NumericType, 6> makeBandPass(double sampleRate, NumericType frequency, NumericType Q);

    /** Returns the coefficients for a notch filter. */
    static std::array<NumericType, 6> makeNotch(double sampleRate, NumericType frequency);

    /** Returns the coefficients for a notch filter with variable Q. */
    static std::array<NumericType, 6> makeNotch(double sampleRate, NumericType frequency, NumericType Q);

    /** Returns the coefficients for an all-pass filter. */
    static std::array<NumericType, 6> makeAllPass(double sampleRate, NumericType frequency);

    /** Returns the coefficients for an all-pass filter with variable Q. */
    static std::array<NumericType, 6> makeAllPass(double sampleRate, NumericType frequency, NumericType Q);

    /** Returns the coefficients for a low-pass shelf filter with variable Q and gain.

        The gain is a scale factor that the low frequencies are multiplied by, so values
        greater than 1.0 will boost the low frequencies, values less than 1.0 will
        attenuate them.
    */
    static std::array<NumericType, 6> makeLowShelf(double sampleRate, NumericType cutOffFrequency, NumericType Q,
                                                   NumericType gainFactor);

    /** Returns the coefficients for a high-pass shelf filter with variable Q and gain.

        The gain is a scale factor that the high frequencies are multiplied by, so values
        greater than 1.0 will boost the high frequencies, values less than 1.0 will
        attenuate them.
    */
    static std::array<NumericType, 6> makeHighShelf(double sampleRate, NumericType cutOffFrequency, NumericType Q,
                                                    NumericType gainFactor);

    /** Returns the coefficients for a peak filter centred around a
        given frequency, with a variable Q and gain.

        The gain is a scale factor that the centre frequencies are multiplied by, so
        values greater than 1.0 will boost the centre frequencies, values less than
        1.0 will attenuate them.
    */
    static std::array<NumericType, 6> makePeakFilter(double sampleRate, NumericType centreFrequency, NumericType Q,
                                                     NumericType gainFactor);

private:
    // Unfortunately, std::sqrt is not marked as constexpr just yet in all compilers
    static constexpr NumericType inverseRootTwo = static_cast<NumericType>(0.70710678118654752440L);
};

/**
    A processing class that can perform IIR filtering on an audio signal, using
    the Transposed Direct Form II digital structure.

    If you need a lowpass, bandpass or highpass filter with fast modulation of
    its cutoff frequency, you might use the class StateVariableFilter instead,
    which is designed to prevent artefacts at parameter changes, instead of the
    class Filter.

    @see Filter::Coefficients, FilterAudioSource, StateVariableFilter

    @tags{DSP}
*/
template<typename SampleType>
class Filter
{
public:
    /** The NumericType is the underlying primitive type used by the SampleType (which
        could be either a primitive or vector)
    */
    using NumericType = SampleType;

    /** Creates a filter.

        Initially the filter is inactive, so will have no effect on samples that
        you process with it. You can modify the coefficients member to turn it into
        the type of filter needed.
    */
    Filter();

    Filter(Filter const&)            = default;
    Filter(Filter&&)                 = default;
    Filter& operator=(Filter const&) = default;
    Filter& operator=(Filter&&)      = default;

    /** The coefficients of the IIR filter. It's up to the caller to ensure that
        these coefficients are modified in a thread-safe way.

        If you change the order of the coefficients then you must call reset after
        modifying them.
    */
    std::array<SampleType, 6> coefficients;

    /** Resets the filter's processing pipeline, ready to start a new stream of data.

        Note that this clears the processing state, but the type of filter and
        its coefficients aren't changed.
    */
    void reset() { reset(SampleType{0}); }

    /** Resets the filter's processing pipeline to a specific value.
        @see reset
    */
    void reset(SampleType resetToValue);

    /** Called before processing starts. */
    void prepare(ProcessSpec const&) noexcept;

    /** Processes a single sample, without any locking.

        Use this if you need processing of a single value.

        Moreover, you might need the function snapToZero after a few calls to avoid
        potential denormalisation issues.
    */
    SampleType processSample(SampleType sample) noexcept;

    /** Ensure that the state variables are rounded to zero if the state
        variables are denormals. This is only needed if you are doing
        sample by sample processing.
    */
    void snapToZero() noexcept;

private:
    void check();

    std::vector<SampleType> memory;
    SampleType* state = nullptr;
    size_t order      = 0;
};
}  // namespace IIR
}  // namespace am

namespace am
{
namespace IIR
{

template<typename SampleType>
Filter<SampleType>::Filter() : coefficients({})
{
    reset();
}

template<typename SampleType>
void Filter<SampleType>::reset(SampleType resetToValue)
{

    if (auto newOrder = (static_cast<size_t>(coefficients.size()) - 1) / 2; newOrder != order)
    {
        memory.resize(std::max(static_cast<size_t>(3), std::max(order, newOrder)) + 1);
        state = memory.data();
        order = newOrder;
    }

    for (size_t i = 0; i < order; ++i) state[i] = resetToValue;
}

template<typename SampleType>
void Filter<SampleType>::prepare(ProcessSpec const&) noexcept
{
    reset();
}

template<typename SampleType>
SampleType Filter<SampleType>::processSample(SampleType sample) noexcept
{
    check();
    auto* c = coefficients.data();

    auto output = (c[0] * sample) + state[0];

    for (size_t j = 0; j < order - 1; ++j) state[j] = (c[j + 1] * sample) - (c[order + j + 1] * output) + state[j + 1];

    state[order - 1] = (c[order] * sample) - (c[order * 2] * output);

    return output;
}

template<typename SampleType>
void Filter<SampleType>::snapToZero() noexcept
{
    // for (size_t i = 0; i < order; ++i) util::snapToZero(state[i]);
}

template<typename SampleType>
void Filter<SampleType>::check()
{
    if (order != (static_cast<size_t>(coefficients.size()) - 1) / 2) reset();
}

}  // namespace IIR
}  // namespace am
