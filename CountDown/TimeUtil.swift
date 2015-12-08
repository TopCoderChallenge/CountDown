//
//  TimeUtil.swift
//  CountDown
//
//  Created by 侯 翔 on 2015/12/04.
//  Copyright © 2015年 HX Studio. All rights reserved.
//

import Foundation

class TimeUtil {
    static var TU: TimeUtil? = nil;
    
    static func instance() -> TimeUtil {
        if (TU == nil) {
            TU = TimeUtil();
        }
        return TU!;
    }
    
    var dateFormatter: NSDateFormatter? = nil;
    
    init() {
        dateFormatter = NSDateFormatter();
    }
    
    func getStringFromNSDate(date: NSDate, formatter: String) -> String {
        dateFormatter!.dateFormat = formatter;
        return dateFormatter!.stringFromDate(date);
    }
    
    func getNSDateFromString(date: String, formatter: String) ->NSDate {
        dateFormatter!.dateFormat = formatter;
        return (dateFormatter?.dateFromString(date))!;
    }
    
    // Set nsdate valve to 0 o'clock
    func setZeroOclock(date: NSDate) -> NSDate {
        var formatterCondition: String = "yyyy-MM-dd";
        let date: String = self.getStringFromNSDate(date, formatter: formatterCondition) + " 00:00:00";
        formatterCondition = "yyyy-MM-dd HH:mm:ss";
        return self.getNSDateFromString(date, formatter: formatterCondition);
    }
    
    // Calculate remain days
    func getRemainingDays(var from: NSDate, var to: NSDate) -> Int {
        var days: Int = 0;
        from = self.setZeroOclock(from);
        to = self.setZeroOclock(to);
        let formatterCondition: String = "yyyyMMdd";
        let currentDate: String = getStringFromNSDate(from, formatter: formatterCondition);
        let targetDate: String = getStringFromNSDate(to, formatter: formatterCondition);
        let fromDate: Int = Int(currentDate)!;
        let toDate: Int = Int(targetDate)!;
        if (fromDate > toDate) {
            days = -1;
        }
        else {
            let nt: NSTimeInterval = to.timeIntervalSinceDate(from);
            days = Int(nt / (60 * 60 * 24));
        }
        return days;
    }
    
}