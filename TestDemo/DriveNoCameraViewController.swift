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
    
    func onSessionStatus(inProgress: Bool, previewAttached: Bool) {
        print("onSessionStatus: inProgress=\(inProgress) previewAttached=\(previewAttached)")
    }
    
    func onAnalysisResult(preview: UIImage?, ttc: Float?, ttcStatus: TTCStatus, frontObjectDistance: Double?, egoSpeed: Int?, gpsTime: String) {
        print("onAnalysisResult: ttc=\(String(describing: ttc)) ttcStatus=\(String(describing: ttcStatus)) frontObjectDistance=\(String(describing: frontObjectDistance)) egoSpeed=\(String(describing: egoSpeed)) gpsTime=\(String(describing: gpsTime))")
    }
    
    func ttcStatusCalculator(ttc: Float?, egoSpeed: Int?, ttcStatus: TTCStatus) {
        print("ttcStatusCalculator: ttc=\(String(describing: ttc)) egoSpeed=\(String(describing: egoSpeed)) ttcStatus=\(String(describing: ttcStatus))")
    }
    
    func ttcCalculator(frontObjectDistance: Double?, egoSpeed: Int?, ttc: Float?) {
        print("ttcCalculator: frontObjectDistance=\(String(describing: frontObjectDistance)) egoSpeed=\(String(describing: egoSpeed)) ttc=\(String(describing: ttc))")
    }
    
    func onLocationChange(location: CLLocationCoordinate2D?, isGpsOn: Bool?) {
        print("onLocationChange: location=\(String(describing: location)) isGpsOn=\(String(describing: isGpsOn))")
    }
    
    func onSpeedChange(speedLimitKph: Int?, speedKph: Int) {
        print("onSpeedChange: speedLimitKph=\(String(describing: speedLimitKph)) speedKph=\(speedKph)")
    }
    
    func onLinearAccelerationSensor(accLinX: Double?, accLinY: Double?, accLinZ: Double?) {
        print("onLinearAccelerationSensor: accLinX=\(String(describing: accLinX)) accLinY=\(String(describing: accLinY)) accLinZ=\(String(describing: accLinZ))")
    }
    
    func onAccelerationSensor(accX: Double?, accY: Double?, accZ: Double?) {
        print("onAccelerationSensor: accX=\(String(describing: accX)) accY=\(String(describing: accY)) accZ=\(String(describing: accZ))")
    }
    
    func onMagneticSensor(magX: Double?, magY: Double?, magZ: Double?) {
        print("onMagneticSensor: magX=\(String(describing: magX)) magY=\(String(describing: magY)) magZ=\(String(describing: magZ))")
    }
    
    func onGyroscopeSensor(gyrX: Double?, gyrY: Double?, gyrZ: Double?) {
        print("onGyroscopeSensor: gyrX=\(String(describing: gyrX)) gyrY=\(String(describing: gyrY)) gyrZ=\(String(describing: gyrZ))")
    }
    
    func onGravitySensor(graX: Double?, graY: Double?, graZ: Double?) {
        print("onGravitySensor: graX=\(String(describing: graX)) graY=\(String(describing: graY)) graZ=\(String(describing: graZ))")
    }
    
    func onImuSensor(acceleration: NSDictionary?, linearAcceleration: NSDictionary?, accelerationUnc: NSDictionary?, gyroscope: NSDictionary?, magnetic: NSDictionary?, gravity: NSDictionary?) {
        print("onImuSensor: acceleration=\(String(describing: acceleration)) linearAcceleration=\(String(describing: linearAcceleration)) accelerationUnc=\(String(describing: accelerationUnc)) gyroscope=\(String(describing: gyroscope)) magnetic=\(String(describing: magnetic)) gravity=\(String(describing: gravity))")
    }
    
    func onRecordingEvent(status: VideoRecordStatus) {
        print("onRecordingEvent: status=\(status)")
    }
    
    func onBatteryStatusChange(status: BatteryStatus) {
        print("onBatteryStatusChange: status=\(status)")
    }
    
    func onGravityAlignmentChange(isAlign: Bool) {
        print("onGravityAlignmentChange: isAlign=\(isAlign)")
    }

    func onUserActivity(type: String) {
        print("onUserActivity: type=\(type)")
    }
    
    func onThermalStatusChange(state: ProcessInfo.ThermalState) {
        print("onThermalStatusChange: type=\(state)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let option = Gizo.options
        option?.videoSetting.allowRecording = false
        Gizo.options = option
        
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
