//
//  ViewController.swift
//  video-play-demo
//
//  Created by 平石　太郎 on 2022/12/26.
//

import Combine
import AVFoundation
import UIKit

class VideoViewController: UIViewController {
    @IBOutlet weak var videoPlayUIView: VideoPlayUIView!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var player: AVPlayer = {
        let url = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        return AVPlayer(url: url)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeDidFinishVideoPlay()
        setup()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: - SETUP
extension VideoViewController {
    private func setup() {
        videoPlayUIView.player = player
        player.play()
    }
}

// MARK: - SUBSCRIBE
extension VideoViewController {
    private func subscribeDidFinishVideoPlay() {
        videoPlayUIView
            .didFinishVideoPlay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.player.pause()
                self.player.seek(to: .zero)
            }
            .store(in: &cancellables)
    }
}

