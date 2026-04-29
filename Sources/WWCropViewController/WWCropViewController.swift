//
//  WWCropViewController.swift
//  WWCropViewController
//
//  Created by William.Weng on 2026/4/29.
//

import UIKit
import CoreImage

// MARK: - 進行非破壞性渲染的裁切圖片
open class WWCropViewController: UIViewController {
    
    struct CropRecipe { var normalizedRect: CGRect }
    
    public static let new = build()
        
    @IBOutlet weak var cropView: CropOverlayView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cropViewWidthConstraint: NSLayoutConstraint!

    private var zoomScale = 1.0...8.0
    private let ciContext = CIContext()

    public override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
}

// MARK: - 開放使用
public extension WWCropViewController {
    
    /// [設定縮放比例範圍](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用-scroll-view-縮放圖片-72960fb1b332)
    /// - Parameter zoomScale: 允許的最小與最大縮放倍率。
    func configure(zoomScale: ClosedRange<Double>) {
        self.zoomScale = zoomScale
        scrollViewZoomScale(zoomScale)
    }
    
    /// [設定要進行裁切的原始影像](https://juejin.cn/post/7068085772384993294)
    /// - Parameter image: 目標 UI 圖片物件。
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
    
    /// 執行裁切操作並取得裁切後的圖片 => 此函式會自動計算當前裁切框 (CropView) 對應原圖的歸一化座標，並透過渲染管線輸出最終的裁切影像。
    /// - Returns: 裁切完成後的 UIImage 物件，若影像來源遺失則回傳 nil。
    func cropImage() -> UIImage? {

        guard let image = imageView.image else { return nil }
        
        let rect = normalizedRect()
        let recipe = CropRecipe(normalizedRect: rect)
        let croppedImage = renderCroppedImage(from: image, with: recipe)
        
        return croppedImage
    }
}

// MARK: - UIScrollViewDelegate
extension WWCropViewController: UIScrollViewDelegate {}
public extension WWCropViewController {

     func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return imageView
     }
}

// MARK: - 開放使用
public extension WWCropViewController {
    
    /// 建立WWCropViewController
    /// - Returns: WWCropViewController?
    static func build() -> WWCropViewController? {
        guard let viewController = UIStoryboard(name: "Package", bundle: .module).instantiateInitialViewController() as? WWCropViewController else { return nil }
        return viewController
    }
}

// MARK: - 小工具
private extension WWCropViewController {
    
    /// 初始化設定
    func initSetting() {
        
        scrollView.delegate = self
        scrollViewZoomScale(zoomScale)
        scrollView.bouncesZoom = true
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        
        cropViewWidthConstraint.constant = view.frame.width * 0.6
        cropView._gestureRecognizerSetting(types: [.drag])
    }
    
    /// 設定ScrollView縮放率
    /// - Parameter zoomScale: ClosedRange<Double>
    func scrollViewZoomScale(_ zoomScale: ClosedRange<Double>)  {
        scrollView.minimumZoomScale = zoomScale.lowerBound
        scrollView.maximumZoomScale = zoomScale.upperBound
    }
    
    /// 計算並回傳裁切框相對於圖片原始尺寸的歸一化矩形 (Normalized Rect) => 此歸一化矩形以 0.0 到 1.0 的比例表示，使其完全與解析度及放大倍率解耦。
    /// - Returns: CGRect
    func normalizedRect() -> CGRect {
        
        let presentationFrame = presentationLayerFrame() ?? imageView.frame
        let cropRectInScrollView = cropRect(in: scrollView)
        let x = cropRectInScrollView.minX - presentationFrame.minX
        let y = cropRectInScrollView.minY - presentationFrame.minY
        
        return .init(
            x: x / presentationFrame.width,
            y: y / presentationFrame.height,
            width: cropView.bounds.width / presentationFrame.width,
            height: cropView.bounds.height / presentationFrame.height
        )
    }
    
    /// 執行非破壞性影像裁切並回傳裁切後的結果 => 本函式利用 Core Image 管線進行處理，不會修改原始影像來源。
    /// - Parameters:
    ///   - uiImage: 欲進行裁切的來源圖片。
    ///   - recipe: 包含裁切比例範圍的配方物件。
    /// - Returns: 裁切完成後的 UIImage 物件，若處理失敗則回傳 nil。
    func renderCroppedImage(from uiImage: UIImage, with recipe: CropRecipe) -> UIImage? {
        
        guard let ciImage = CIImage(image: uiImage) else { return nil }
        
        let ciRect = calculatePixelRect(for: ciImage, recipe: recipe)
        let croppedCIImage = ciImage.cropped(to: ciRect)
        
        guard let cgImage = ciContext.createCGImage(croppedCIImage, from: ciRect) else { return nil }
        
        return .init(cgImage: cgImage)
    }
}

// MARK: - 小工具
private extension WWCropViewController {
    
    /// 獲取當前視覺上最準確的矩形範圍 => 使用 presentationLayer 可以確保在動畫執行期間或因縮放 (Zoom) 導致的 frame 變更時，獲取的座標永遠與使用者螢幕上看到的位置保持同步 (包含 transform 變換)。
    /// - Returns: CGRect?
    func presentationLayerFrame() -> CGRect? {
        return imageView.layer.presentation()?.frame
    }
    
    /// 計算裁切框相對於 ScrollView 的絕對位置 => 將 cropView 的範圍從自身座標系轉換到 ScrollView 的座標系中，確保計算基準點統一在 ScrollView 的 content 空間內。
    /// - Parameter scrollView: UIScrollView
    /// - Returns: CGRect
    func cropRect(in scrollView: UIScrollView) -> CGRect {
        return cropView.convert(cropView.bounds, to: scrollView)
    }
    
    /// 將歸一化比例轉換為 Core Image 的像素坐標矩形 => 由於 UIKit (左上角原點) 與 Core Image (左下角原點) 的座標系不同，本函式會自動執行 Y 軸的翻轉計算，確保裁切範圍與使用者在 UI 上選取的區域完全吻合。
    /// - Parameters:
    ///   - ciImage: 原始影像 (用於獲取其實際像素解析度)。
    ///   - recipe: 包含歸一化裁切比例的配方物件。
    /// - Returns: Core Image 座標系下的像素像素坐標矩形 (CGRect)。
    func calculatePixelRect(for ciImage: CIImage, recipe: CropRecipe) -> CGRect {
        
        let extent = ciImage.extent
        let rect = recipe.normalizedRect
        
        let width = rect.width * extent.width
        let height = rect.height * extent.height
        
        let x = rect.minX * extent.width
        let y = extent.height - (rect.maxY * extent.height)
        
        return .init(x: x, y: y, width: width, height: height)
    }
}
