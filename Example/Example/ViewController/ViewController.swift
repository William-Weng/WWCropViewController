//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2021/12/15.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWCropViewController

import UIKit
import WWPrint
import WWCropViewController

final class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    private let angleZoomViewImages: [UIImage] = ([#imageLiteral(resourceName: "Angle_LeftTop"), #imageLiteral(resourceName: "Angle_RightTop"), #imageLiteral(resourceName: "Angle_LefttBottom"), #imageLiteral(resourceName: "Angle_RightBottom")])
    
    private var cropViewController: WWCropViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewSetting()
    }
    
    @IBAction func cropPhotoAction(_ sender: UIButton) {
        _ = cropViewController?.cropPhoto()
        wwPrint(cropViewController?.photo)
    }
    
    @IBAction func recoverPhotoAction(_ sender: UIButton) { _ = cropViewController?.recoverOriginalPhoto() }
    @IBAction func cropViewTypeAction1(_ sender: UIButton) { cropViewController?.cropViewTypeSetting(.rectangle) }
    @IBAction func cropViewTypeAction2(_ sender: UIButton) { cropViewController?.cropViewTypeSetting(.scaleRectangle(.to4_3)) }
    @IBAction func cropViewTypeAction3(_ sender: UIButton) { cropViewController?.cropViewTypeSetting(.scaleRectangle(.to9_16)) }
}

// MARK: - 基本設定
private extension ViewController {
    
    /// 基本設定
    func containerViewSetting() {
        
        guard let viewController = WWCropViewController.build() else { return }
                
        viewController.photo = #imageLiteral(resourceName: "Wallpaper")
        viewController.initSetting(cropViewType: .circle, angleZoomViewImages: angleZoomViewImages, cropViewBackgroundColor: .blue.withAlphaComponent(0.3))
        
        cropViewController = viewController
        cropViewController?.loadViewIfNeeded()
        
        self._changeContainerView(to: viewController, at: containerView)
    }
}

