//
//  VideoFactory.swift
//  video-memory-issue
//
//  Created by Slava Semeniuk on 03.08.2021.
//

import AVFoundation

final class VideoFactory {

    private let asset = AVURLAsset(url: Bundle.main.url(forResource: "test", withExtension: "MOV")!)
    let composition = AVMutableComposition()
    private(set) var trackOutlines: [TrackOutline] = []


    init() {
        compose()
    }

    private func compose() {
        composition.naturalSize = CGSize(width: 720, height: 1_280)

        // MARK: Doesn't work as well
//        let timeMappings = Self.testTimeMappings1

        let timeMappings = Self.testTimeMappings2
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

        self.trackOutlines.append(
            TrackOutline(track: mutableTrack, timeRange: timeMapping.target)
        )
    }

    static var testTimeMappings1: [CMTimeMapping] {
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
            /* -------------- */
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 0.6),
                target: CMTimeRange(start: 9.0, end: 9.6)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 0.6),
                target: CMTimeRange(start: 9.1, end: 9.7)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 0.3),
                target: CMTimeRange(start: 9.7, end: 10.0)),
//            CMTimeMapping(
//                source: CMTimeRange(start: 0.0, end: 0.4),
//                target: CMTimeRange(start: 9.6, end: 10.0)),
            /* ------------- */
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 1.0),
                target: CMTimeRange(start: 10.0, end: 11.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 1.0),
                target: CMTimeRange(start: 11.0, end: 12.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 1.0),
                target: CMTimeRange(start: 12.0, end: 13.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 1.0),
                target: CMTimeRange(start: 13.0, end: 14.0)),
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

    static var testTimeMappings2: [CMTimeMapping] {
        [
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 1.1),
                target: CMTimeRange(start: 0.0, end: 1.1)),
            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 0.85),
                target: CMTimeRange(start: 0.25, end: 1.1)),

            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 2.42),
                target: CMTimeRange(start: 1.1, end: 3.52)),
            CMTimeMapping(
                source: CMTimeRange(start: 1.1, end: 2.26),
                target: CMTimeRange(start: 2.36, end: 3.52)),

            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 2.42),
                target: CMTimeRange(start: 3.52, end: 5.16)),

            CMTimeMapping(
                source: CMTimeRange(start: 0, end: 1.14),
                target: CMTimeRange(start: 5.16, end: 6.3)),

            CMTimeMapping(
                source: CMTimeRange(start: 0.0, end: 1.24),
                target: CMTimeRange(start: 6.3, end: 7.54)),

            CMTimeMapping(
                source: CMTimeRange(start: 1.14, end: 2.85),
                target: CMTimeRange(start: 7.54, end: 9.25)),

            CMTimeMapping(
                source: CMTimeRange(start: 0.85, end: 2.1),
                target: CMTimeRange(start: 9.25, end: 10.5)),

            CMTimeMapping(
                source: CMTimeRange(start: 2.26, end: 3.28),
                target: CMTimeRange(start: 10.5, end: 11.52)),

            CMTimeMapping(
                source: CMTimeRange(start: 2.42, end: 3.44),
                target: CMTimeRange(start: 10.5, end: 11.52)),

            // MARK: - Comment to make it work
            ///* -------------------------------------------------------------------------
            CMTimeMapping(
                source: CMTimeRange(start: 2.42, end: 4.06),
                target: CMTimeRange(start: 11.52, end: 13.16)),

            CMTimeMapping(
                source: CMTimeRange(start: 1.24, end: 2.3),
                target: CMTimeRange(start: 13.16, end: 14.22)),

            CMTimeMapping(
                source: CMTimeRange(start: 3.28, end: 4.06),
                target: CMTimeRange(start: 14.22, end: 15.0)),
            CMTimeMapping(
                source: CMTimeRange(start: 2.1, end: 2.35),
                target: CMTimeRange(start: 14.22, end: 14.47)),
            // */

        ]
    }
}

struct TrackOutline {
    let track: AVAssetTrack
    let timeRange: CMTimeRange
}
