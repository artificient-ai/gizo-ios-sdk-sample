//
//  DriveViewController.swift
//  TestFMKDemo
//
//  Created by Hepburn on 2023/12/7.
//

import UIKit
import GizoSDK
import CoreLocation

class DriveViewController: UIViewController, GizoAnalysisDelegate {
    var previewView: UIView!
    var recordBtn: UIButton?
    var previewBtn: UIButton?
    var speedLabel: UILabel!
    var speedLimitLabel: UILabel!
    
    func onImuSensor(acceleration: NSDictionary?, linearAcceleration: NSDictionary?, accelerationUnc: NSDictionary?, gyroscope: NSDictionary?, magnetic: NSDictionary?, gravity: NSDictionary?) {
        print("onImuSensor: acceleration=\(String(describing: acceleration)) linearAcceleration=\(String(describing: linearAcceleration)) accelerationUnc=\(String(describing: accelerationUnc)) gyroscope=\(String(describing: gyroscope)) magnetic=\(String(describing: magnetic)) gravity=\(String(describing: gravity))")
    }

    func onSessionStatus(inProgress: Bool, previewAttached: Bool) {
        print("onSessionStatus: inProgress=\(inProgress) previewAttached=\(previewAttached)")
    }
    
    func onAnalysisResult(preview: UIImage?, ttc: Float?, ttcStatus: TTCStatus, frontObjectDistance: String, egoSpeed: Float?, gpsTime: String) {
        print("onAnalysisResult: ttc=\(String(describing: ttc)) ttcStatus=\(ttcStatus.rawValue) frontObjectDistance=\(frontObjectDistance) egoSpeed=\(String(describing: egoSpeed)) gpsTime=\(gpsTime)")
    }
    
    func onLinearAccelerationSensor(accLinX: String?, accLinY: String?, accLinZ: String?) {
        print("onLinearAccelerationSensor: accLinX=\(String(describing: accLinX)) accLinY=\(String(describing: accLinY)) accLinZ=\(String(describing: accLinZ))")
    }
    
    func onAccelerationSensor(accX: String?, accY: String?, accZ: String?) {
        print("onAccelerationSensor: accX=\(String(describing: accX)) accY=\(String(describing: accY)) accZ=\(String(describing: accZ))")
    }
    
    func onAccelerationUncalibratedSensor(accUncX: String?, accUncY: String?, accUncZ: String?) {
        print("onAccelerationUncalibratedSensor: accUncX=\(String(describing: accUncX)) accUncY=\(String(describing: accUncY)) accUncZ=\(String(describing: accUncZ))")
    }
    
    func onGyroscopeSensor(gyrX: String?, gyrY: String?, gyrZ: String?) {
        print("onGyroscopeSensor: gyrX=\(String(describing: gyrX)) gyrY=\(String(describing: gyrY)) gyrZ=\(String(describing: gyrZ))")
    }
    
    func onGravitySensor(graX: String?, graY: String?, graZ: String?) {
        print("onGravitySensor: graX=\(String(describing: graX)) graY=\(String(describing: graY)) graZ=\(String(describing: graZ))")
    }
    
    func onMagneticSensor(magX: String?, magY: String?, magZ: String?) {
        print("onMagneticSensor: magX=\(String(describing: magX)) magY=\(String(describing: magY)) magZ=\(String(describing: magZ))")
    }
    
    func ttcCalculator(frontObjectDistance: String, egoSpeed: Float?, ttc: Float?) {
        print("ttcCalculator: frontObjectDistance=\(frontObjectDistance) egoSpeed=\(String(describing: egoSpeed)) ttc=\(String(describing: ttc))")
    }
    
    func ttcStatusCalculator(ttc: Float?, egoSpeed: Float?, ttcStatus: TTCStatus) {
        print("ttcStatusCalculator: ttc=\(String(describing: ttc)) egoSpeed=\(String(describing: egoSpeed)) ttcStatus=\(ttcStatus.rawValue)")
    }
    
    func onLocationChange(location: CLLocationCoordinate2D?, isGpsOn: Bool?) {
        print("onLocationChange: location=\(String(describing: location)) isGpsOn=\(String(describing: isGpsOn))")
    }
    
