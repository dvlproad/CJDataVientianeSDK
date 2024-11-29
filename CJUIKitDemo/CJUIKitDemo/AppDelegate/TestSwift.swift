//
//  TestSwift.swift
//  CJUIKitDemo
//
//  Created by qian on 2024/11/30.
//  Copyright © 2024 dvlproad. All rights reserved.
//

import Foundation
import CJFoundation_Swift

class TestSwift1: NSObject {
    func test() {
        CJFoundation_Swift.DateUtil.xx_dateToString(date: Date())
//        CJFoundation_Swift.DateUtil.xx_dateToString(date: Date())
//        let str = CJFoundation_Swift.DateUtil.xx_dateToString(date: Date())
//        print(str)
    }
    
    @objc func printDate() {
        // 测试
//        let currentDate = Date() // 当前日期
//        let currentDate = createDate()
//        let comparisonDate = Calendar.current.date(byAdding: .day, value: -10, to: currentDate)! // 比较日期
        
        // 公历
        // 按月计算下一个周期
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2024-03-19", currentDateString: "2024-03-09", correctResultDateString: "2024-03-19")
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2024-04-08", currentDateString: "2024-11-29", correctResultDateString: "2024-12-08")

        // 按年计算下一个周期
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2024-02-29", currentDateString: "2024-11-29", correctResultDateString: "2025-03-01")
        
        
        // 农历
        // 按月计算下一个周期
        checkNearbyMonth(isLunarCalendar: true, selectedDateString: "2024-03-19", currentDateString: "2024-03-09", correctResultDateString: "2024-03-19") // 农历二月初十
        checkNearbyMonth(isLunarCalendar: true, selectedDateString: "2024-04-08", currentDateString: "2024-11-29", correctResultDateString: "2024-11-30")

        // 按年计算下一个周期
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-04-06", currentDateString: "2024-11-29", correctResultDateString: "2025-03-27")  // 农历二月二十八
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-04-07", currentDateString: "2024-11-29", correctResultDateString: "2025-03-28")  // 农历二月二十九
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-04-08", currentDateString: "2024-11-29", correctResultDateString: "2025-03-29")  // 农历二月三十
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-02-29", currentDateString: "2024-11-29", correctResultDateString: "2025-02-17")
    }
    
    
    func checkNearbyMonth(isLunarCalendar: Bool, selectedDateString: String, currentDateString: String, correctResultDateString: String) {
        let selectedDate = dateFromYYYYMMDDString(dateString: selectedDateString)
        let comparisonDate = dateFromYYYYMMDDString(dateString: currentDateString)
        
        let lunarCalendar = Calendar(identifier: isLunarCalendar ? .chinese : .gregorian)
        if let nextMonthDate = CJRepateDateGetter.nextLunarCycleDate(from: selectedDate, using: lunarCalendar, cycleType: .month, comparisonDate: comparisonDate) {
//            print("按月计算下一个农历日期为：\(formatLunarDate(from: nextMonthDate, using: lunarCalendar))【\(formatGregorianDate(from: nextMonthDate))】")
            let correctResultDate = dateFromYYYYMMDDString(dateString: correctResultDateString)
            if !CJDateCompareUtil.areDatesEqualIgnoringTime(nextMonthDate, correctResultDate) {
                print("❌每月几号不正确：\(CJDateFormatterUtil.formatLunarDate(from: nextMonthDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextMonthDate))】，应该为：\(CJDateFormatterUtil.formatLunarDate(from: correctResultDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: correctResultDate))】")
            }
        }
    }
    
    // 按年计算下一个周期
    func checkNearbyYear(isLunarCalendar: Bool, selectedDateString: String, currentDateString: String, correctResultDateString: String) {
        let selectedDate = dateFromYYYYMMDDString(dateString: selectedDateString)
        let comparisonDate = dateFromYYYYMMDDString(dateString: currentDateString)
        
        let lunarCalendar = Calendar(identifier: isLunarCalendar ? .chinese : .gregorian)
        if let nextYearDate = CJRepateDateGetter.nextLunarCycleDate(from: selectedDate, using: lunarCalendar, cycleType: .year, comparisonDate: comparisonDate) {
//            print("按年计算下一个农历日期为：\(formatLunarDate(from: nextYearDate, using: lunarCalendar))【\(formatGregorianDate(from: nextYearDate))】")
            let correctResultDate = dateFromYYYYMMDDString(dateString: correctResultDateString)
            if !CJDateCompareUtil.areDatesEqualIgnoringTime(nextYearDate, correctResultDate) {
                print("❌每年几月几号不正确：\(CJDateFormatterUtil.formatLunarDate(from: nextYearDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextYearDate))】，应该为：\(CJDateFormatterUtil.formatLunarDate(from: correctResultDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: correctResultDate))】")
            }
        }
    }
    
    func createDate() -> Date {
//        let date1 = Date(year: 2024, month: 3, day: 10)
//        let date2 = Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 10))!
        let lunarCalendar = Calendar(identifier: .chinese)
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 3
        dateComponents.day = 19
        if let date = calendar.date(from: dateComponents) {
            print("选中的日期是:  \(CJDateFormatterUtil.formatGregorianDate(from: date))【\(CJDateFormatterUtil.formatLunarDate(from: date, using: lunarCalendar))】")
            return date
        } else {
            print("创建日期失败")
            return Date()
        }
    }
    
    func dateFromYYYYMMDDString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 避免时区问题
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // 设置时区为 GMT

        if let date = dateFormatter.date(from: dateString) {
            //let lunarCalendar = Calendar(identifier: .chinese)
            //print("日期是:  \(formatGregorianDate(from: date))【\(formatLunarDate(from: date, using: lunarCalendar))】")
            return date
        } else {
            print("创建日期失败")
            return Date()
        }
        
    }
}

class TestSwif2 {
    
}


// 必须继承于 NSObject
class TestPerson: NSObject {
    // 想公开给OC的要使用 @objc 修饰
    @objc var name: String
    @objc var age : Int

    @objc init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
