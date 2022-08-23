//
//  EarEffectCoreAudioontroller.swift
//  EarEffect
//
//  Created by Muhammad Zafar on 2022-07-27.
//

// import CoreAudioKit
import AudioToolbox
import AVFAudio
import AVFoundation
import UIKit

class EarEffectCoreAudioController: SPTCoreAudioController {
    var filterNode: AUNode = 0
    var filterUnit: AudioUnit?

//    var dynamicProcessorNode: AUNode = 0
//    var dynamicProcessorUnit: AudioUnit?

    var mixerNode: AUNode = 0
    var mixerUnit: AudioUnit?
//    override func connectOutputBus(_ sourceOutputBusNumber: UInt32, ofNode sourceNode: AUNode, toInputBus destinationInputBusNumber: UInt32, ofNode destinationNode: AUNode, in graph: AUGraph!) throws {
//        print("=== connectOutputBus ===")
//        print("=== audioOutputEnabled \(self.audioOutputEnabled)")
//
//       try super.connectOutputBus(sourceOutputBusNumber, ofNode: sourceNode, toInputBus: destinationInputBusNumber, ofNode: destinationNode, in: graph)
//
//        let sourceNodeCopy = sourceNode // original node without the harsh freq
//
//        // create a filter for the harsh frequencies
//        var filterDescription = AudioComponentDescription()
//        filterDescription.componentType = kAudioUnitType_Effect
//        filterDescription.componentSubType = kAudioUnitSubType_PeakLimiter
//        filterDescription.componentManufacturer = kAudioUnitManufacturer_Apple
//        filterDescription.componentFlags = 0
//        filterDescription.componentFlagsMask = 0
//
//        AUGraphAddNode(graph, &filterDescription, &filterNode) // Add the filter node
//        AUGraphNodeInfo(graph, filterNode, nil, &filterUnit) // Get the Audio Unit from the node
//        AudioUnitInitialize(filterUnit!) // Initialize the audio unit
//        // Set filter params
//        AudioUnitSetParameter(filterUnit!, kBandpassParam_CenterFrequency, kAudioUnitScope_Global, 0, 100, 0)
//
//        // create a processor to compress the frequency
////        var dynamicProcessorDescription = AudioComponentDescription()
////        dynamicProcessorDescription.componentType = kAudioUnitType_Effect
////        dynamicProcessorDescription.componentSubType = kAudioUnitSubType_DynamicsProcessor
////        dynamicProcessorDescription.componentManufacturer = kAudioUnitManufacturer_Apple
////        dynamicProcessorDescription.componentFlags = 0
////        dynamicProcessorDescription.componentFlagsMask = 0
//
//        // Add the dynamic processor node
////        AUGraphAddNode(graph, &dynamicProcessorDescription, &dynamicProcessorNode)
////        AUGraphNodeInfo(graph, dynamicProcessorNode, nil, &dynamicProcessorUnit)
////        AudioUnitInitialize(dynamicProcessorUnit!)
////
////        // Set compressor params
////        AudioUnitSetParameter(dynamicProcessorUnit!, kDynamicsProcessorParam_Threshold, kAudioUnitScope_Global, 0, -35, 0)
////        AudioUnitSetParameter(dynamicProcessorUnit!, kDynamicsProcessorParam_AttackTime, kAudioUnitScope_Global, 0, 0.02, 0)
////        AudioUnitSetParameter(dynamicProcessorUnit!, kDynamicsProcessorParam_ReleaseTime, kAudioUnitScope_Global, 0, 0.04, 0)
////        AudioUnitSetParameter(dynamicProcessorUnit!, kDynamicsProcessorParam_HeadRoom, kAudioUnitScope_Global, 0, 0, 0)
//
//        // mixer
//        var mixerDescription = AudioComponentDescription()
//        mixerDescription.componentType = kAudioUnitType_Mixer
//        mixerDescription.componentSubType = kAudioUnitSubType_MultiChannelMixer
//        mixerDescription.componentManufacturer = kAudioUnitManufacturer_Apple
//        mixerDescription.componentFlags = 0
//        mixerDescription.componentFlagsMask = 0
//
//        AUGraphAddNode(graph, &mixerDescription, &mixerNode)
//        AUGraphNodeInfo(graph, mixerNode, nil, &mixerUnit)
//        AudioUnitInitialize(mixerUnit!)
//
//        AudioUnitSetParameter(mixerUnit!, kMultiChannelMixerParam_Volume, kAudioUnitScope_Input, 0, 1.0, 0)
//        AudioUnitSetParameter(mixerUnit!, kMultiChannelMixerParam_Volume, kAudioUnitScope_Output, 0, 1.0, 0)
//
//
//        // connect the nodes
//        AUGraphConnectNodeInput(graph, sourceNode, sourceOutputBusNumber, filterNode, 0)
////        AUGraphConnectNodeInput(graph, filterNode, sourceOutputBusNumber, dynamicProcessorNode, 1)
//
//        AUGraphConnectNodeInput(graph, sourceNodeCopy, sourceOutputBusNumber, mixerNode, 1)
//        AUGraphConnectNodeInput(graph, filterNode, sourceOutputBusNumber, mixerNode, 2)
//
//        // connect the mixer to the output
//        AUGraphConnectNodeInput(graph, mixerNode, 0, destinationNode, destinationInputBusNumber)
//
//    }

    override func attempt(toDeliverAudioFrames audioFrames: UnsafeRawPointer!, ofCount frameCount: Int, streamDescription audioDescription: AudioStreamBasicDescription) -> Int {
//        let actualSampleCount = self.bytesInAudioBuffer()
//        print("bytesInAudioBuffer \(actualSampleCount)")
//
//        let data = Data(bytes: audioFrames, count: Int(actualSampleCount))
//        print("bytesInAudioBuffer output \(data)")
//        print("=== toDeliverAudioFrames ===")
//        CPP_Wrapper().attempt(toDeliverAudioFrames: audioFrames, ofCount: frameCount, streamDescription: audioDescription)
        return super.attempt(toDeliverAudioFrames: audioFrames, ofCount: frameCount, streamDescription: audioDescription)
//        return frameCount
    }
}

// -(BOOL)connectOutputBus:(UInt32)sourceOutputBusNumber ofNode:(AUNode)sourceNode toInputBus:(UInt32)destinationInputBusNumber ofNode:(AUNode)destinationNode inGraph:(AUGraph)graph error:(NSError **)error;
