//
//  InstructionsFactory.swift
//  video-memory-issue
//
//  Created by Slava Semeniuk on 03.08.2021.
//

import AVFoundation

final class InstructionsFactory {

    private let composition: AVComposition
    let trackOutlines: [TrackOutline]
    private(set) var instructions: [SceneInstruction] = []

    init(composition: AVComposition, trackOutlines: [TrackOutline]) {
        self.composition = composition
        self.trackOutlines = trackOutlines
        self.build()
    }

    private func build() {
        let uniqueTimePoints: [Double] = composition.tracks
            .flatMap(\.segments)
            .map(\.timeMapping.target)
            .reduce(into: Set<Double>([0]), { result, timeRange in
                result.insert(timeRange.start.seconds)
                result.insert(timeRange.end.seconds)
            }).sorted(by: <)
        
        instructions = (0..<uniqueTimePoints.count - 1).map { index in
            makeSceneInstruction(for: CMTimeRange(start: uniqueTimePoints[index], end: uniqueTimePoints[index + 1]))
        }
        
        print("Video Composition")
        instructions.forEach {
            print("\($0.timeRange.start.seconds) - \($0.timeRange.end.seconds)")
            print($0.requiredSourceTrackIDs ?? [])
            print("------------")
        }
    }

    private func makeSceneInstruction(for timeRange: CMTimeRange) -> SceneInstruction {
        let sceneInstruction = SceneInstruction(timeRange: timeRange)
        trackOutlines
            .filter { !timeRange.isDisjoint(with: $0.timeRange) }
            .forEach { sceneInstruction.requiredSourceTrackIDs?.append(NSNumber(value: $0.track.trackID)) }
        return sceneInstruction
    }
}
