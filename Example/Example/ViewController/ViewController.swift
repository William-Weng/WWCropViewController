//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2026/4/29.
//

import UIKit
import WWCropViewController

final class ViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var resultImageView: UIImageView!
    
    private var cropViewController: WWCropViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerViewSetting()
    }
    
    @IBAction func cropImage(_ sender: UIButton) {
        guard let cropImage = cropViewController?.cropImage() else { return }
        resultImageView.image = cropImage
    }
}

private extension ViewController {
    
    func containerViewSetting() {
        
        guard let cropViewController = WWCropViewController.new,
              let image = UIImage(named: "example")
        else {
            return
        }
        
        self.cropViewController = cropViewController
        self._changeContainerView(to: cropViewController, at: containerView)
        
        cropViewController.setImage(image)
        cropViewController.loadViewIfNeeded()
    }
}
