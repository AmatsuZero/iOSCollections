//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//: [在 iOS 中实现谷歌灭霸彩蛋](https://juejin.im/post/5cc652adf265da03540316e3)

// Present the view controller in the Live View window
let controller = MyViewController()
PlaygroundPage.current.liveView = MyViewController()
