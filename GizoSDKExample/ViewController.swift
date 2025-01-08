//
//  ViewController.swift
//  GizoSDKExample
//
//  Created by Mahyar on 2023/12/19.
//

import UIKit
import GizoSDK
import CoreML

class ViewController: UIViewController {
    var model: MLModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
                        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 50, y: 100, width: 250, height: 40)
        btn.backgroundColor = UIColor.blue
        btn.setTitle("Drive Now（With Camera）", for: .normal)
        btn.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let btn2 = UIButton.init(type: .custom)
        btn2.frame = CGRect.init(x: 50, y: 200, width: 250, height: 40)
        btn2.backgroundColor = UIColor.blue
        btn2.setTitle("Drive Now（No Camera）", for: .normal)
        btn2.addTarget(self, action: #selector(onButton2Click), for: .touchUpInside)
        self.view.addSubview(btn2)
    }

    @objc func onButtonClick() {
        let ctrl = DriveViewController.init()
        ctrl.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
        self.present(ctrl, animated: true, completion: nil)
    }
    
    @objc func onButton2Click() {
        let ctrl = DriveNoCameraViewController.init()
        ctrl.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
        self.present(ctrl, animated: true, completion: nil)
    }
}


