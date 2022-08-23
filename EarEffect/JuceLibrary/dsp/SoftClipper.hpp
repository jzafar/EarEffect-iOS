#pragma once

#include <type_traits>

namespace am
{

template<typename T>
[[nodiscard]] constexpr auto softClip(T sample) -> T
{
    static_assert(std::is_floating_point_v<T>, "This function only works with floating point types");

    if (sample < T{-1}) { return -(T{2} / T{3}); }
    else if (sample > T{1}) { return T{2} / T{3}; }
    else { return sample - ((sample * sample * sample) / T{3}); }
}

}  // namespace am
