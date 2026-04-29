//
//  ZoomView.swift
//  WWCropViewController
//
//  Created by William.Weng on 2026/4/29.
//

import UIKit

// MARK: - 用於在邊角縮放的View
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
