import UIKit

public class BlingBlingLabel: UILabel {
    public var appearDuration: CFTimeInterval = 1.5
    public var disappearDuration = 1.5
    public var attributedString:NSMutableAttributedString?
    public var needAnimation = false
    
    var displaylink:CADisplayLink?
    var isAppearing = false
    var isDisappearing = false
    var isDisappearing4ChangeText = false
    var beginTime = CFTimeInterval.zero
    var endTime = CFTimeInterval.zero
    var durationArray = [CFTimeInterval]()
    var lastString: String?
    var textColorAlpha: CGFloat = 1
    
    override public var text: String? {
        get {
            if needAnimation {
                return self.attributedString?.string
            }
            else {
                return super.text
            }
        }
        
        set {
            if needAnimation {
                convertToAttributedString(text: newValue)
            }
            else {
                super.text = newValue
            }
        }
    }
    
    override public var textColor: UIColor! {
        didSet {
            if self.textColor.cgColor.alpha > 0 {
                print("fffffffff: %f", self.textColor.cgColor.alpha)
                textColorAlpha = self.textColor.cgColor.alpha
            }
        }
    }
    
    public func convertToAttributedString(text: String?) {
        lastString = text
        if let length = self.attributedText?.length, length > 0 {
            disappear()
            isDisappearing4ChangeText = true
        } else {
            appear()
        }
    }
    
    public func appear() {
        guard let str = lastString else {
            return;
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString = NSMutableAttributedString(string: str, attributes: [
            .paragraphStyle : paragraphStyle
        ])
        isAppearing = true
        beginTime = CACurrentMediaTime()
        endTime = CACurrentMediaTime() + appearDuration
        displaylink?.isPaused = false
        
        initDurationArray(appearDuration)
    }
    
    public func disappear() {
        isDisappearing = true
        beginTime = CACurrentMediaTime()
        endTime = CACurrentMediaTime() + disappearDuration
        displaylink?.isPaused = false
        initDurationArray(disappearDuration)
    }
    
    func initDurationArray(_ duration: CFTimeInterval) {
        durationArray.removeAll()
        if let length = self.attributedString?.length {
            for _ in 0..<length {
                let progress = CFTimeInterval.random(in: 0..<100)
                durationArray.append(progress * duration * 0.5)
            }
        }
        print(durationArray)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initVariable()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initVariable() {
        displaylink = CADisplayLink(target: self, selector: #selector(updateAttributedString))
        displaylink?.isPaused = true
        displaylink?.add(to: .current, forMode: .common)
    }
    
    @objc func updateAttributedString() {
        guard let attrStr = self.attributedString else {
            return
        }
        let pastDuration = CACurrentMediaTime() - beginTime
        if isAppearing {
            if pastDuration > appearDuration {
                displaylink?.isPaused = true
                isAppearing = false
            }
            for i in 0..<attrStr.length {
                var progress = (pastDuration - durationArray[i]) / appearDuration * 0.5
                if progress > 1 {
                    progress = 1
                } else if progress < 0 {
                    progress = 0
                }
                let color = textColor.withAlphaComponent(CGFloat(progress) * textColorAlpha)
                attributedString?.addAttributes([.foregroundColor: color], range: NSMakeRange(i, 1))
            }
        } else if isDisappearing {
            guard pastDuration <= disappearDuration else {
                displaylink?.isPaused = true
                isDisappearing = false
                if isDisappearing4ChangeText {
                    isDisappearing4ChangeText = false
                    appear()
                }
                return
            }
            
            for i in 0..<attrStr.length {
                var progress = (pastDuration - durationArray[i]) / disappearDuration * 0.5
                if progress > 1 {
                    progress = 1
                } else if progress < 0 {
                    progress = 0
                }
                
                let color = textColor.withAlphaComponent(CGFloat(1 - progress) * textColorAlpha)
                attributedString?.addAttributes([.foregroundColor: color], range: NSMakeRange(i, 1))
            }
        }
        attributedText = attributedString
    }
}

