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
    
    @objc func printLunarDateString() {
        lunarStringForDate(dateString: "2024-03-19", correctResultDateString: "2024甲辰年二月初十")
        lunarStringForDate(dateString: "2024-10-01", correctResultDateString: "2024甲辰年八月廿九")
        lunarStringForDate(dateString: "2025-01-03", correctResultDateString: "2024甲辰年腊月初四")
        lunarStringForDate(dateString: "2025-02-05", correctResultDateString: "2025乙巳年正月初八")
    }
    
    // 按周计算下一个周期
    @objc func getNextRepateDate_week() {
        // 公历
        checkNearbyWeek(isLunarCalendar: false, selectedDateString: "2020-05-19", currentDateString: "2024-03-09", correctResultDateString: "2024-03-12")
        checkNearbyWeek(isLunarCalendar: false, selectedDateString: "2024-05-01", currentDateString: "2023-12-25", correctResultDateString: "2023-12-27") // 还没到周三
        checkNearbyWeek(isLunarCalendar: false, selectedDateString: "2024-05-01", currentDateString: "2023-12-28", correctResultDateString: "2024-01-03") // 已过周三，且跨年
        
        // 农历
        checkNearbyWeek(isLunarCalendar: true, selectedDateString: "2020-05-19", currentDateString: "2024-03-09", correctResultDateString: "2024-03-12")
        checkNearbyWeek(isLunarCalendar: true, selectedDateString: "2024-05-01", currentDateString: "2023-12-25", correctResultDateString: "2023-12-27") // 还没到周三
        checkNearbyWeek(isLunarCalendar: true, selectedDateString: "2024-05-01", currentDateString: "2023-12-28", correctResultDateString: "2024-01-03") // 已过周三，且跨年
    }
    
    // 按月计算下一个周期
    @objc func getNextRepateDate_month() {
        // 测试
//        let currentDate = Date() // 当前日期
//        let currentDate = createDate()
//        let comparisonDate = Calendar.current.date(byAdding: .day, value: -10, to: currentDate)! // 比较日期
        
        // 公历
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2024-03-19", currentDateString: "2024-03-09", correctResultDateString: "2024-03-19")
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2024-04-08", currentDateString: "2024-11-29", correctResultDateString: "2024-12-08")
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2024-01-31", currentDateString: "2024-02-02", shouldFlyback: false, correctResultDateString: "2024-03-02")
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2024-01-31", currentDateString: "2024-02-02", shouldFlyback: true, correctResultDateString: "2024-02-29")
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2025-01-31", currentDateString: "2025-02-02", shouldFlyback: false, correctResultDateString: "2025-03-03")
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2025-01-31", currentDateString: "2025-02-02", shouldFlyback: true, correctResultDateString: "2025-02-28")
        
        // 农历
        checkNearbyMonth(isLunarCalendar: true, selectedDateString: "2024-03-19", currentDateString: "2024-03-09", correctResultDateString: "2024-03-19") // 农历二月初十
        checkNearbyMonth(isLunarCalendar: true, selectedDateString: "2024-04-08", currentDateString: "2024-11-29", correctResultDateString: "2024-11-30")

        
    }
    
    // 按年计算下一个周期
    @objc func getNextRepateDate_year() {
        // 公历
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2024-02-29", currentDateString: "2024-11-29", correctResultDateString: "2025-03-01")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2024-02-29", currentDateString: "2024-10-02", shouldFlyback: false, correctResultDateString: "2025-03-01")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2024-02-29", currentDateString: "2024-10-02", shouldFlyback: true, correctResultDateString: "2025-02-28")
        
        // 农历
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-04-06", currentDateString: "2024-11-29", correctResultDateString: "2025-03-27")  // 农历二月二十八
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-04-07", currentDateString: "2024-11-29", correctResultDateString: "2025-03-28")  // 农历二月二十九
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-04-08", currentDateString: "2024-11-29", correctResultDateString: "2025-03-29")  // 农历二月三十
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-02-29", currentDateString: "2024-11-29", correctResultDateString: "2025-02-17")
    }
    
    func lunarStringForDate(dateString: String, correctResultDateString: String) -> String {
        let date = dateFromYYYYMMDDString(dateString: dateString)
        let lunarString = CJDateFormatterUtil.lunarStringForDate(from: date)
        if lunarString != correctResultDateString {
            print("❌\(CJDateFormatterUtil.formatGregorianDate(from: date))【\(correctResultDateString)】，农历展示错误\(lunarString)")
        } else {
            print("✅\(CJDateFormatterUtil.formatGregorianDate(from: date))【\(correctResultDateString)】，农历展示正确")
        }
        return lunarString
    }
    
    func checkNearbyWeek(isLunarCalendar: Bool, selectedDateString: String, currentDateString: String, shouldFlyback: Bool = false, correctResultDateString: String) {
        let selectedDate = dateFromYYYYMMDDString(dateString: selectedDateString)
        let comparisonDate = dateFromYYYYMMDDString(dateString: currentDateString)
        
        let lunarCalendar = Calendar(identifier: isLunarCalendar ? .chinese : .gregorian)
        if let nextMonthDate = selectedDate.closestCommemorationDate(commemorationCycleType: .week, afterDate: comparisonDate, shouldFlyback: shouldFlyback, calendar: lunarCalendar) {
//            print("按周计算下一个日期为：\(lunarStringForDate(from: nextMonthDate, using: lunarCalendar))【\(formatGregorianDate(from: nextMonthDate))】")
            let correctResultDate = dateFromYYYYMMDDString(dateString: correctResultDateString)
            if !CJDateCompareUtil.areDatesEqualIgnoringTime(nextMonthDate, correctResultDate) {
                print("❌每周周几不正确：\(CJDateFormatterUtil.lunarStringForDate(from: nextMonthDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextMonthDate))】【\(CJRepateDateGetter.getWeekdayString(from: nextMonthDate))】，应该为：\(CJDateFormatterUtil.lunarStringForDate(from: correctResultDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: correctResultDate))】【\(CJRepateDateGetter.getWeekdayString(from: correctResultDate))】")
            }
        }
    }
    
    
    func checkNearbyMonth(isLunarCalendar: Bool, selectedDateString: String, currentDateString: String, shouldFlyback: Bool = false, correctResultDateString: String) {
        let selectedDate = dateFromYYYYMMDDString(dateString: selectedDateString)
        let comparisonDate = dateFromYYYYMMDDString(dateString: currentDateString)
        
        let lunarCalendar = Calendar(identifier: isLunarCalendar ? .chinese : .gregorian)
        if let nextMonthDate = selectedDate.closestCommemorationDate(commemorationCycleType: .month, afterDate: comparisonDate, shouldFlyback: shouldFlyback, calendar: lunarCalendar) {
//            print("按月计算下一个日期为：\(lunarStringForDate(from: nextMonthDate, using: lunarCalendar))【\(formatGregorianDate(from: nextMonthDate))】")
            let correctResultDate = dateFromYYYYMMDDString(dateString: correctResultDateString)
            if !CJDateCompareUtil.areDatesEqualIgnoringTime(nextMonthDate, correctResultDate) {
                print("❌每月几号不正确：\(CJDateFormatterUtil.lunarStringForDate(from: nextMonthDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextMonthDate))】，应该为：\(CJDateFormatterUtil.lunarStringForDate(from: correctResultDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: correctResultDate))】")
            }
        }
    }
    
    // 按年计算下一个周期
    func checkNearbyYear(isLunarCalendar: Bool, selectedDateString: String, currentDateString: String, shouldFlyback: Bool = false, correctResultDateString: String) {
        let selectedDate = dateFromYYYYMMDDString(dateString: selectedDateString)
        let comparisonDate = dateFromYYYYMMDDString(dateString: currentDateString)
        
        let lunarCalendar = Calendar(identifier: isLunarCalendar ? .chinese : .gregorian)
        if let nextYearDate = selectedDate.closestCommemorationDate(commemorationCycleType: .year, afterDate: comparisonDate, shouldFlyback: shouldFlyback, calendar: lunarCalendar) {
//            print("按年计算下一个日期为：\(lunarStringForDate(from: nextYearDate, using: lunarCalendar))【\(formatGregorianDate(from: nextYearDate))】")
            let correctResultDate = dateFromYYYYMMDDString(dateString: correctResultDateString)
            if !CJDateCompareUtil.areDatesEqualIgnoringTime(nextYearDate, correctResultDate) {
                print("❌每年几月几号不正确：\(CJDateFormatterUtil.lunarStringForDate(from: nextYearDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextYearDate))】，应该为：\(CJDateFormatterUtil.lunarStringForDate(from: correctResultDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: correctResultDate))】")
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
            print("选中的日期是:  \(CJDateFormatterUtil.formatGregorianDate(from: date))【\(CJDateFormatterUtil.lunarStringForDate(from: date, using: lunarCalendar))】")
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
            //print("日期是:  \(formatGregorianDate(from: date))【\(lunarStringForDate(from: date, using: lunarCalendar))】")
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
