//
//  DriveTimeView.swift
//  GizoSDKExample
//
//  Created by Mahyar on 2023/10/19.
//

import UIKit

class DriveTimeView: UIView {
    private var hourLabel: UILabel?
    private var minuteLabel: UILabel?
    private var secondLabel: UILabel?
    private var startTime: Date?
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var left = 0.0
        let width = 67.0
        let height = 48.0
        let offset = 26.0
        let units = ["h", "m", "s"]
        for i in 0..<3 {
            let textLabel = UILabel.init()
            textLabel.textColor = UIColor.white
            textLabel.font = UIFont.boldSystemFont(ofSize: 30)
            textLabel.text = "00"
            textLabel.tag = i+300
            textLabel.backgroundColor = UIColor.init(red: 0.22, green: 0.24, blue: 0.3, alpha: 1.0)
            textLabel.textAlignment = .center
            textLabel.layer.cornerRadius = 10
            textLabel.layer.masksToBounds = true
            textLabel.frame = CGRect.init(x: left, y: 0, width: width, height: height)
            self.addSubview(textLabel)
            
            let unitLabel = UILabel.init()
            unitLabel.textColor = UIColor.gray
            unitLabel.font = UIFont.boldSystemFont(ofSize: 19)
            unitLabel.text = units[i]
            unitLabel.frame = CGRect.init(x: left+width+3, y: 0, width: 24, height: height)
            self.addSubview(unitLabel)
            
            left += (width+offset)
        }
    }
    
    public func startTimer() {
        stopTimer()
        startTime = NSDate.now
        if (timer == nil) {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(onTimeCheck), userInfo: nil, repeats: true)
        }
    }
    
    @objc func onTimeCheck() {
        let curTime = NSDate.now
        let timeInterval: Double = curTime.timeIntervalSince(startTime!)
        let duration: Int = Int(round(timeInterval))
        let hour = duration/3600
        let minute = (duration%3600)/60
        let second = duration%60
        let hourLabel: UILabel = self.viewWithTag(300) as! UILabel
        let minuteLabel: UILabel = self.viewWithTag(301) as! UILabel
        let secondLabel: UILabel = self.viewWithTag(302) as! UILabel
        hourLabel.text = String.init(format: "%02d", hour)
        minuteLabel.text = String.init(format: "%02d", minute)
        secondLabel.text = String.init(format: "%02d", second)
    }
    
    public func stopTimer() {
        startTime = nil
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
