//
//  PilotViewController.swift
//  Rapiro
//
//  Created by Sunny Cheung on 3/12/14.
//  Copyright (c) 2014 khl. All rights reserved.
//

import UIKit


class PilotViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView:UICollectionView!
    var bleShield:BLE!
    
    var pilots:[AnyObject]!
    
    private let reuseIdentifier = "PilotCell"
    
    
    @IBAction func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - UICollectionViewDataSource 
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bleShield!.peripherals.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as
            PilotCell
        
        let periphearls:CBPeripheral = self.bleShield!.peripherals.objectAtIndex(indexPath.row) as CBPeripheral
        let rssi:NSNumber = self.bleShield!.peripheralsRssi.objectAtIndex(indexPath.row) as NSNumber
        

        cell.pilotName.text = periphearls.name
        cell.pilotRSSI.text = NSString(format: "rssi: %d", rssi.intValue)
        return cell
    }
    
    
    // MARK - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.bleShield!.connectPeripheral(self.bleShield!.peripherals.objectAtIndex(indexPath.row) as CBPeripheral)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK - UICollectionViewDelegateFlowLayout
    private let sectionInsets = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
