//
//  Extension+.swift
//  WWCropViewController
//
//  Created by William.Weng on 2021/12/15.
//

import UIKit

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}

// MARK: - Collection (class function)
extension Collection where Self.Element: UIView {
    
    /// 將所有Subview隱藏
    /// - Parameter isHidden: Bool
    func _isHidden(_ isHidden: Bool = true) {
        self.forEach { view in view.isHidden = isHidden }
    }
}

// MARK: - Array (class function)
extension Array {
    
    /// [仿javaScript的forEach()](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach)
    func _forEach(_ forEach: (Int, Element, Self) -> Void) {
                
        for (index, object) in self.enumerated() {
            forEach(index, object, self)
        }
    }
}

// MARK: - CGPoint (class function)
extension CGPoint {
    
    /// CGPoint加法
    /// - Parameters:
    ///   - x: CGFloat
    ///   - y: CGFloat
    /// - Returns: CGPoint
    func _add(x: CGFloat , y: CGFloat) -> CGPoint { return CGPoint(x: self.x + x, y: self.y + y) }
}

// MARK: - CGSize (class function)
extension CGSize {
    
    /// CGSize加法
    /// - Parameters:
    ///   - width: CGFloat
    ///   - height: CGFloat
    /// - Returns: CGSize
    func _add(width: CGFloat , height: CGFloat) -> CGSize { return CGSize(width: self.width + width, height: self.height + height) }
}

// MARK: - CALayer (class function)
extension CALayer {
    
    /// 設定圓角
    /// - 可以個別設定要哪幾個角
    /// - 預設是四個角全是圓角
    /// - Parameters:
    ///   - radius: 圓的半徑
    ///   - corners: 圓角要哪幾個邊
    func _maskedCorners(radius: CGFloat, corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        self.masksToBounds = true
        self.maskedCorners = corners
        self.cornerRadius = radius
    }
}

// MARK: - UIView (class function)
extension UIView {
    
    /// [座標轉換 - 中點](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/利用轉換座標的-convert-function-判斷點選的-cell-1eee56a57d3b)
    /// - scrollView.convert(centerView.center, from: centerView.superview)
    /// - Parameter view: 對應的View
    /// - Returns: CGPoint
    func _center(from view: UIView) -> CGPoint {
        let centerFromView = convert(view.center, from: view.superview)
        return centerFromView
    }
    
    /// 設定GestureRecognizer (拖曳 / 縮放 / 旋轉 / 比例)
    /// - Parameter types: Set<Constant.GestureRecognizer>
    func _gestureRecognizerSetting(types: Set<Constant.GestureRecognizer> = [.drag, .scale, .rotation]) {
        
        gestureRecognizers?.forEach({ recognizer in
            removeGestureRecognizer(recognizer)
        })
        
        if types.contains(.drag) { addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(_handleDrag(_:)))) }
        if types.contains(.zoom) { addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(_handleZoom(_:)))) }
        if types.contains(.scale) { addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(_handleScale(_:)))) }
        if types.contains(.rotation) { addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(_rotationView(_:)))) }
        
        isUserInteractionEnabled = true
    }
    
    /// 取得該View的第一個View => ViewController的第一個View
    /// - Returns: UIView
    func _rootView() -> UIView {
        guard let superview = superview else { return self }
        return superview._rootView()
    }
}

// MARK: - UIView (@objc class function)
extension UIView {
    
    // 移動View (歸零)
    @objc func _handleDrag(_ pan: UIPanGestureRecognizer) {
        
        guard let panLocation = Optional.some(pan.translation(in: self._rootView())),
              let view = pan.view
        else {
            return
        }
        
        let newCenter = view.center._add(x: panLocation.x, y: panLocation.y)
        
        view.center = newCenter
        pan.setTranslation(.zero, in: pan.view)
    }
    
    /// [放大UIView (歸零)](https://stackoverflow.com/questions/18681901/setting-alpha-on-uiview-sets-the-alpha-on-its-subviews-which-should-not-happen)
    /// - Parameter pan: [UIPanGestureRecognizer](https://stackoverflow.com/questions/11368440/can-i-disable-autolayout-for-a-specific-subview-at-runtime)
    @objc func _handleZoom(_ pan: UIPanGestureRecognizer) {
        
        guard let baseView = superview else { return }
        
        zoomSetting(with: pan, baseView: baseView)
        pan.setTranslation(.zero, in: pan.view)
    }
    
    /// 放大View比例 (歸零)
    @objc func _handleScale(_ pinch: UIPinchGestureRecognizer) {
        
        guard let view = pinch.view else { return }
        
        if pinch.state == .began || pinch.state == .changed {
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1.0
        }
    }
    
    /// 旋轉View (歸零)
    @objc func _rotationView(_ rotation: UIRotationGestureRecognizer) {
        
        guard let view = rotation.view else { return }
        
        view.transform = view.transform.rotated(by: rotation.rotation)
        rotation.rotation = 0
    }
}

