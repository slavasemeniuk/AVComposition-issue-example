//
//  VideoFactory.swift
//  video-memory-issue
//
//  Created by Slava Semeniuk on 03.08.2021.
//

import AVFoundation

struct VideoFactory {

    private let asset = AVURLAsset(url: Bundle.main.url(forResource: "test", withExtension: "MOV")!)
    let composition = AVMutableComposition()


    init() {
        compose()
    }

    private func compose() {
        composition.naturalSize = CGSize(width: 720, height: 1_280)

        let timeMappings = Self.timeMappings()
        timeMappings.forEach(insert(timeMapping:))
    }

    private func insert(timeMapping: CMTimeMapping) {
        guard let mutableTrack = composition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: kCMPersistentTrackID_Invalid)
        else { fatalError("Unable to create track") }

        guard let track = asset.tracks(withMediaType: .video).first
        else { fatalError("No video track") }

        mutableTrack.preferredTransform = track.preferredTransform

        try! mutableTrack.insertTimeRange(
            timeMapping.source,
            of: track,
            at: timeMapping.target.start)
    }

    static func timeMappings() -> [CMTimeMapping] {
        [
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 3.0),
                target: CMTimeRange(start: 0.0, end: 3.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 3.0),
                target: CMTimeRange(start: 3.0, end: 6.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 3.0),
                target: CMTimeRange(start: 6.0, end: 9.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 3.0),
                target: CMTimeRange(start: 6.0, end: 9.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 3.0),
                target: CMTimeRange(start: 6.0, end: 9.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 0.3),
                target: CMTimeRange(start: 9.0, end: 9.3)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 0.3),
                target: CMTimeRange(start: 9.3, end: 10.6)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 0.4),
                target: CMTimeRange(start: 9.6, end: 10.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 4.0),
                target: CMTimeRange(start: 10.0, end: 14.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 3.0),
                target: CMTimeRange(start: 14.0, end: 17.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 3.0),
                target: CMTimeRange(start: 14.0, end: 17.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 7.0),
                target: CMTimeRange(start: 17.0, end: 24.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 4.0),
                target: CMTimeRange(start: 24.0, end: 28.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 2.0),
                target: CMTimeRange(start: 28.0, end: 30.0)),
        ]
    }
}
