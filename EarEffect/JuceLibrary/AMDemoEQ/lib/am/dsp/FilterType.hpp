#pragma once

namespace am
{

enum struct FilterType : int
{
    LowPass,
    HighPass,
    Notch,
    Peak,
    LowShelf,
    HighShelf,
};

inline auto fromIndex(int const index) noexcept -> FilterType { return static_cast<FilterType>(index); }

}  // namespace am