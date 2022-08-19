#pragma once

#include "span.hpp"

#include "LinearSmoothed.hpp"

#include <algorithm>
#include <numeric>
#include <vector>

namespace am {
template<typename T>
struct AudioBuffer
{
    AudioBuffer() = default;
    AudioBuffer(std::size_t channels, std::size_t samples);

    auto resize(std::size_t channels, std::size_t samples) -> void;

    [[nodiscard]] auto numChannels() const noexcept -> std::size_t;
    [[nodiscard]] auto numSamples() const noexcept -> std::size_t;

    auto channel(std::size_t ch) noexcept -> span<T>;
    auto channel(std::size_t ch) const noexcept -> span<T const>;

    auto operator()(std::size_t channel, std::size_t sample) noexcept -> T&;
    auto operator()(std::size_t channel, std::size_t sample) const noexcept -> T const&;

private:
    std::vector<T> _buffer{};
    std::size_t _numChannels{};
    std::size_t _numSamples{};
};

template<typename T>
auto applyGain(AudioBuffer<T>& buffer, T gain) noexcept -> void;

template<typename T>
auto applyGain(AudioBuffer<T>& buffer, LinearSmoothed<T>& gain) noexcept -> void;

template<typename T>
auto clip(AudioBuffer<T>& buffer) noexcept -> void;

template<typename T>
auto clip(AudioBuffer<T>& buffer, T low, T high) noexcept -> void;

template<typename T>
inline AudioBuffer<T>::AudioBuffer(std::size_t channels, std::size_t samples)
    : _buffer(channels * samples)
    , _numChannels(channels)
    , _numSamples(samples)
{}

template<typename T>
inline auto AudioBuffer<T>::numChannels() const noexcept -> std::size_t
{
    return _numChannels;
}

template<typename T>
inline auto AudioBuffer<T>::numSamples() const noexcept -> std::size_t
{
    return _numSamples;
}

template<typename T>
inline auto AudioBuffer<T>::resize(std::size_t channels, std::size_t samples) -> void
{
    _numChannels = channels;
    _numSamples  = samples;
    _buffer.clear();
    _buffer.resize(channels * samples, T{});
}

template<typename T>
inline auto AudioBuffer<T>::channel(std::size_t ch) noexcept -> span<T>
{
    return {&_buffer[ch * _numSamples], _numSamples};
}

template<typename T>
inline auto AudioBuffer<T>::channel(std::size_t ch) const noexcept -> span<T const>
{
    return {&_buffer[ch * _numSamples], _numSamples};
}

template<typename T>
inline auto AudioBuffer<T>::operator()(std::size_t channel, std::size_t sample) noexcept -> T&
{
    return _buffer[channel * _numSamples + sample];
}

template<typename T>
inline auto AudioBuffer<T>::operator()(std::size_t channel, std::size_t sample) const noexcept -> T const&
{
    return _buffer[channel * _numSamples + sample];
}

template<typename T>
auto applyGain(AudioBuffer<T>& buffer, LinearSmoothed<T>& gain) noexcept -> void
{
    if (buffer.numChannels() == 1UL) {
        auto channel = buffer.channel(0UL);
        std::transform(channel.begin(), channel.end(), channel.begin(), [&gain](T x) {
            return x * gain.getNextValue();
        });
        return;
    }

    for (auto i{0UL}; i < buffer.numSamples(); ++i) {
        auto const smoothedGain = gain.getNextValue();
        for (auto ch{0UL}; ch < buffer.numChannels(); ++ch) { buffer(ch, i) *= smoothedGain; }
    }
}

template<typename T>
inline auto applyGain(AudioBuffer<T>& buffer, T gain) noexcept -> void
{
    for (auto ch{0UL}; ch < buffer.numChannels(); ++ch) {
        auto channel = buffer.channel(ch);
        std::transform(channel.begin(), channel.end(), channel.begin(), [gain](T x) { return x * gain; });
    }
}

template<typename T>
inline auto clip(AudioBuffer<T>& buffer) noexcept -> void
{
    clip(buffer, T(-1), T(1));
}

template<typename T>
inline auto clip(AudioBuffer<T>& buffer, T low, T high) noexcept -> void
{
    for (auto ch{0UL}; ch < buffer.numChannels(); ++ch) {
        auto channel = buffer.channel(ch);
        std::transform(channel.begin(), channel.end(), channel.begin(), [low, high](T x) {
            return std::clamp(x, low, high);
        });
    }
}

}  // namespace am
