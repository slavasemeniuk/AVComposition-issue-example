//
//  SceneInstruction.swift
//  video-memory-issue
//
//  Created by Slava Semeniuk on 03.08.2021.
//

import AVFoundation

final class SceneInstruction: NSObject, AVVideoCompositionInstructionProtocol {

    // MARK: - AVVideoCompositionInstructionProtocol
    var timeRange: CMTimeRange
    var enablePostProcessing = false
    var containsTweening = false
    var requiredSourceTrackIDs: [NSValue]?
    var passthroughTrackID: CMPersistentTrackID

    init(timeRange: CMTimeRange) {
        self.passthroughTrackID = kCMPersistentTrackID_Invalid
        self.requiredSourceTrackIDs = []
        self.timeRange = timeRange
        super.init()
    }
}
