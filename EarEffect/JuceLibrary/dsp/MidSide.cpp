#include "MidSide.hpp"
#include "Decibels.hpp"

namespace am
{

namespace
{
template<typename T>
auto splitStereoToMidSideImpl(T const* lf, T const* ll, T const* right, T* mid, T* side) noexcept -> void
{
    auto const gainCompensation = decibelsToGain(T{-3});
    for (; lf != ll; ++lf, ++right, ++mid, ++side)
    {
        auto const l = *lf;
        auto const r = *right;

        *mid  = (l + r) * gainCompensation;
        *side = (l - r) * gainCompensation;
    }
}

template<typename T>
auto mergeMidSideToStereoImpl(T const* mf, T const* ml, T const* side, T* left, T* right) noexcept -> void
{
    auto const gainCompensation = decibelsToGain(T{-3});
    for (; mf != ml; ++mf, ++side, ++left, ++right)
    {
        auto const m = *mf;
        auto const s = *side;

        *left  = (m + s) * gainCompensation;
        *right = (m - s) * gainCompensation;
    }
}
}  // namespace

auto splitStereoToMidSide(span<float const> left, span<float const> right, span<float> mid, span<float> side) -> void
{
    using std::data;
    using std::next;
    using std::size;
    splitStereoToMidSideImpl(data(left), next(data(left), (ptrdiff_t)size(left)), data(right), data(mid), data(side));
}
auto splitStereoToMidSide(span<double const> left, span<double const> right, span<double> mid, span<double> side)
    -> void
{
    using std::data;
    using std::next;
    using std::size;
    splitStereoToMidSideImpl(data(left), next(data(left), (ptrdiff_t)size(left)), data(right), data(mid), data(side));
}

auto mergeMidSideToStereo(span<float const> mid, span<float const> side, span<float> left, span<float> right) -> void
{
    using std::data;
    using std::next;
    using std::size;
    mergeMidSideToStereoImpl(data(mid), next(data(mid), (ptrdiff_t)size(mid)), data(side), data(left), data(right));
}
auto mergeMidSideToStereo(span<double const> mid, span<double const> side, span<double> left, span<double> right)
    -> void
{
    using std::data;
    using std::next;
    using std::size;
    mergeMidSideToStereoImpl(data(mid), next(data(mid), (ptrdiff_t)size(mid)), data(side), data(left), data(right));
}
}  // namespace am