    func onSpeedChange(speedLimitKph: Int?, speedKph: Int) {
        print("onSpeedChange: speedLimitKph=\(String(describing: speedLimitKph)) speedKph=\(speedKph)")
        speedLabel.text = "Speed: \(speedKph) km/h"
        if (speedLimitKph != nil) {
            speedLimitLabel.text = "SpeedLimit: \(speedLimitKph!)"
            speedLimitLabel.isHidden = false
        }
        else {
            speedLimitLabel.isHidden = true
        }
    }
    
    func onRecordingEvent(status: VideoRecordStatus) {
        print("onRecordingEvent: status=\(status.rawValue)")
    }
    
    func onBatteryStatusChange(status: BatteryStatus) {
        print("onBatteryStatusChange: status=\(status.rawValue)")
    }
    
    func onGravityAlignmentChange(isAlign: Bool) {
        print("onGravityAlignmentChange: isAlign=\(isAlign)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let width: CGFloat = self.view.frame.size.width
        let height: CGFloat = self.view.frame.size.height
        previewView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: max(width, height), height: min(width, height)))
        previewView.backgroundColor = UIColor.black
        self.view.addSubview(previewView)
        
        let backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect.init(x: 20, y: 40, width: 40, height: 40);
        backBtn.setImage(UIImage.init(named: "lnr_back2"), for: .normal)
        backBtn.addTarget(self, action: #selector(onBackClick), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        recordBtn = UIButton.init(type: .custom)
        recordBtn!.frame = CGRect.init(x: 100, y: 40, width: 150, height: 40);
        recordBtn!.backgroundColor = UIColor.blue
        recordBtn!.setTitle("Start Record", for: .normal)
        recordBtn!.setTitle("End Record", for: .selected)
        recordBtn!.addTarget(self, action: #selector(onRecordClick), for: .touchUpInside)
        self.view.addSubview(recordBtn!)
        
        previewBtn = UIButton.init(type: .custom)
        previewBtn!.frame = CGRect.init(x: 270, y: 40, width: 90, height: 40);
        previewBtn!.backgroundColor = UIColor.blue
        previewBtn!.setTitle("Attach", for: .normal)
        previewBtn!.setTitle("Detach", for: .selected)
        previewBtn!.addTarget(self, action: #selector(onAttachClick), for: .touchUpInside)
        self.view.addSubview(previewBtn!)
        
        speedLabel = UILabel.init()
        speedLabel.frame = CGRect.init(x: 50, y: 100, width: 200, height: 20);
        speedLabel.font = UIFont.boldSystemFont(ofSize: 15)
        speedLabel.textColor = UIColor.white
        speedLabel.text = "Speed: 0 km/h"
        self.view.addSubview(speedLabel)
        
        speedLimitLabel = UILabel.init()
        speedLimitLabel.frame = CGRect.init(x: 50, y: 140, width: 200, height: 20);
        speedLimitLabel.font = UIFont.boldSystemFont(ofSize: 15)
        speedLimitLabel.textColor = UIColor.white
        speedLimitLabel.isHidden = true
        speedLimitLabel.text = "SpeedLimit: 0"
        self.view.addSubview(speedLimitLabel)
        
        Gizo.app.gizoAnalysis.start(lifecycleOwner: self) {
            print("Gizo.app.gizoAnalysis.start done")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previewBtn?.isSelected = true
        Gizo.app.gizoAnalysis.attachPreview(preview: previewView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func onBackClick() {
        Gizo.app.gizoAnalysis.stopSavingSession()
        Gizo.app.gizoAnalysis.stop()
        self.dismiss(animated: true)
    }
    
    @objc func onRecordClick() {
        recordBtn?.isSelected = !(recordBtn!.isSelected)
        if (recordBtn!.isSelected) {
            Gizo.app.gizoAnalysis.startSavingSession()
        }
        else {
            Gizo.app.gizoAnalysis.stopSavingSession()
        }
    }
    
    @objc func onAttachClick() {
        previewBtn?.isSelected = !(previewBtn!.isSelected)
        if (previewBtn!.isSelected) {
            Gizo.app.gizoAnalysis.attachPreview(preview: previewView)
        }
        else {
            Gizo.app.gizoAnalysis.attachPreview(preview: nil)
        }
    }
    
    //Orientation
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.landscapeLeft, UIInterfaceOrientationMask.landscapeRight]
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }

}
