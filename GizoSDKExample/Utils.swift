//
//  Utils.swift
//  GizoSDKExample
//
//  Created by Mahyar Farmani on 2/9/24.
//

import UIKit

extension UIView {
    func showToast(message: String, duration: TimeInterval = 3.0) {
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width / 2 - 75, y: self.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
