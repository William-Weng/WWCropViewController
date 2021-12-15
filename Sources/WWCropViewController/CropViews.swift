//
//  CropViews.swift
//  WWCropViewController
//
//  Created by William.Weng on 2021/12/15.
//

import UIKit

/// 裁切框
final class CropView: UIView {
    
    override func draw(_ rect: CGRect) { super.draw(rect) }
    
    /// 圓形裁切框
    func circle(_ size: CGSize) {
        initSetting(size)
        layer._maskedCorners(radius: self.bounds.height / 2.0)
        subviews._isHidden()
        _gestureRecognizerSetting(types: [.drag, .scale])
    }
    
    /// 四邊形裁切框
    func rectangle(_ size: CGSize) {
        initSetting(size)
        layer._maskedCorners(radius: 0)
        subviews._isHidden(false)
        _gestureRecognizerSetting(types: [.drag])
    }
    
    /// 等比例四邊形裁切框
    func scaleRectangle(_ size: CGSize) {
        initSetting(size)
        layer._maskedCorners(radius: 0)
        subviews._isHidden()
        _gestureRecognizerSetting(types: [.drag, .scale])
    }
    
    /// 初始化設定
    private func initSetting(_ size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = true
        transform = .identity
        frame.size = size
    }
}

/// 四角的縮放框
final class ZoomView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _gestureRecognizerSetting(types: [.zoom])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _gestureRecognizerSetting(types: [.zoom])
    }
}
