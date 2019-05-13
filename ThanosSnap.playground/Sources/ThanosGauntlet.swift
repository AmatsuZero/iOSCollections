//
//  ThanosGauntlet.swift
//  ThanosSnap
//
//  Created by potato04 on 2019/4/29.
//  Copyright © 2019 potato04. All rights reserved.
//

import UIKit
import AVFoundation

public protocol ThanosGauntletDelegate: class {
    func ThanosGauntletDidSnapped()
    func ThanosGauntletDidReversed()
}

public class ThanosGauntlet: UIControl {
    
    public weak var delegate: ThanosGauntletDelegate?
    
    private lazy var snapLayer: AnimatableSpriteLayer = {
        let path = Bundle.main.path(forResource: "thanos_snap", ofType: "png", inDirectory: "Images")!
        return AnimatableSpriteLayer(spriteSheetImage: UIImage(contentsOfFile: path)!, spriteFrameSize: CGSize(width: 80, height: 80))
    }()
    
    private lazy var snapSoundPlayer: AVAudioPlayer? = {
        let path = Bundle.main.path(forResource: "thanos_snap_sound", ofType: "mp3", inDirectory: "Sounds")!
        return try? AVAudioPlayer(contentsOf: .init(fileURLWithPath: path))
    }()
    
    private lazy var reverseLayer: AnimatableSpriteLayer = {
        let path = Bundle.main.path(forResource: "thanos_time", ofType: "png", inDirectory: "Images")!
        return AnimatableSpriteLayer(spriteSheetImage: UIImage(contentsOfFile: path)!, spriteFrameSize: CGSize(width: 80, height: 80))
    }()
    
    private lazy var reverseSoundPlayer: AVAudioPlayer? = {
        let path = Bundle.main.path(forResource: "thanos_reverse_sound", ofType: "mp3", inDirectory: "Sounds")!
        return try? AVAudioPlayer(contentsOf: .init(fileURLWithPath: path))
    }()
    
    
    enum Action {
        case snap
        case reverse
    }
    
    private var action = Action.snap
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    override public func layoutSubviews() {
        snapLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        reverseLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.addSublayer(snapLayer)
        
        reverseLayer.isHidden = true
        layer.addSublayer(reverseLayer)
    }
    
    override public func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        
        switch action {
        case .snap:
            
            snapLayer.isHidden = false
            reverseLayer.isHidden = true
            snapLayer.play()
            
            reverseSoundPlayer?.stop()
            reverseSoundPlayer?.currentTime = 0
            snapSoundPlayer?.play()
            
            action = .reverse
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.delegate?.ThanosGauntletDidSnapped()
            }
            
        case .reverse:
            
            snapLayer.isHidden = true
            reverseLayer.isHidden = false
            reverseLayer.play()
            
            snapSoundPlayer?.stop()
            snapSoundPlayer?.currentTime = 0
            reverseSoundPlayer?.play()
            
            action = .snap
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.delegate?.ThanosGauntletDidReversed()
            }
        }
    }
}
