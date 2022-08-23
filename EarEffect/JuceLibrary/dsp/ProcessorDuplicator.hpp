#pragma once

#include <cassert>
#include <memory>
#include <utility>
#include <vector>

namespace am
{

template<typename T, typename MonoProcessorType, typename StateType>
struct ProcessorDuplicator
{
    ProcessorDuplicator() : state(new StateType()) {}

    ProcessorDuplicator(StateType* stateToUse) : state(stateToUse) {}
    ProcessorDuplicator(typename StateType::Ptr stateToUse) : state(std::move(stateToUse)) {}

    ProcessorDuplicator(ProcessorDuplicator const&) = default;
    ProcessorDuplicator(ProcessorDuplicator&&)      = default;

    void prepare(ProcessSpec const& spec)
    {
        processors.clear();

        while (static_cast<size_t>(processors.size()) < spec.numChannels)
        {
            processors.push_back(std::make_unique<MonoProcessorType>(state));
        }

        auto monoSpec        = spec;
        monoSpec.numChannels = 1;

        for (auto& p : processors) p->prepare(monoSpec);
    }

    void reset() noexcept
    {
        for (auto& p : processors) { p->reset(); }
    }

    auto processSample(std::size_t chan, T sample) noexcept -> T { return processors[chan]->processSample(sample); }

    typename StateType::Ptr state;

private:
    std::vector<std::unique_ptr<MonoProcessorType>> processors;
};

}  // namespace am
