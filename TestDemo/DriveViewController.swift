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
    var batteryStatus = BatteryStatus.NORMAL
    var thermalState: ProcessInfo.ThermalState = .nominal
    
    func onSessionStatus(inProgress: Bool, previewAttached: Bool) {
        print("onSessionStatus: inProgress=\(inProgress) previewAttached=\(previewAttached)")
    }
    
    func onAnalysisResult(preview: UIImage?, ttc: Float?, ttcStatus: TTCStatus, frontObjectDistance: Double?, egoSpeed: Int?, gpsTime: String) {
        print("onAnalysisResult: ttc=\(String(describing: ttc)) ttcStatus=\(String(describing: ttcStatus)) frontObjectDistance=\(String(describing: frontObjectDistance)) egoSpeed=\(String(describing: egoSpeed)) gpsTime=\(String(describing: gpsTime))")
        
        if (ttcStatus == TTCStatus.collision){
            self.view.showToast(message: "ttc status collision")
        }else if (ttcStatus == TTCStatus.tailgating){
            self.view.showToast(message: "ttc status collision")
        }
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
        speedLabel.text = "Speed: \(speedKph) km/h"
        if (speedLimitKph != nil) {
            speedLimitLabel.text = "SpeedLimit: \(speedLimitKph!)"
            speedLimitLabel.isHidden = false
        }
        else {
            speedLimitLabel.isHidden = true
        }
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
        batteryStatus = status
        if(status == BatteryStatus.LOW_BATTERY_STOP && recordBtn!.isSelected){
            onRecordClick()
        }else if(status == BatteryStatus.LOW_BATTERY_WARNING){
            self.view.showToast(message: "Battery is low, we will stop analysis")
        }
        
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
        thermalState = state
        if (state == .critical && recordBtn!.isSelected) {
            onRecordClick()
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async { // Ensure UI updates are on the main thread.
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("OK button tapped.")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let option = Gizo.options
        option?.videoSetting.allowRecording = true
        Gizo.options = option
        
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
        if(batteryStatus == BatteryStatus.LOW_BATTERY_STOP){
            showAlert(title: "Low battery", message: "Battery is low, we will stop recording")
            recordBtn?.isSelected = false
            return
        }
        if(thermalState == .critical){
            showAlert(title: "Overheating", message: "AI functions and video recording were stopped due to phone overheating")
            recordBtn?.isSelected = false
            return
        }
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
