//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    var blingBlingLabel = BlingBlingLabel()
    let textArray = ["      轻轻的我走了，\n      正如我轻轻的来；\n      我轻轻的招手，\n      作别西天的云彩。",
                     "Very quietly I take my leave, \nAs quietly as I came here; \nQuietly I wave good-bye, \nTo the rosy clouds in the western sky.",
                     "      夏天的飞鸟\n      飞到我的窗前唱歌，\n      又飞去了。\n      秋天的黄叶，\n      它们没有什么可唱，\n      只叹息一声，\n      飞落在那里。",
                     "Stray birds of summer come to my window to sing and fly away.\nAnd yellow leaves of autumn, which have no songs, flutter and fall there with a sign. "];
    var i = 0
    
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .init(red: 42/255.0, green: 49/255.0, blue: 67/255.0, alpha: 1)
        
        blingBlingLabel.frame = .init(origin: .init(x: 100, y: 100), size: .init(width: 300, height: 200))
        blingBlingLabel.needAnimation = true
        blingBlingLabel.numberOfLines = 0
        blingBlingLabel.font = .systemFont(ofSize: 23)
        blingBlingLabel.textColor = .init(white: 1, alpha: 0.7)
        blingBlingLabel.isUserInteractionEnabled = true
        view.addSubview(blingBlingLabel)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.center)
        changeText()
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeText))
        blingBlingLabel.addGestureRecognizer(tap)
    }
    
    @objc func changeText() {
        blingBlingLabel.text = textArray[i % textArray.count]
        i += 1
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
