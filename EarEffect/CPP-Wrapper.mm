//
//  CPP-Wrapper.mm
//  SO-32541268
//
//  Copyright © 2017, 2018 Xavier Schott
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

// Definition: CPP-Wrapper.mm
#import "CPP-Wrapper.h"
#include "DemoLimiter.hpp"
#include "AudioBuffer.hpp"

@implementation CPP_Wrapper

/**
 Attempts to deliver audio frame to JUCE.
 
 @param audioFrames A buffer containing the audio frames.
 @param frameCount The number of frames included in the buffer.
 @param audioDescription A description of the audio contained in `audioFrames`.
 
 */
-(void)attemptToDeliverAudioFrames:(const void *)audioFrames ofCount:(NSInteger)frameCount streamDescription:(AudioStreamBasicDescription)audioDescription{
    am::fx::DemoLimiter demoLimiter;
    am::fx::DemoLimiter::Parameter parameter;
    parameter.mode = 1; // what is mode and what value should we set?
    parameter.threshold = 1; // what is threshold and what value should we set?
    parameter.ceiling = 1; // what is ceiling and what value should we set?
    parameter.release = 1; // what is release and what value should we set?
    demoLimiter.parameter(parameter);
    demoLimiter.prepare(audioDescription.mSampleRate, audioDescription.mFramesPerPacket);
    am::AudioBuffer<float> buffer = am::AudioBuffer<float>(audioDescription.mChannelsPerFrame, audioDescription.mBytesPerFrame);
    demoLimiter.process(buffer);
    // i didn't find any function where i can set audioBuffer = audioFrames. We are getting audio frames but i think we need a function which initialise AudioBuffer with audioFrames.??
    
    // is this correct way of calling LIMITER.??
    // I Set parameters first then i prepare and then i call process function but it is not playing any audio. What i am missing or doing wrong here.
}
@end
//struct AudioStreamBasicDescription
//{
//    Float64             mSampleRate;
//    AudioFormatID       mFormatID;
//    AudioFormatFlags    mFormatFlags;
//    UInt32              mBytesPerPacket;
//    UInt32              mFramesPerPacket;
//    UInt32              mBytesPerFrame;
//    UInt32              mChannelsPerFrame;
//    UInt32              mBitsPerChannel;
//    UInt32              mReserved;
//};
