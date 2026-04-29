//
//  Constant.swift
//  WWCropViewController
//
//  Created by William.Weng on 2026/4/29.
//

import Foundation

// MARK: - 自訂常數
extension WWCropViewController {
    
    /// [手勢的動作](https://itisjoe.gitbooks.io/swiftgo/content/uikit/uigesturerecognizer.html)
    enum GestureRecognizer {
        case drag
        case zoom
        case scale
        case rotation
    }
    
    /// 縮放用的標示Tag
    enum CropViewTag: Int {
        case leftTop = 25601
        case rightTop
        case leftBottom
        case rightBottom
    }
}
