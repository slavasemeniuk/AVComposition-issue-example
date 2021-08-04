//
//  CMTimeRange+Extension.swift
//  video-memory-issue
//
//  Created by Slava Semeniuk on 03.08.2021.
//

import CoreMedia

typealias Seconds = Double

extension CMTimeRange {
    init(start: Seconds, end: Seconds) {
        self.init(start: CMTime(seconds: start, preferredTimescale: 1_000), end: CMTime(seconds: end, preferredTimescale: 1_000))
    }

    init(start: Seconds, duration: Seconds) {
        self.init(start: CMTime(seconds: start, preferredTimescale: 1_000), duration: CMTime(seconds: duration, preferredTimescale: 1_000))
    }

    func isDisjoint(with timeRange: CMTimeRange) -> Bool {
        intersection(timeRange).isEmpty
    }
}
