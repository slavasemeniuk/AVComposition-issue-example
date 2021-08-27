//
//  ViewController.swift
//  video-memory-issue
//
//  Created by Slava Semeniuk on 03.08.2021.
//

import UIKit
import AVFoundation
import AVKit
import Combine

class ViewController: UIViewController {

    private lazy var factory = VideoFactory()
    private lazy var asset = factory.composition
    private lazy var videoComposition = VideoCompositionFactory(composition: asset, trackOutlines: factory.trackOutlines).videoComposition
    private lazy var playerController = children.compactMap { $0 as? AVPlayerViewController }.first!
    private var bag: Set<AnyCancellable> = []

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let item = AVPlayerItem(asset: asset)
        item.videoComposition = videoComposition
        playerController.player = AVPlayer(playerItem: item)
        playerController.player?
            .publisher(for: \.error)
            .sink(receiveValue: { print($0) })
            .store(in: &bag)
    }
}
