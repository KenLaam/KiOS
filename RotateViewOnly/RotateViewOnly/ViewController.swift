//
//  ViewController.swift
//  RotateViewOnly
//
//  Created by Ken Lâm on 10/26/18.
//  Copyright © 2018 KPU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func deviceRotated(_ note: Notification?) {
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        var rotationAngle: CGFloat = 0
        switch orientation {
        case .portraitUpsideDown:
            rotationAngle = .pi
        case .landscapeLeft:
            rotationAngle = CGFloat(Double.pi / 2)
        case .landscapeRight:
            rotationAngle = CGFloat(-Double.pi / 2)
        default:
            rotationAngle = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            [self.label1, self.label2, self.label3, self.label4].forEach({
                $0?.transform = CGAffineTransform(rotationAngle: rotationAngle)
            })
        })
    }
    
    override var shouldAutorotate: Bool {
        get {
            return UIApplication.shared.statusBarOrientation != .portrait
        }
    }
    
    
    

}

