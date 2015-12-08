//
//  SetTargetDateViewController.swift
//  CountDown
//
//  Created by 侯 翔 on 2015/12/04.
//  Copyright © 2015年 HX Studio. All rights reserved.
//

import Foundation
import UIKit

class SetTargetDateViewController: UIViewController {
    @IBOutlet var datePicker: UIDatePicker?;
    
    var store: Store!;
    var timeUtil: TimeUtil!;
    //MARK: Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Instance plist store
        store = Store.instance();
        store.setPlistFile("Store");
        
        // Instance Time util
        timeUtil = TimeUtil.instance();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func selectTargetDate(sender: UIButton) {
        let targetDate: NSDate = datePicker!.date;
        let currentDate: NSDate = NSDate();
        let remainDays: Int = timeUtil.getRemainingDays(currentDate, to: targetDate);
        if (remainDays > 0) {
            // Save the new target date to plist file
            let date: String = timeUtil.getStringFromNSDate(targetDate, formatter: "yyyy-MM-dd");
            store.editPlistData("TargetDate", value: date);
            store.editPlistData("AlertedDate", value: "");
            store.savePlist();
            
            self.performSegueWithIdentifier("selectedTargetDate", sender: self);
        }
        else {
            // If selected date is earlier than current date
            doAlert();
        }
    }
    
    // Setup the Alert Controller
    func doAlert() {
        let cancelAction: UIAlertAction = UIAlertAction(title: "Reset", style: UIAlertActionStyle.Destructive, handler: nil);
        let alertController: UIAlertController = UIAlertController(title: "Notice", message: "The date which you selected is earlier than current date", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addAction(cancelAction);
        self.presentViewController(alertController, animated: true, completion: nil);
    }
    
}
