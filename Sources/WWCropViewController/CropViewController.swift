//
//  CropViewController.swift
//  WWCropViewController
//
//  Created by William.Weng on 2021/12/15.
//

import UIKit

// MARK: - 裁切圖片的ViewController
open class WWCropViewController: UIViewController {
        
    @IBOutlet weak var cropView: CropView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var myImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var angleZoomViews: [ZoomView]!
    
    public var photo: UIImage?
    
    var angleZoomViewImages: [UIImage]?
    var cropViewBackgroundColor: UIColor = .black.withAlphaComponent(0.3)
    var cropViewType: Constant.CropViewType = .rectangle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        cropViewTypeSetting(cropViewType)
        angleImagesSetting(angleZoomViewImages)
    }
        
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = recoverOriginalPhoto()
    }
}

// MARK: - 開放使用
public extension WWCropViewController {
    
    /// 建立WWCropViewController
    /// - Returns: WWCropViewController?
    static func build() -> WWCropViewController? {
        guard let viewController = UIStoryboard(name: "Package", bundle: Bundle.module).instantiateInitialViewController() as? WWCropViewController else { return nil }
        return viewController
    }
}

// MARK: - 開放使用
public extension WWCropViewController {
    
    /// 初始化設定
    /// - Parameters:
    ///   - cropViewType: 裁切框外型
    ///   - angleZoomViewImages: 四邊形裁切框的四邊圖示
    ///   - cropViewBackgroundColor: 裁切框背景色
    func initSetting(cropViewType: Constant.CropViewType = .rectangle, angleZoomViewImages: [UIImage]? = nil, cropViewBackgroundColor: UIColor = .black.withAlphaComponent(0.3)) {
        self.cropViewType = cropViewType
        self.angleZoomViewImages = angleZoomViewImages
        self.cropViewBackgroundColor = cropViewBackgroundColor
    }
    
    /// 裁切圖片
    /// - Returns: UIImage?
    func cropPhoto() -> UIImage? {
        
        myImageView.image = cropImage(for: cropViewType)
        cropView.center = view.center
        updateImageViewSizeConstraint()
        
        return myImageView.image
    }
    
    /// 設定縮放框比例 / 種類 (1:1 / 4:3 / 16:9)
    /// - Parameter type: Constant.CropViewType
    func cropViewTypeSetting(_ type: Constant.CropViewType) {
        
        switch type {
        case .rectangle: cropView.rectangle(Constant.CropViewMultiplier.to1_1.size(with: view))
        case .circle: cropView.circle(Constant.CropViewMultiplier.to1_1.size(with: view))
        case .scaleRectangle(let multiplier): cropView.scaleRectangle(multiplier.size(with: view))
        }
        
        cropView.center = view.center
        cropView.backgroundColor = cropViewBackgroundColor
        
        cropViewType = type
    }
    
    /// 還原成一開始的照片
    /// - Returns: UIImage?
    func recoverOriginalPhoto() -> UIImage? {
        
        myImageView.image = photo
        updateImageViewSizeConstraint()
        
        return myImageView.image
    }
    
    /// 設定縮放框的底色
    /// - Parameter color: UIColor
    func updateCropViewBackgroundColor(_ color: UIColor) {
        cropViewBackgroundColor = color
        cropView.backgroundColor = cropViewBackgroundColor
    }
    
    /// 設定縮放的四角圖示 (↖左上 / ↗右上 / ↙左下 / ↘右下)
    /// - Parameter images: [UIImage]?
    func angleImagesSetting(_ images: [UIImage]?) {
        
        guard let images = images else { return }
        
        angleZoomViews._forEach { index, angleZoomView, _ in
            angleZoomView.image = images[safe: index]
        }
    }
}

// MARK: - 小工具
private extension WWCropViewController {
    
    /// 裁切圖片 - 四邊形 / 圓形
    /// - Returns: UIImage?
    func cropImage(for type: Constant.CropViewType) -> UIImage? {
        
        cropView.center = myImageView._center(from: cropView)
        
        switch type {
        case .rectangle: return myImageView._cropImage(with: cropView.frame)
        case .scaleRectangle: return myImageView._cropImage(with: cropView.frame)
        case .circle: return myImageView._cropCircleImage(with: cropView.frame)
        }
    }
    
    /// 更新ImageView的尺寸 => 以滿版為主 (寬 or 長)
    func updateImageViewSizeConstraint() {
        
        guard let image = myImageView.image else { return }
        
        let newHeight = image.size.height * (view.frame.width / image.size.width)
        let newWidth = image.size.width * (view.frame.height / image.size.height)
        
        if (newWidth > view.frame.width) {
            myImageViewWidthConstraint.constant = view.frame.width
            myImageViewHeightConstraint.constant = newHeight
        }
        
        if (newHeight > view.frame.height) {
            myImageViewWidthConstraint.constant = newWidth
            myImageViewHeightConstraint.constant = view.frame.height
        }
    }
}
