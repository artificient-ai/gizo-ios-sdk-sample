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
        options.imuSetting.allowMagneticSensor = true
        options.imuSetting.allowMagneticSensor = true
        options.imuSetting.saveCsvFile = true
        options.batterySetting.checkBattery = true
        options.orientationSetting.allowGravitySensor = true
        options.videoSetting.allowRecording = true
        Gizo.initialize(delegate: self, options: options)
        Gizo.app.loadModel()
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 40)
        btn.backgroundColor = UIColor.blue
        btn.setTitle("Drive", for: .normal)
        btn.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let btn2 = UIButton.init(type: .custom)
        btn2.frame = CGRect.init(x: 100, y: 200, width: 100, height: 40)
        btn2.backgroundColor = UIColor.blue
        btn2.setTitle("Test", for: .normal)
        btn2.addTarget(self, action: #selector(onButton2Click), for: .touchUpInside)
        self.view.addSubview(btn2)
    }

    @objc func onButtonClick() {
        let ctrl = DriveViewController.init()
        ctrl.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
        self.present(ctrl, animated: true, completion: nil)
    }
    
    @objc func onButton2Click() {
        let publicKey: String? = readPublicKey()
        if (publicKey != nil) {
            checkLicense(publicKey: publicKey!)
        }
    }
    
    func readPublicKey() -> String? {
        let path: String? = Bundle.main.path(forResource: "publickey", ofType: "pem")
        if (FileManager.default.fileExists(atPath: path!)) {
            do {
                let data: Data? = try Data.init(contentsOf: URL.init(fileURLWithPath: path!))
                if (data != nil) {
                    var text: String? = String.init(data: data!, encoding: .utf8)
                    if (text != nil) {
                        text = text?.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
                        text = text?.replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
                        text = text?.replacingOccurrences(of: "\r", with: "")
                        text = text?.replacingOccurrences(of: "\n", with: "")
                        return text
                    }
                }
            }
            catch {
                print(error)
            }
        }
        return nil
    }
    
    func checkLicense(publicKey: String) {
        var path: String? = self.licensePath
        if (!FileManager.default.fileExists(atPath: path!)) {
            path = Bundle.main.path(forResource: "license", ofType: "json")
        }
        if (FileManager.default.fileExists(atPath: path!)) {
            do {
                let data: Data? = try Data.init(contentsOf: URL.init(fileURLWithPath: path!))
                if (data != nil) {
                    let text: String? = String.init(data: data!, encoding: .utf8)
                    if (text != nil) {
                        let licenseObj: NSDictionary? = JsonStr2Dict(text: text!)
                        if (licenseObj != nil) {
                            let licenseText: String? = licenseObj!["license"] as! String?
                            if (licenseText != nil) {
                                let base64decData: Data? = Data.init(base64Encoded: licenseText!)
                                if (base64decData != nil) {
                                    let jsonText: String? = String.init(data: base64decData!, encoding: .utf8)
                                    if (jsonText != nil) {
                                        print("jsonText:\(jsonText!)")
                                        let jsonObj: NSDictionary? = JsonStr2Dict(text: jsonText!)
                                        if (jsonObj != nil) {
                                            let sign1: String? = jsonObj!["signature"] as? String
                                            print("signature1:\(String(describing: sign1))")
                                            let dict: NSMutableDictionary = NSMutableDictionary.init(dictionary: jsonObj!)
                                            dict["signature"] = ""
                                            let encText: String? = dict2JsonStr(dict: dict)
                                            let sign2 = zz_rsaEncrypt(encText!, publicKey)
                                            print("signature2:\(String(describing: sign2))")
                                            var expireTime: String? = jsonObj!["expiration-date"] as? String
                                            if (expireTime != nil) {
                                                expireTime = expireTime!.replacingOccurrences(of: "T", with: " ")
                                                let time = DateTimeUtil.dateTimeFromString(expireTime!, format: "yyyy-MM-dd HH:mm:ss")
                                                let interval = time?.timeIntervalSinceNow
                                                if (interval != nil && interval! < 3600*24*7) {
                                                    updateLicense(license: licenseText!)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    var licensePath: String {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return NSString.init(string: docPath!).appendingPathComponent("license.json")
    }
    
    func updateLicense(license: String) {
        let params = ["license":license]
        HttpManager.shared.request(urlStr: "Auth/refresh-license", method: "POST", headers: nil, parameters: params) { [self] data in
            let jsonText: String? = dict2JsonStr(dict: data as! NSDictionary)
            if (jsonText != nil) {
                do {
                    let path = self.licensePath
                    if (FileManager.default.fileExists(atPath: path)) {
                        try FileManager.default.removeItem(atPath: path)
                    }
                    try jsonText!.write(toFile: path, atomically: true, encoding: .utf8)
                }
                catch {
                    print(error)
                }
            }
        } failure: { code, message in
        }
    }
    
    func dict2JsonStr(dict: NSDictionary) -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: [])
            return String.init(data: data, encoding: String.Encoding.utf8)
        } catch {
            print("jsonDict2String error")
        }
        return nil
    }
    
    func JsonStr2Dict(text: String) -> NSDictionary? {
        do {
            let data = text.data(using: .utf8)
            return try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
        } catch {
            print("jsonDict2String error")
        }
        return nil
    }
    
    func zz_rsaEncrypt(_ text: String, _ publicKey: String) -> String? {
        print("text:\(text)")
        print("publicKey:\(publicKey)")
        let ZZ_RSA_PUBLIC_KEY_TAG = "RSAUtil_PubKey"
        guard let textData = text.data(using: String.Encoding.utf8) else { return nil }
        let encryptedData = RSACrypt.encryptWithRSAPublicKey(textData, pubkeyBase64: publicKey, keychainTag: ZZ_RSA_PUBLIC_KEY_TAG)
        if ( encryptedData == nil ) {
            print("Error while encrypting")
            return nil
        } else {
            let encryptedDataText = encryptedData!.base64EncodedString(options: NSData.Base64EncodingOptions())
            return encryptedDataText
        }
    }
}


