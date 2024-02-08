//
//  DriveNoCameraViewController.swift
//  TestDemo
//
//  Created by Hepburn on 2024/1/4.
//

import UIKit
import GizoSDK
import CoreLocation

class DriveNoCameraViewController: UIViewController, GizoAnalysisDelegate {
    
    private var timeView: DriveTimeView?
    private var button: UIButton?
    
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
    
    func onUserActivity(type: String) {
        print("onUserActivity: type=\(type)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
        button!.setTitle("Start", for: .normal)
        button!.setTitle("Stop", for: .selected)
        button!.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        self.view.addSubview(button!)
        
    }
    
    @objc func onButtonClick() {
        button?.isSelected = !(button!.isSelected)
        if ((button?.isSelected)!) {
            startDrive()
        }
        else {
            stopDrive()
        }
    }
    
    func startDrive() {
        timeView?.startTimer()
        Gizo.app.gizoAnalysis.start(lifecycleOwner: self) {
            print("Gizo.app.gizoAnalysis.start done")
        }
        Gizo.app.gizoAnalysis.startSavingSession()
    }
    
    func stopDrive() {
        timeView?.stopTimer()
        Gizo.app.gizoAnalysis.stopSavingSession()
        Gizo.app.gizoAnalysis.stop()
    }
    
    @objc func onBackClick() {
        stopDrive()
        self.dismiss(animated: true)
    }
}