// MARK: - UIView (private class function)
extension UIView {
    
    /// 設定縮放 => 移動中點 / 預設是置中縮放 / 根據Constant.CropViewTag來分辨位置
    /// - Parameters:
    ///   - pan: UIPanGestureRecognizer
    ///   - baseView: UIView
    private func zoomSetting(with pan: UIPanGestureRecognizer, baseView: UIView) {
        
        let panLocation = pan.translation(in: pan.view)
        let frame = baseView.frame
        let newCenter = baseView.center
        
        var newFrame = CGRect(origin: frame.origin, size: frame.size._add(width: panLocation.x, height: panLocation.y))
        
        baseView.translatesAutoresizingMaskIntoConstraints = true
        
        guard let tag = Constant.CropViewTag(rawValue: self.tag) else {
            baseView.frame = newFrame
            baseView.center = newCenter; return
        }
        
        switch tag {
        case .leftTop: newFrame = CGRect(origin: frame.origin, size: frame.size._add(width: -panLocation.x, height: -panLocation.y))
        case .rightTop: newFrame = CGRect(origin: frame.origin, size: frame.size._add(width: panLocation.x, height: -panLocation.y))
        case .leftBottom: newFrame = CGRect(origin: frame.origin, size: frame.size._add(width: -panLocation.x, height: panLocation.y))
        case .rightBottom: break
        }
        
        baseView.frame = newFrame
        baseView.center = CGPoint(x: newCenter.x + panLocation.x * 0.5, y: newCenter.y + panLocation.y * 0.5)
    }
}

// MARK: - UIImage (class function)
extension UIImage {
    
    /// 改變圖片大小
    /// - Parameter size: 設定的大小
    /// - Returns: UIImage
    func _resized(for size: CGSize) -> UIImage {

        let renderer = UIGraphicsImageRenderer(size: size)
        let resizeImage = renderer.image { (context) in draw(in: renderer.format.bounds) }
        
        return resizeImage
    }
    
    /// 修正圖片在Exif上的方向設定值
    /// - 重畫一張
    /// - Returns: UIImage?
    func _normalized() -> UIImage? {
        
        guard imageOrientation != .up else { return self }

        let normalizedImage = _resized(for: size)
        return normalizedImage
    }
}

// MARK: - UIImageView (class function)
extension UIImageView {
    
    /// [裁切圖片 - 長方形](https://www.codenong.com/a7e72f95108711ebb8a3/)
    /// - 把照片轉正 => 算出照片跟View的比例 => 裁切圖片
    /// - Parameters:
    ///   - rect: [CGRect](https://www.advancedswift.com/crop-image/)
    /// - Returns: UIImage?
    func _cropImage(with rect: CGRect) -> UIImage? {
        
        guard let image = image?._normalized(),
              let cgImage = image.cgImage,
              let scale = Optional.some((x: CGFloat(cgImage.width) / self.frame.width, y: CGFloat(cgImage.height) / self.frame.height)),
              let cropRect = Optional.some(rect.applying(CGAffineTransform(scaleX: scale.x, y: scale.y))),
              let croppingImage = cgImage.cropping(to: cropRect)
        else {
            return nil
        }
        
        return UIImage(cgImage: croppingImage, scale: UIScreen.main.scale, orientation: .up)
    }
    
    /// [裁切圖片 - 橢圓形](https://www.advancedswift.com/crop-image/)
    /// - Parameters:
    ///   - rect: [CGRect](https://stackoverflow.com/questions/32041420/cropping-image-with-swift-and-put-it-on-center-position)
    /// - Returns: UIImage?
    func _cropCircleImage(with rect: CGRect) -> UIImage? {
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: rect.size))
        return _cropPolygonImage(with: rect, path: path)
    }
    
    /// [裁切圖片 - 多邊形](https://www.advancedswift.com/crop-image/)
    /// - 先切出正方形 => 再畫路徑去切
    /// - Parameters:
    ///   - rect: [CGRect](https://stackoverflow.com/questions/32041420/cropping-image-with-swift-and-put-it-on-center-position)
    ///   - path: [UIBezierPath?](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/運用-uibezierpath-繪製形-3c858e194676)
    /// - Returns: [UIImage?](https://www.codenong.com/a7e72f95108711ebb8a3/)
    func _cropPolygonImage(with rect: CGRect, path: UIBezierPath? = nil) -> UIImage? {
        
        guard let cropImage = _cropImage(with: rect),
              let path = path
        else {
            return nil
        }
        
        let circleImage = UIGraphicsImageRenderer(size: rect.size, format: cropImage.imageRendererFormat).image { context in
            path.addClip()
            cropImage.draw(in: CGRect(origin: .zero, size: rect.size))
        }
        
        return circleImage
    }
}
