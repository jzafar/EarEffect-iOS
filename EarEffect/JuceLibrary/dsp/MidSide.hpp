#pragma once

#include "span.hpp"

#include "AudioBuffer.hpp"
#include "ProcessSpec.hpp"

#include <cassert>

namespace am
{

/// \brief Split stereo signal into mid & side channels. Can be reconstructed using mergeMidSideToStereo
/// \details All supplied ranges must be equal in size to distance(lf, ll).
///
/// https://www.soundonsound.com/sound-advice/q-how-does-mid-sides-recording-actually-work
auto splitStereoToMidSide(span<float const> left, span<float const> right, span<float> mid, span<float> side) -> void;
auto splitStereoToMidSide(span<double const> left, span<double const> right, span<double> mid, span<double> side)
    -> void;

/// \brief Merges a mid/ side pair back to a stereo signal.
/// \details All supplied ranges must be equal in size to distance(mf, ml).
///
/// https://www.soundonsound.com/sound-advice/q-how-does-mid-sides-recording-actually-work
auto mergeMidSideToStereo(span<float const> mid, span<float const> side, span<float> left, span<float> right) -> void;
auto mergeMidSideToStereo(span<double const> mid, span<double const> side, span<double> left, span<double> right)
    -> void;

template<typename ProcessorType>
struct MidSide
{
    using SampleType = typename ProcessorType::SampleType;

    MidSide() = default;

    auto prepare(ProcessSpec const& spec) -> void;

    auto process(AudioBuffer<SampleType>& buffer) -> void;

    auto reset() -> void;

    [[nodiscard]] auto midProcessor() -> ProcessorType&;
    [[nodiscard]] auto midProcessor() const -> ProcessorType const&;

    [[nodiscard]] auto sideProcessor() -> ProcessorType&;
    [[nodiscard]] auto sideProcessor() const -> ProcessorType const&;

private:
    ProcessSpec _spec{};
    ProcessorType _midProcessor;
    ProcessorType _sideProcessor;

    AudioBuffer<SampleType> _midBuffer;
    AudioBuffer<SampleType> _sideBuffer;
};

template<typename ProcessorType>
auto MidSide<ProcessorType>::prepare(ProcessSpec const& spec) -> void
{
    assert(spec.numChannels == 2U);
    auto singleChannelSpec = ProcessSpec{spec.sampleRate, spec.maximumBlockSize, 1U};
    _midProcessor.prepare(singleChannelSpec);
    _sideProcessor.prepare(singleChannelSpec);

    _midBuffer.resize(1UL, spec.maximumBlockSize);
    _sideBuffer.resize(1UL, spec.maximumBlockSize);
}

template<typename ProcessorType>
auto MidSide<ProcessorType>::process(AudioBuffer<SampleType>& buffer) -> void
{
    assert(buffer.numChannels() == 2U);

    auto const numSamples = buffer.numSamples();

    _midBuffer.resize(1UL, numSamples);
    _sideBuffer.resize(1UL, numSamples);

    auto midChannel  = _midBuffer.channel(0UL);
    auto sideChannel = _sideBuffer.channel(0UL);

    auto leftIO  = buffer.channel(0UL);
    auto rightIO = buffer.channel(1UL);

    splitStereoToMidSide(leftIO, rightIO, midChannel, sideChannel);
    _midProcessor.process(_midBuffer);
    _sideProcessor.process(_sideBuffer);
    mergeMidSideToStereo(midChannel, sideChannel, leftIO, rightIO);
}

template<typename ProcessorType>
auto MidSide<ProcessorType>::reset() -> void
{
    _midProcessor.reset();
    _sideProcessor.reset();
}

template<typename ProcessorType>
auto MidSide<ProcessorType>::midProcessor() -> ProcessorType&
{
    return _midProcessor;
}

template<typename ProcessorType>
auto MidSide<ProcessorType>::midProcessor() const -> ProcessorType const&
{
    return _midProcessor;
}

template<typename ProcessorType>
auto MidSide<ProcessorType>::sideProcessor() -> ProcessorType&
{
    return _sideProcessor;
}

template<typename ProcessorType>
auto MidSide<ProcessorType>::sideProcessor() const -> ProcessorType const&
{
    return _sideProcessor;
}
}  // namespace am
