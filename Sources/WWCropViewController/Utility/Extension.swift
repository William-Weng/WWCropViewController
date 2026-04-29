//
//  Extension.swift
//  WWCropViewController
//
//  Created by William.Weng on 2026/4/29.
//

import UIKit

// MARK: - CGPoint Operator
extension CGPoint {
    
    static func + (lhs: CGPoint, rhs: (x: CGFloat, y: CGFloat)) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

// MARK: - CGSize Operator
extension CGSize {
    static func + (lhs: CGSize, rhs: (width: CGFloat, height: CGFloat)) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}

// MARK: - UIView (class function)
extension UIView {
    
    /// 設定GestureRecognizer (拖曳 / 縮放 / 旋轉 / 比例)
    /// - Parameter types: Set<WWCropViewController.GestureRecognizer>
    func _gestureRecognizerSetting(types: Set<WWCropViewController.GestureRecognizer> = [.drag, .scale, .rotation]) {
        
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
        
        let newCenter = view.center + (x: panLocation.x, y: panLocation.y)
        
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
    
    /// 設定縮放 => 移動中點 / 預設是置中縮放 / 根據CropViewTag來分辨位置
    /// - Parameters:
    ///   - pan: UIPanGestureRecognizer
    ///   - baseView: UIView
    private func zoomSetting(with pan: UIPanGestureRecognizer, baseView: UIView) {
        
        let panLocation = pan.translation(in: pan.view)
        let frame = baseView.frame
        let newCenter = baseView.center
        
        var newFrame = CGRect(origin: frame.origin, size: frame.size + (width: panLocation.x, height: panLocation.y))
        
        baseView.translatesAutoresizingMaskIntoConstraints = true
        
        guard let tag = WWCropViewController.CropViewTag(rawValue: self.tag) else {
            baseView.frame = newFrame
            baseView.center = newCenter; return
        }
        
        switch tag {
        case .leftTop: newFrame = CGRect(origin: frame.origin, size: frame.size + (width: -panLocation.x, height: -panLocation.y))
        case .rightTop: newFrame = CGRect(origin: frame.origin, size: frame.size + (width: panLocation.x, height: -panLocation.y))
        case .leftBottom: newFrame = CGRect(origin: frame.origin, size: frame.size + (width: -panLocation.x, height: panLocation.y))
        case .rightBottom: break
        }
        
        baseView.frame = newFrame
        baseView.center = CGPoint(x: newCenter.x + panLocation.x * 0.5, y: newCenter.y + panLocation.y * 0.5)
    }
}

