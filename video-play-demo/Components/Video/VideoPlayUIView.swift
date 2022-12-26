//
//  VideoPlayUIView.swift
//  video-play-demo
//
//  Created by 平石　太郎 on 2022/12/27.
//

import Foundation
import Combine
import AVFoundation
import UIKit

class VideoPlayUIView: UIView {
    private var cancellables: Set<AnyCancellable> = []
    private(set) var didFinishVideoPlay: PassthroughSubject<Void, Never> = .init()
    
    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            playerLayer.player
        }
        
        set {
            subscribeDidFinishVideoPlay()
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.player = newValue
        }
    }
    
    private func subscribeDidFinishVideoPlay() {
        NotificationCenter
            .default
            .publisher(for: NSNotification.Name.AVPlayerItemDidPlayToEndTime)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.didFinishVideoPlay.send()
            }
            .store(in: &cancellables)
    }
}
