//
//  DescriptionViewController.swift
//  CountDown
//
//  Created by 侯 翔 on 2015/12/04.
//  Copyright © 2015年 HX Studio. All rights reserved.
//

import Foundation
import UIKit

class DescriptionViewController: UIViewController {
    @IBOutlet var image: UIImageView?;
    @IBOutlet var button: UIButton?;
    @IBOutlet var text: UITextView?;
    
    var store: Store?;
    var memoInfo: NSDictionary = NSDictionary();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.store = Store.instance();
        self.store?.setPlistFile("Store");
        self.store?.getPlistDataSandbox();
        
        self.memoInfo = getMemoInfo();
        
        setInfoToElements();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInfoToElements() {
        let url: String = self.memoInfo["url"] as! String;
        self.button?.setTitle(url, forState: UIControlState.Normal);
        
        let msg: String = self.memoInfo["msg"] as! String;
        self.text?.text = msg;
        
        let imgUrl: String = self.memoInfo["img"] as! String;
        self.loadImageFormRemote(imgUrl);
    }
    
    func loadImageFormRemote(url: String) {
        let urlObj: NSURL = NSURL(string: url)!;
        let data: NSData = NSData(contentsOfURL: urlObj)!;
        let img: UIImage = UIImage(data: data, scale: 1.5)!;
        self.image?.contentMode = UIViewContentMode.ScaleAspectFit;
        self.image?.image = img;
    }
    
    // get memo info form plist with key
    func getMemoInfo() -> NSDictionary {
        var key: String = self.store?.plistData["AlertedDate"] as! String;
        let length: Int = key.characters.count;
        key = subString(key, start: (length - 1), end: (length));
        let list: NSMutableDictionary = (self.store?.getOnlyLoadPlist("Description"))!;
        return list[key] as! NSDictionary;
    }
    
    func subString(value: String, start: Int, end: Int) -> String {
        let startIndex = value.startIndex.advancedBy(start);
        let endIndex = value.startIndex.advancedBy(end);
        let range = Range<String.Index>(start: startIndex, end: endIndex);
        return value.substringWithRange(range);
    }
    
    @IBAction func clickButton(sender: UIButton) {
        let title: String = (sender.titleLabel?.text)!;
        // Open browser with url address
        let url: NSURL = NSURL(string: "http://" + title)!;
        UIApplication.sharedApplication().openURL(url);
    }
}
