//
//  DriveNoCameraViewController.swift
//  TestDemo
//
//  Created by Hepburn on 2024/1/4.
//

import UIKit
import GizoSDK
import CoreLocation
import CoreMotion

class DriveNoCameraViewController: UIViewController, GizoDelegate {
    
    private var timeView: DriveTimeView?
    private var button: UIButton?
    private var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Gizo.shared.delegate = self
//        Gizo.shared.enableDetections()
    
        self.view.backgroundColor = UIColor.white
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect.init(x: 20, y: 40, width: 40, height: 40);
        backBtn.setImage(UIImage.init(named: "lnr_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(onBackClick), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        timeView = DriveTimeView.init(frame: CGRect.init(x: 50, y: 100, width: 253, height: 48))
        view.addSubview(timeView!)
        
        button = UIButton.init(type: .custom)
        button!.frame = CGRect.init(x: 100, y: 200, width: 200, height: 40)
        button!.backgroundColor = UIColor.blue
        button!.setTitle("Permission", for: .normal)
        button!.addTarget(self, action: #selector(onPermissionClick), for: .touchUpInside)
        self.view.addSubview(button!)
        
        
        button = UIButton.init(type: .custom)
        button!.frame = CGRect.init(x: 100, y: 400, width: 200, height: 40)
        button!.backgroundColor = UIColor.blue
        button!.setTitle("Start", for: .normal)
        button!.setTitle("Stop", for: .selected)
        button!.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        self.view.addSubview(button!)
        
    }
    
    @objc func onPermissionClick(){
        CLLocationManager().requestWhenInUseAuthorization()
        CLLocationManager().requestAlwaysAuthorization()
        
        let tempActivityManager = CMMotionActivityManager()
        tempActivityManager.startActivityUpdates(to: .main) { (activity) in
            tempActivityManager.stopActivityUpdates()
        }
    }
    
    @objc func onButtonClick() {
        if (!isRecording) {
            button?.isSelected = true
            startDrive()
        }
        else {
            button?.isSelected = false
            stopDrive()
        }
    }
    
    func startDrive() {
    
        timeView?.startTimer()
        
        var noCameraSetting = GizoNoCameraSetting()
        noCameraSetting.stopRecordingSetting = GizoStopRecordingSetting(stopRecordingOnLowBatteryLevel: 10)
   
        do {
            try Gizo.shared.startRecording(noCameraSetting)
        } catch {
            print("An unknown error occurred: \(error)")
        }
        
        isRecording = true
    }
    
    func stopDrive() {
        timeView?.stopTimer()
        Gizo.shared.stopRecording()
        isRecording = false
    }
    
    @objc func onBackClick() {
        self.dismiss(animated: true)
    }
    
    func didStartRecording() {
        button?.isSelected = true
        isRecording = true
        timeView?.startTimer()
    }
    
    func didStopRecording() {
        isRecording = false
        button?.isSelected = false
        timeView?.stopTimer()
        
    }
}
