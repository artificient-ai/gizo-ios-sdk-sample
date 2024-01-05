//
//  ViewController.swift
//  TestDemo
//
//  Created by Hepburn on 2023/12/19.
//


import UIKit
import GizoSDK
import CoreML

class ViewController: UIViewController, GizoDelegate {
    var model: MLModel?
    func onLoadModel(status: LoadModelStatus) {
        print("onLoadModel status=\(status.rawValue)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        let options: GizoAppOptions = GizoAppOptions()
        options.analysisSetting.modelName = "ArtiSense3.mlmodelc"
        options.analysisSetting.allowAnalysis = true
        options.analysisSetting.saveTtcCsvFile = true
        options.analysisSetting.saveMatrixFile = true
        options.gpsSetting.allowGps = true
        options.gpsSetting.saveCsvFile = true
        options.imuSetting.allowMagneticSensor = true
        options.imuSetting.allowGyroscopeSensor = true
        options.imuSetting.allowAccelerationSensor = true
        options.imuSetting.saveCsvFile = true
        options.batterySetting.checkBattery = true
        options.orientationSetting.allowGravitySensor = true
        options.videoSetting.allowRecording = true
        Gizo.initialize(delegate: self, options: options)
        Gizo.app.loadModel()
        
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
        Gizo.options?.analysisSetting.allowAnalysis = true
        let ctrl = DriveViewController.init()
        ctrl.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
        self.present(ctrl, animated: true, completion: nil)
    }
    
    @objc func onButton2Click() {
        Gizo.options?.analysisSetting.allowAnalysis = false
        let ctrl = DriveNoCameraViewController.init()
        ctrl.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
        self.present(ctrl, animated: true, completion: nil)
    }
}


