# [WWCropViewController](https://swiftpackageindex.com/William-Weng)

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![iOS-16.0](https://img.shields.io/badge/iOS-16.0-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWCropViewController)
[![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) 
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## 🎉 相關說明
> [`WWCropViewController` is a lightweight, high-performance image cropping solution designed for iOS development. Built on a **non-destructive editing** architecture and utilizing the `Core Image` rendering pipeline, it ensures lossless quality, remaining completely independent of image scaling or resolution.](https://developer.apple.com/documentation/coreimage/ciimage)

> [`WWCropViewController` 是一個專為 iOS 開發設計的輕量級、高性能圖片裁切解決方案。它採用 **非破壞性編輯 (Non-destructive Editing)** 架構，透過 `Core Image` 渲染管線，確保裁切過程畫質無損，且完全不受圖片縮放與解析度影響。](https://medium.com/程式愛好者/軟體架構-分層架構模式-layered-architecture-a959da09d1c6)

## 📷 [效果預覽](https://peterpanswift.github.io/iphone-bezels/)

[![](https://github.com/user-attachments/assets/24ce7982-c506-4b5c-ba8f-cb874e58c21d)](https://freepngimg.com/png/94945-smash-star-for-3ds-kirby-character)

https://github.com/user-attachments/assets/34dfe487-f3b6-473f-a9bf-e2ef409cc57a

<div align="center">

**⭐ 覺得好用就給個 Star 吧！**

</div>

## 📦 [安裝方式](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
透過 Swift Package Manager 加入專案：
```swift
dependencies: [
    .package(url: "https://github.com/William-Weng/WWCropViewController", .upToNextMinor(from: "2.0.2"))
]
```

## 🚀 特色
*   **非破壞性裁切**：原始圖片始終保持完整，所有裁切行為均為即時渲染，確保最高畫質輸出。
*   **歸一化坐標系統**：裁切區域採用 0.0 ~ 1.0 的比例計算，完美適配圖片在 `UIScrollView` 中的縮放與拖曳。
*   **高性能渲染**：利用 `CIContext` 與 GPU 加速，即便在高解析度圖片下也能保持流暢體驗。
*   **模組化設計**：透過 SPM (Swift Package Manager) 封裝，易於整合與維護。

## 🧠 核心技術原理

### 非破壞性渲染
本套件不直接修改原始像素，而是透過 `CropRecipe` (歸一化矩形) 記錄裁切範圍，並在最後輸出時才交由 `Core Image` 進行渲染。此做法可確保：
1. **畫質保真**：避免多次重複存檔造成的影像壓縮損耗。
2. **靈活性**：裁切參數與原始圖片分離，方便紀錄多組編輯版本。

### 坐標系自動轉換
處理影像裁切最棘手的部分在於 UIKit (左上角原點) 與 Core Image (左下角原點) 的坐標系差異。本套件內建自動轉換機制，處理了 Y 軸翻轉與 `Aspect Fit` 的留白校正，讓開發者只需關注 UI 選取框的邏輯，無需處理繁瑣的像素映射運算。

## 🚀 使用範例

```swift
import UIKit
import WWCropViewController

final class ViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var resultImageView: UIImageView!
    
    private var cropViewController: WWCropViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewSetting()
    }
    
    @IBAction func cropImage(_ sender: UIButton) {
        
        guard let cropImage = cropViewController?.cropImage() else { return }
        resultImageView.image = cropImage
    }
}

private extension ViewController {
    
    func containerViewSetting() {
        
        guard let cropViewController = WWCropViewController.new,
              let image = UIImage(named: "example")
        else {
            return
        }
        
        cropViewController.loadViewIfNeeded()
        cropViewController.setImage(image)
        
        self.cropViewController = cropViewController
        self._changeContainerView(to: cropViewController, at: containerView)
    }
}
```
