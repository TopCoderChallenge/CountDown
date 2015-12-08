//
//  ViewController.swift
//  CountDown
//
//  Created by 侯 翔 on 2015/12/01.
//  Copyright © 2015年 HX Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var remainDaysLable: UILabel?;
    @IBOutlet var TargetDateLable: UILabel?;
    
    var currentDateTime: NSDate = NSDate();
    
    var targetDateTime: NSDate?;
    
    var targetDate: String = "";
    var remainDays: Int = 0;
    
    var store: Store!;
    var timeUtil: TimeUtil!;
    
    var mainAlertController: UIAlertController?;
    
    //MARK: Method
    override func viewDidLoad() {
        super.viewDidLoad()
        remainDaysLable?.text = "";
        TargetDateLable?.text = "";
        // Do any additional setup after loading the view, typically from a nib.
        
        // Instance plist store
        store = Store.instance();
        store.setPlistFile("Store");
        
        // Instance Time util
        timeUtil = TimeUtil.instance();
        
        self.targetDate = getTargetDateFromPlist();
        if (self.targetDate != "") {
            targetDateTime = timeUtil.getNSDateFromString(self.targetDate, formatter: "yyyy-MM-dd");
            self.remainDays = timeUtil.getRemainingDays(currentDateTime, to: targetDateTime!);
        }
    }
    // performSegueWithIdentifier could be used in viewDidAppear
    // because it can be loaded after story board loaded
    override func viewDidAppear(animated: Bool) {
        //self.performSegueWithIdentifier("selectTargetDate", sender: self);
        if (self.targetDate == "") {
            self.performSegueWithIdentifier("selectTargetDate", sender: self);
        }
        else {
            if (remainDays == -1) {
                // Go to setTargetDate View
                self.performSegueWithIdentifier("selectTargetDate", sender: self);
            }
            else if (self.remainDays >= 0) {
                remainDaysLable?.text = String(self.remainDays);
                TargetDateLable?.text = self.targetDate;
                checkAlert();
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTargetDateFromPlist() -> String {
        var returnValue: String = "";
        store.getPlistDataSandbox();
        returnValue = store.plistData["TargetDate"] as! String;
        return returnValue;
    }
    
    func getAlertDateFromPlist() -> String {
        var returnValue: String = "";
        store.getPlistDataSandbox();
        returnValue = store.plistData["AlertedDate"] as! String;
        return returnValue;
    }
    
    func checkAlert() {
        let alertedData: String = getAlertDateFromPlist();
        let currentDate: String = timeUtil.getStringFromNSDate(currentDateTime, formatter: "yyyy-MM-dd");
        // If daily alter is called then it will not call again in that date
        if (alertedData != currentDate) {
            store.editPlistData("AlertedDate", value: currentDate);
            store.savePlist();
            store.getPlistDataSandbox();
            print(store.plistData);
            doAlert();
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(self.mainAlertController!, animated: true, completion: nil);
            });
        }
    }
    
    // Setup the Alert Controller
    func doAlert() {
        let cancelAction: UIAlertAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.Destructive, handler: nil);
        let oKAction: UIAlertAction = UIAlertAction(title: "See Memo", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction) in (
            self.performSegueWithIdentifier("displayMemo", sender: self)
        )});

        let alertController: UIAlertController = UIAlertController(title: "Notice", message: String(self.remainDays) + " days of left under " + self.targetDate, preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addAction(cancelAction);
        alertController.addAction(oKAction);
        
        self.mainAlertController = alertController;
    }
    
    //MARK: Action of Buttons
    @IBAction func selectTargetDate(sender: UIButton) {
        self.performSegueWithIdentifier("selectTargetDate", sender: self);
    }
    
    @IBAction func displayMemo(sender: UIButton) {
        self.performSegueWithIdentifier("displayMemo", sender: self);
    }

}




