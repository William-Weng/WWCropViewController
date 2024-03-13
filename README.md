# WWCropViewController
[![Swift-5.6](https://img.shields.io/badge/Swift-5.6-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-14.0](https://img.shields.io/badge/iOS-14.0-pink.svg?style=flat)](https://developer.apple.com/swift/) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

### [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- Crop picture widget.
- 裁切圖片小工具.

![](./Example.gif)

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```
dependencies: [
    .package(url: "https://github.com/William-Weng/WWCropViewController.git", .upToNextMajor(from: "1.0.0"))
]
```

### Function - 可用函式
|函式|功能|
|-|-|
|build()|建立WWCropViewController|
|cropPhoto()|裁切圖片|
|cropViewTypeSetting(_:)|設定縮放框比例 / 種類 (1:1 / 4:3 / 16:9)|
|recoverOriginalPhoto()|還原成一開始的照片|
|updateCropViewBackgroundColor(_:)|設定縮放框的底色|
|angleImagesSetting(_:)|設定縮放的四角圖示 (↖左上 / ↗右上 / ↙左下 / ↘右下)|

### Example
```swift
import UIKit
import WWPrint
import WWCropViewController

final class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    private var cropViewController: WWCropViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewSetting()
    }
    
    @IBAction func cropPhotoAction(_ sender: UIButton) { _ = cropViewController?.cropPhoto() }
    @IBAction func recoverPhotoAction(_ sender: UIButton) { _ = cropViewController?.recoverOriginalPhoto() }
    @IBAction func cropViewTypeAction1(_ sender: UIButton) { cropViewController?.cropViewTypeSetting(.rectangle) }
    @IBAction func cropViewTypeAction2(_ sender: UIButton) { cropViewController?.cropViewTypeSetting(.scaleRectangle(.to4_3)) }
    @IBAction func cropViewTypeAction3(_ sender: UIButton) { cropViewController?.cropViewTypeSetting(.scaleRectangle(.to9_16)) }
}

extension ViewController {
 
    private func containerViewSetting() {
        
        guard let viewController = WWCropViewController.build() else { return }
        
        cropViewController = viewController
        
        viewController.photo = #imageLiteral(resourceName: "Wallpaper")
        viewController.angleZoomViewImages = ([#imageLiteral(resourceName: "Angle_LeftTop"), #imageLiteral(resourceName: "Angle_RightTop"), #imageLiteral(resourceName: "Angle_LefttBottom"), #imageLiteral(resourceName: "Angle_RightBottom")])
        viewController.cropViewBackgroundColor = .blue.withAlphaComponent(0.3)
        viewController.cropViewType = .circle
        
        self._changeContainerView(to: viewController, at: containerView)
    }
}

extension UIViewController {
    
    /// [改變ContainerView](https://disp.cc/b/11-9XMd)
    /// - Parameters:
    ///   - oldViewController: UIViewController
    ///   - newViewController: UIViewController
    ///   - containerView: UIView
    func _changeContainerView(from oldViewController: UIViewController? = nil ,to newViewController: UIViewController, at containerView: UIView) {
        
        oldViewController?.willMove(toParent: nil)
        oldViewController?.view.removeFromSuperview()
        oldViewController?.removeFromParent()
        
        addChild(newViewController)
        containerView.addSubview(newViewController.view)
        newViewController.view.frame = containerView.frame
        newViewController.didMove(toParent: self)
    }
}
```
