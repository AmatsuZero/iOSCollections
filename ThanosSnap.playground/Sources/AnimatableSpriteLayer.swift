//
//  AnimatableSpriteLayer.swift
//  ThanosSnap
//
//  Inspired by https://www.calayer.com/core-animation/2018/01/05/creating-a-simple-animatable-sprite-layer.html
//

import UIKit

public class AnimatableSpriteLayer: CALayer {
    
    private var animationValues = [CGFloat]()
    
    public convenience init(spriteSheetImage: UIImage, spriteFrameSize: CGSize) {
        self.init()
        
        masksToBounds = true
        contentsGravity = CALayerContentsGravity.left
        contents = spriteSheetImage.cgImage
        bounds.size = spriteFrameSize
        
        let frameCount = Int(spriteSheetImage.size.width / spriteFrameSize.width)
        for frameIndex in 0..<frameCount {
            animationValues.append(CGFloat(frameIndex) / CGFloat(frameCount))
        }
    }
    
    public func play() {
        let spriteKeyframeAnimation = CAKeyframeAnimation(keyPath: "contentsRect.origin.x")
        spriteKeyframeAnimation.values = animationValues
        spriteKeyframeAnimation.duration = 2.0
        spriteKeyframeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        spriteKeyframeAnimation.calculationMode = CAAnimationCalculationMode.discrete
        add(spriteKeyframeAnimation, forKey: nil)
    }
}
