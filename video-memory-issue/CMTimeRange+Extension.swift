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
        self.init(start: start.cmTime, end: end.cmTime)
    }

    init(start: Seconds, duration: Seconds) {
        self.init(start: start.cmTime, duration: duration.cmTime)
    }

    func isDisjoint(with timeRange: CMTimeRange) -> Bool {
        intersection(timeRange).isEmpty
    }
}

extension Seconds {
    var cmTime: CMTime {
        CMTime(seconds: self, preferredTimescale: 60)
    }
}


