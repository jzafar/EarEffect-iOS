#pragma once

#include <cstddef>

namespace am
{
struct ProcessSpec
{
    double sampleRate{};
    std::size_t maximumBlockSize{};
    std::size_t numChannels{};
};
}  // namespace am
