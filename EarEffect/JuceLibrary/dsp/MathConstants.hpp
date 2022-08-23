#pragma once

namespace am
{
template<typename T>
struct MathConstants
{
    inline static constexpr auto pi     = static_cast<T>(3.14159265358979323846);
    inline static constexpr auto halfPi = static_cast<T>(pi / T(2));
    inline static constexpr auto sqrt2  = static_cast<T>(1.41421356);
};

template<typename T>
[[nodiscard]] constexpr auto lerp(T a, T b, T t) noexcept -> T
{
    if ((a <= 0 && b >= 0) || (a >= 0 && b <= 0)) { return t * b + (1 - t) * a; }

    if (t == 1) { return b; }

    auto const x = a + t * (b - a);
    if ((t > 1) == (b > a)) { return b < x ? x : b; }
    return x < b ? x : b;
}

}  // namespace am
