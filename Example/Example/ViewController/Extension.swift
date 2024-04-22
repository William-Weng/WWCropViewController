//
//  Extension.swift
//  Example
//
//  Created by William.Weng on 2024/4/22.
//

import UIKit

// MARK: - UIViewController
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
