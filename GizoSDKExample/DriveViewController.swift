//
//  DriveViewController.swift
//  GizoSDKExample
//
//  Created by Mahyar on 2023/12/7.
//

import UIKit
import GizoSDK
import CoreLocation

class DriveViewController: UIViewController,GizoDelegate {
    var previewView: UIView!
    var recordBtn: UIButton?
    var previewBtn: UIButton?
    var speedLabel: UILabel!
    var speedLimitLabel: UILabel!
    var batteryStatus = BatteryStatus.NORMAL
    var thermalState: ProcessInfo.ThermalState = .nominal
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Gizo.shared.delegate = self
        
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
        previewBtn!.setTitle("Attach", for: .selected)
        previewBtn!.setTitle("Detach", for: .normal)
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
        
//        Gizo.app.gizoAnalysis.start(lifecycleOwner: self) {
//            print("Gizo.app.gizoAnalysis.start done")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previewBtn?.isSelected = true
//        Gizo.app.gizoAnalysis.attachPreview(preview: previewView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func onBackClick() {
//        Gizo.app.gizoAnalysis.stopSavingSession()
//        Gizo.app.gizoAnalysis.stop()
        self.dismiss(animated: true)
    }
    
    @objc func onRecordClick() {
//        if(batteryStatus == BatteryStatus.LOW_BATTERY_STOP){
//           
//            recordBtn?.isSelected = false
//            return
//        }
//        if(thermalState == .critical){
//            recordBtn?.isSelected = false
//            return
//        }
        
        recordBtn?.isSelected = !(recordBtn!.isSelected)
        if (recordBtn!.isSelected) {
            
            do {
                let cameraSetting = GizoCameraSetting(ai: true)
                try Gizo.shared.startRecording(cameraSetting)
                
            } catch GizoError.attachCameraNotUsed {
                print("Error: The AttachCamera function was not used before starting the session.")
            } catch {
                print("An unknown error occurred: \(error)")
            }
            
        }
        else {
            Gizo.shared.stopRecording()
        }
        
      
    }
    
    @objc func onAttachClick() {
       
        if previewBtn!.isSelected {
            
            Gizo.shared.AttachCamera { previewLayer in
                if let previewUi = self.previewView {
                    if let previewLayer = previewLayer {
                        previewLayer.frame = previewUi.bounds
                        previewUi.layer.addSublayer(previewLayer)
                    }
                }
            }
        }
        else{
            if let previewUi = self.previewView {
                previewUi.isHidden = true
            }
        }
        
        previewBtn?.isSelected = !(previewBtn!.isSelected)
    }
    
    func onloadPage() {
        do {
            
            Gizo.shared.AttachCamera() { previewLayer in }
            try Gizo.shared.startRecording(GizoCameraSetting(ai: false))
            
            
            // . 2
            Gizo.shared.AttachCamera() { previewLayer in
                if let previewUi = self.previewView {
                    if let previewLayer = previewLayer {
                        previewLayer.frame = previewUi.bounds
                        previewUi.layer.addSublayer(previewLayer)
                    }
                }
            }
            
            try Gizo.shared.startRecording(GizoCameraSetting(ai: false))
            
            // .3
            Gizo.shared.AttachCamera { previewLayer in
                if let previewUi = self.previewView {
                    if let previewLayer = previewLayer {
                        previewLayer.frame = previewUi.bounds
                        previewUi.layer.addSublayer(previewLayer)
                    }
                }
            }
        } catch {
            
        }
    }
}
