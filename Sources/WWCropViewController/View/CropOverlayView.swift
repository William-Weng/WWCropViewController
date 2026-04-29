//
//  CropOverlayView.swift
//  WWCropViewController
//
//  Created by William.Weng on 2026/4/29.
//

import UIKit

// MARK: - CropOverlayView 是一個自定義視圖，用於繪製裁切工具的輔助參考線（九宮格）
final class CropOverlayView: UIView {
    
    private let gridLayer = CAShapeLayer()  // 用於顯示參考線的 CAShapeLayer
    
    /// 從程式碼初始化視圖
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGrid()
    }
    
    /// 從 Storyboard 或 XIB 初始化視圖
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGrid()
    }
    
    /// 確保當視圖大小變更時（例如旋轉或約束觸發），參考線會重新繪製
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGrid()
    }
}

// MARK: - 小工具
private extension CropOverlayView {
    
    /// 繪製九宮格參考線 (繪製水平參考線 / 垂直參考線)
    /// - Parameters:
    ///   - count: 將裁切範圍切割的份數（預設為 3，即 3x3 九宮格）
    ///   - strokeColor: 線條顏色（預設為半透明白色）
    func setupGrid(count: Int = 3, strokeColor: UIColor = .white.withAlphaComponent(0.5)) {
        
        let path = UIBezierPath()
        let width = bounds.width
        let height = bounds.height
        
        (1..<count).forEach { index in
            let y = height * CGFloat(index) / CGFloat(count)
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: width, y: y))
        }
        
        (1..<count).forEach { index in
            let x = width * CGFloat(index) / CGFloat(count)
            path.move(to: CGPoint(x: 0, y: 0)) // 這行多餘，可省略
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: height))
        }
        
        gridLayer.path = path.cgPath
        gridLayer.strokeColor = strokeColor.cgColor
        gridLayer.lineWidth = 1.0
        
        layer.addSublayer(gridLayer)
    }
}
