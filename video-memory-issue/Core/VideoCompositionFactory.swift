//
//  VideoCompositionFactory.swift
//  video-memory-issue
//
//  Created by Slava Semeniuk on 03.08.2021.
//

import AVFoundation

final class VideoCompositionFactory {
    private let composition: AVComposition
    let videoComposition = AVMutableVideoComposition()
    let trackOutlines: [TrackOutline]

    init(composition: AVComposition, trackOutlines: [TrackOutline]) {
        self.composition = composition
        self.trackOutlines = trackOutlines
        self.build()
    }

    private func build() {
        videoComposition.customVideoCompositorClass = CustomCompositor.self
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        videoComposition.renderSize = composition.naturalSize

        let instructionFactory = InstructionsFactory(composition: composition, trackOutlines: trackOutlines)
        videoComposition.instructions = instructionFactory.instructions
    }
}
