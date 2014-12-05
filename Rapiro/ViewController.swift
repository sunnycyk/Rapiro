//
//  ViewController.swift
//  Rapiro
//
//  Created by Sunny Cheung on 4/11/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BLEDelegate, UIAlertViewDelegate, RobotDelegate {
    
    var bleShield:BLE!
    @IBOutlet weak var connectBLEButton:UIButton!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    @IBOutlet var controlButtons:Array<UIButton>!
    var connectStatus:Bool = false
    var lang:String = "en"
    var bundle:NSBundle!
    var stopTimer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.bundle = NSBundle(path: NSBundle.mainBundle().pathForResource(self.lang, ofType: "lproj")!)
       

        bleShield = BLE()
        bleShield.controlSetup()
        bleShield.delegate = self;
        
        self.disableAllButtons()
    }
    
    
    func changeConnectBtnLang() {
        if (!connectStatus) {
            self.connectBLEButton.setTitle(NSLocalizedString("CONNECT", bundle: self.bundle, comment: "Connect"), forState: UIControlState.Normal)
        }
        else {
            self.connectBLEButton.setTitle(NSLocalizedString("DISCONNECT", bundle: self.bundle, comment: "disconnect"), forState: UIControlState.Normal)
        }
    }
    
    func changeLanguage(lang:String) {
        self.lang = lang
        self.bundle = NSBundle(path: NSBundle.mainBundle().pathForResource(self.lang, ofType: "lproj")!)
        (self.view.viewWithTag(5) as UIButton).setTitle(NSLocalizedString("Give_Me_a_Hug", bundle: self.bundle, comment: "Give me a Hug"), forState: UIControlState.Normal)
       
        (self.view.viewWithTag(6) as UIButton).setTitle(NSLocalizedString("Wave_Right_Hand", bundle: self.bundle, comment: "Wave Right Hand"), forState: UIControlState.Normal)
        (self.view.viewWithTag(7) as UIButton).setTitle(NSLocalizedString("Move_Both_Arms", bundle: self.bundle, comment: "Move Both Hands"), forState: UIControlState.Normal)
        (self.view.viewWithTag(8) as UIButton).setTitle(NSLocalizedString("Wave_Left_Hand", bundle: self.bundle, comment: "Wave Left Hand"), forState: UIControlState.Normal)
        (self.view.viewWithTag(9) as UIButton).setTitle(NSLocalizedString("Catch_Action", bundle: self.bundle, comment: "Catch Action"), forState: UIControlState.Normal)
        self.changeConnectBtnLang()
    }
    
    func disableAllButtons() {
        for button in self.controlButtons {
            button.enabled = false
        }
    }
    
    func enableAllButtons() {
        for button in self.controlButtons {
            button.enabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendBLEData(data:String) {
        if (bleShield.activePeripheral.state == CBPeripheralState.Connected) {
            bleShield.write(data.dataUsingEncoding(NSUTF8StringEncoding))
        }
    }
    
    @IBAction func moveForward() {
        stopTimer?.invalidate()
        self.sendBLEData("#M1")
    }
    
    @IBAction func moveBackward() {
        stopTimer?.invalidate()
        self.sendBLEData("#M2")

    }
    
    @IBAction func turnLeft() {
        stopTimer?.invalidate()
        self.sendBLEData("#M3")
    }
    
    @IBAction func turnRight() {
        stopTimer?.invalidate()
        self.sendBLEData("#M4")
    }
    
    @IBAction func giveMeAHug() {
        stopTimer?.invalidate()
        self.sendBLEData("#M5")
    }
    
    @IBAction func waveRightHand() {
        stopTimer?.invalidate()
        self.sendBLEData("#M6")
    }
    
    @IBAction func waveBothArms() {
        stopTimer?.invalidate()
        self.sendBLEData("#M7")
    }
    
    @IBAction func waveLeftHand() {
        stopTimer?.invalidate()
        self.sendBLEData("#M8")
    }
    
    @IBAction func catchAction() {
        stopTimer?.invalidate()
        self.sendBLEData("#M9")
    }
    
    @IBAction func stop() {
        stopTimer?.invalidate()
        stopTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("stopTimer:"), userInfo: nil, repeats: false)
      
    }
    
    @IBAction func readyPosition() {
        stopTimer?.invalidate()
        self.sendBLEData("#M0")
    }
    
    func stopTimer(timer:NSTimer!) {
        self.sendBLEData("#M0")
    }
    
    @IBAction func connectBLE() {
        if (bleShield.activePeripheral != nil) {
            if (bleShield.activePeripheral.state == CBPeripheralState.Connected) {
                bleShield.CM.cancelPeripheralConnection(bleShield.activePeripheral)
                return
            }
            
        }
        
        if (bleShield.peripherals != nil) {
            bleShield.peripherals = nil
        }
        
        bleShield.findBLEPeripherals(3)
        
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("connectionTimer:"), userInfo: nil, repeats: false)
        
        self.connectBLEButton.enabled = false
        self.activityIndicator.startAnimating()
        self.connectBLEButton.setTitle("", forState: UIControlState.Normal)
    }
    
    @IBAction func config() {
        var message:UIAlertView = UIAlertView(title: NSLocalizedString("Language", bundle: self.bundle, comment: "Language"), message: NSLocalizedString("Choose_Language", bundle: self.bundle, comment: "Choose Language"), delegate: self, cancelButtonTitle: nil, otherButtonTitles: "English", "中文", "日本語")
        message.show()
    }
    
    // BLE Delegate
    
    func bleDidConnect() {
        self.connectBLEButton.enabled = true
        self.connectBLEButton.setTitle(NSLocalizedString("DISCONNECT", bundle: self.bundle, comment: "Disonnect"), forState: UIControlState.Normal)
        self.activityIndicator.stopAnimating()
        self.enableAllButtons()
        connectStatus = true
        NSLog("bleDidConnect")
    }
    
    func bleDidDisconnect() {
        self.connectBLEButton.enabled = true
        self.connectBLEButton.setTitle(NSLocalizedString("CONNECT", bundle: self.bundle, comment: "Connect"), forState: UIControlState.Normal)
        self.disableAllButtons()
        connectStatus = false
        NSLog("bleDidDisconnect")
    }
    
    func connectionTimer(timer:NSTimer!) {
        if (bleShield.peripherals != nil) {
            let pilotVC:PilotViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("pilotViewController") as PilotViewController
            pilotVC.delegate = self
            pilotVC.bleShield = self.bleShield
            self.presentViewController(pilotVC, animated: true, completion: nil)
        }
        else {
            self.cancelConnection()
        }
    }
    
    func bleDidReceiveData(data: UnsafeMutablePointer<UInt8>, length: Int32) {
        var s:NSString! = NSString(bytes: data, length: Int(length), encoding: NSUTF8StringEncoding)
        data.destroy()
        NSLog(s!)
    }
    
    // UIAlertView Delegate

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch(buttonIndex) {
            case 0: self.changeLanguage("en")
            case 1: self.changeLanguage("zh-Hant")
            case 2: self.changeLanguage("ja")
            default: self.changeLanguage("en")
        }
      
    }
    
    // MARK RobotDelegate
    func cancelConnection() {
       self.activityIndicator.stopAnimating()
       self.connectBLEButton.enabled = true
       self.connectBLEButton.setTitle(NSLocalizedString("CONNECT", bundle: self.bundle, comment: "Connect"), forState: UIControlState.Normal)
    }
    
    func connectPeripheral(robot: CBPeripheral) {
        self.bleShield.connectPeripheral(robot)
    }
}

