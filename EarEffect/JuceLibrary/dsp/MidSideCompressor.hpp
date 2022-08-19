#pragma once

#include "Compressor.hpp"
#include "MidSide.hpp"

namespace am {

template<typename T>
using MidSideCompressor = MidSide<Compressor<T>>;

}  // namespace am
