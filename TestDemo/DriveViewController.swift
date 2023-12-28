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
    
    func onSessionStatus(inProgress: Int, previewAttached: Int) {
        
    }
    
    func onAnalysisResult(preview: UIImage?, ttc: Float?, ttcStatus: TTCStatus, frontObjectDistance: String, egoSpeed: Float?, gpsTime: String) {
        
    }
    
    func onLinearAccelerationSensor(accLinX: String?, accLinY: String?, accLinZ: String?) {
        
    }
    
    func onAccelerationSensor(accX: String?, accY: String?, accZ: String?) {
        
    }
    
    func onAccelerationUncalibratedSensor(accUncX: String?, accUncY: String?, accUncZ: String?) {
        
    }
    
    func onGyroscopeSensor(gyrX: String?, gyrY: String?, gyrZ: String?) {
        
    }
    
    func onGravitySensor(graX: String?, graY: String?, graZ: String?) {
        
    }
    
    func onMagneticSensor(magX: String?, magY: String?, magZ: String?) {
        
    }
    
    func ttcCalculator(frontObjectDistance: String, egoSpeed: Float?, ttc: Float?) {
        
    }
    
    func ttcStatusCalculator(ttc: Float?, egoSpeed: Float?, ttcStatus: TTCStatus) {
        
    }
    
    func onLocationChange(location: CLLocationCoordinate2D?, isGpsOn: Bool?) {
        
    }
    
    func onSpeedChange(speedLimitKph: Int?, speedKph: Int) {
        
    }
    
    func onRecordingEvent(status: VideoRecordStatus) {
        
    }
    
    func onBatteryStatusChange(status: BatteryStatus) {
        
    }
    
    func onGravityAlignmentChange(isAlign: Bool) {
        
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
        backBtn.backgroundColor = UIColor.white
        backBtn.setTitle("X", for: UIControl.State.normal)
        backBtn.addTarget(self, action: #selector(onBackClick), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        Gizo.app.gizoAnalysis.start(lifecycleOwner: self) {
            print("Gizo.app.gizoAnalysis.start done")
        }
        Gizo.app.gizoAnalysis.startSavingSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
