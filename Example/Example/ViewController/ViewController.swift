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
    
    private var cropViewController: WWCropViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewSetting()
    }
    
    @IBAction func cropPhotoAction(_ sender: UIButton) { _ = cropViewController?.cropPhoto() }
    @IBAction func recoverPhotoAction(_ sender: UIButton) { _ = cropViewController?.recoverOriginalPhoto() }
    @IBAction func cropViewTypeAction1(_ sender: UIButton) { cropViewController?.cropViewTypeSetting(.rectangle) }
    @IBAction func cropViewTypeAction2(_ sender: UIButton) { cropViewController?.cropViewTypeSetting(.scaleRectangle(.to4_3)) }
    @IBAction func cropViewTypeAction3(_ sender: UIButton) { cropViewController?.cropViewTypeSetting(.scaleRectangle(.to9_16)) }
}

extension ViewController {
 
    private func containerViewSetting() {
        
        guard let viewController = WWCropViewController.build() else { return }
        
        cropViewController = viewController
        
        viewController.photo = #imageLiteral(resourceName: "Wallpaper")
        viewController.angleZoomViewImages = ([#imageLiteral(resourceName: "Angle_LeftTop"), #imageLiteral(resourceName: "Angle_RightTop"), #imageLiteral(resourceName: "Angle_LefttBottom"), #imageLiteral(resourceName: "Angle_RightBottom")])
        viewController.cropViewBackgroundColor = .blue.withAlphaComponent(0.3)
        viewController.cropViewType = .circle
        
        self._changeContainerView(to: viewController, at: containerView)
    }
}

extension UIViewController {
    
    /// [改變ContainerView](https://disp.cc/b/11-9XMd)
    /// - Parameters:
    ///   - oldViewController: UIViewController
    ///   - newViewController: UIViewController
    ///   - containerView: UIView
    func _changeContainerView(from oldViewController: UIViewController? = nil ,to newViewController: UIViewController, at containerView: UIView) {
        
        oldViewController?.willMove(toParent: nil)
        oldViewController?.view.removeFromSuperview()
        oldViewController?.removeFromParent()
        
        addChild(newViewController)
        containerView.addSubview(newViewController.view)
        newViewController.view.frame = containerView.frame
        newViewController.didMove(toParent: self)
    }
}

