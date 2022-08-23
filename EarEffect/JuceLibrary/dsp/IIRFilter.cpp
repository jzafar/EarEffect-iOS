#include "IIRFilter.hpp"

#include <algorithm>
#include <cassert>

namespace
{
template<typename Type, typename IntegerType>
inline Type* snapPointerToAlignment(Type* basePointer, IntegerType alignmentBytes) noexcept
{
    return (Type*)((((size_t)basePointer) + (alignmentBytes - 1)) & ~(alignmentBytes - 1));
}

}  // namespace

namespace am
{
namespace IIR
{

template<typename T>
Filter<T>::Filter() : coefficients(new Coefficients<T>(1, 0, 1, 0))
{
    reset();
}

template<typename T>
Filter<T>::Filter(CoefficientsPtr c) : coefficients(std::move(c))
{
    reset();
}

template<typename T>
void Filter<T>::reset(T resetToValue)
{
    auto newOrder = coefficients->getFilterOrder();

    if (newOrder != order)
    {
        memory.resize(3 + 1);
        state = memory.data();
        order = newOrder;
    }

    for (size_t i = 0; i < order; ++i) state[i] = resetToValue;
}

template<typename T>
void Filter<T>::prepare(ProcessSpec const&) noexcept
{
    reset();
}

template<typename T>
T Filter<T>::processSample(T sample) noexcept
{
    check();
    auto* c = coefficients->getRawCoefficients();

    auto output = (c[0] * sample) + state[0];

    for (size_t j = 0; j < order - 1; ++j) state[j] = (c[j + 1] * sample) - (c[order + j + 1] * output) + state[j + 1];

    state[order - 1] = (c[order] * sample) - (c[order * 2] * output);

    return output;
}

template<typename T>
void Filter<T>::snapToZero() noexcept
{
    for (size_t i = 0; i < order; ++i) { util::snapToZero(state[i]); }
}

template<typename T>
void Filter<T>::check()
{
    assert(coefficients != nullptr);

    if (order != coefficients->getFilterOrder()) reset();
}

template class Filter<float>;
template class Filter<double>;

}  // namespace IIR
}  // namespace am
