#pragma once

#include <cassert>
#include <cmath>
#include <type_traits>

namespace am {

template<typename T>
class LinearSmoothed
{
public:
    LinearSmoothed() = default;

    LinearSmoothed(T initialValue) noexcept : _currentValue{initialValue}, _target{_currentValue} {}

    bool isSmoothing() const noexcept { return _countdown > 0; }

    T getCurrentValue() const noexcept { return _currentValue; }

    T getTargetValue() const noexcept { return _target; }

    void setCurrentAndTargetValue(T newValue)
    {
        _target = _currentValue = newValue;
        _countdown              = 0;
    }

    void reset(double sampleRate, double rampLengthInSeconds) noexcept
    {
        assert(sampleRate > 0 && rampLengthInSeconds >= 0);
        reset((int)std::floor(rampLengthInSeconds * sampleRate));
    }

    void reset(int numSteps) noexcept
    {
        _stepsToTarget = numSteps;
        setCurrentAndTargetValue(_target);
    }

    void setTargetValue(T newValue) noexcept
    {
        if (newValue == _target) return;

        if (_stepsToTarget <= 0) {
            setCurrentAndTargetValue(newValue);
            return;
        }

        _target    = newValue;
        _countdown = _stepsToTarget;

        setStepSize();
    }

    T getNextValue() noexcept
    {
        if (!isSmoothing()) { return _target; }

        --_countdown;

        if (isSmoothing()) {
            setNextValue();
        } else {
            _currentValue = _target;
        }

        return _currentValue;
    }

    T skip(int numSamples) noexcept
    {
        if (numSamples >= _countdown) {
            setCurrentAndTargetValue(_target);
            return _target;
        }

        skipCurrentValue(numSamples);

        _countdown -= numSamples;
        return _currentValue;
    }

private:
    auto setStepSize() noexcept -> void { _step = (_target - _currentValue) / (T)_countdown; }

    auto setNextValue() noexcept -> void { _currentValue += _step; }

    auto skipCurrentValue(int numSamples) noexcept -> void { _currentValue += _step * (T)numSamples; }

    T _step            = T();
    int _stepsToTarget = 0;

    T _currentValue = 0;
    T _target       = _currentValue;
    int _countdown  = 0;
};

}  // namespace am
