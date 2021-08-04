//
//  InstructionsFactory.swift
//  video-memory-issue
//
//  Created by Slava Semeniuk on 03.08.2021.
//

import AVFoundation

final class InstructionsFactory {

    private let composition: AVComposition
    private(set) var instructions: [SceneInstruction] = []

    init(composition: AVComposition) {
        self.composition = composition
        self.build()
    }

    private func build() {
        let uniqueTimePoints: [Double] = composition.tracks.map(\.timeRange).reduce(into: Set<Double>([0]), { result, timeRange in
            result.insert(timeRange.start.seconds)
            result.insert(timeRange.end.seconds)
        }).sorted(by: <)
        
        instructions = (0..<uniqueTimePoints.count - 1).map { index in
            makeSceneInstruction(for: CMTimeRange(start: uniqueTimePoints[index], end: uniqueTimePoints[index + 1]))
        }
    }

    private func makeSceneInstruction(for timeRange: CMTimeRange) -> SceneInstruction {
        let sceneInstruction = SceneInstruction(timeRange: timeRange)
        composition.tracks
            .filter { !timeRange.isDisjoint(with: $0.timeRange) }
            .forEach { sceneInstruction.requiredSourceTrackIDs?.append(NSNumber(value: $0.trackID)) }
        return sceneInstruction
    }
}
