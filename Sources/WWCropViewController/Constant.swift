//
//  Constant.swift
//  WWCropViewController
//
//  Created by William.Weng on 2021/12/15.
//

import UIKit
import AVFoundation

/// 公用常數
open class Constant {
    
    /// 設定縮放框的比例 (1:1 / 4:3 / 16:9)
    public enum CropViewMultiplier {
        
        case to1_1
        case to4_3
        case to16_9
        case to3_4
        case to9_16
        
        /// 計算尺寸 (長或寬的一半為準)
        /// - Parameter view: UIView
        /// - Returns: CGSize
        func size(with view: UIView) -> CGSize {
            
            let baseWidth = view.frame.width * 0.8
            let baseHeight = view.frame.height * 0.8
            
            switch self {
            case .to1_1: return CGSize(width: baseWidth, height: baseWidth)
            case .to4_3: return CGSize(width: baseWidth, height: baseWidth * 3 / 4)
            case .to16_9: return CGSize(width: baseWidth, height: baseWidth * 9 / 16)
            case .to3_4: return CGSize(width: baseHeight * 3 / 4, height: baseHeight)
            case .to9_16: return CGSize(width: baseHeight * 9 / 16, height: baseHeight)
            }
        }
    }
    
    /// 裁切框的種類
    public enum CropViewType {
        case scaleRectangle(_ scale: CropViewMultiplier)
        case rectangle
        case circle
    }
}

// MARK: - 自訂常數
extension Constant {
    
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
