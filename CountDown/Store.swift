//
//  Store.swift
//  CountDown
//
//  Created by 侯 翔 on 2015/12/04.
//  Copyright © 2015年 HX Studio. All rights reserved.
//

import Foundation

class Store {
    static var S: Store? = nil;
    
    static func instance() -> Store {
        if (S == nil) {
            S = Store();
        }
        return S!;
    }
    
    var plistFileName: String = "";
    var plistData: NSMutableDictionary = NSMutableDictionary();
    var plistFilePath: String = "";
    var plistFileSandboxPath: String = "";
    
    func setPlistFile(fileName: String) {
        self.plistFileName = fileName;
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let path: String = paths[0] as! String;
        self.plistFileSandboxPath = path + "/" + self.plistFileName + ".plist";
        self.plistFilePath = NSBundle.mainBundle().pathForResource(self.plistFileName, ofType: "plist")!;
        
        // Check sandbox plist file is added
        let fileIsExist: Bool = NSFileManager.defaultManager().fileExistsAtPath(self.plistFileSandboxPath);
        if (!fileIsExist) {
            self.getPlistData();
            self.savePlist();
        }
    }
    
    func getPlistData() {
        self.plistData = NSMutableDictionary();
        self.plistData = NSMutableDictionary(contentsOfFile: self.plistFilePath)!;
    }
    
    func getPlistDataSandbox() {
        self.plistData = NSMutableDictionary();
        self.plistData = NSMutableDictionary(contentsOfFile: self.plistFileSandboxPath)!;
    }
    
    func savePlist() {
        self.plistData.writeToFile(self.plistFileSandboxPath, atomically: false);
    }
    
    func editPlistData(key: String, value: String) {
        self.plistData[key] = value;
    }
    
    //MARK: process with read-only file
    func getOnlyLoadPlist(fileName: String) -> NSMutableDictionary {
        let filePath: String = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist")!;
        return NSMutableDictionary(contentsOfFile: filePath)!;
    }
}
