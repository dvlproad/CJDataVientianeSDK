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
    
    @objc func getLeapMonth() {
        printLeapMonthInfo(dateString: "2023-01-01", correctResultDateString: "2023年有农历闰二月")
        printLeapMonthInfo(dateString: "2024-01-01", correctResultDateString: "2024年无农历闰月")
        printLeapMonthInfo(dateString: "2025-01-01", correctResultDateString: "2025年有农历闰六月")
    }
    
    @objc func isNextLunarMonthEqual() {
        // 闰六月
        isNextLunarMonthEqualToCurrentMonth(dateString: "2025-06-25", correctResultString: "下个月【是】本月的闰月")   // 六月初一
        isNextLunarMonthEqualToCurrentMonth(dateString: "2025-07-24", correctResultString: "下个月【是】本月的闰月")   // 六月三十
        isNextLunarMonthEqualToCurrentMonth(dateString: "2025-07-25", correctResultString: "下个月【不是】本月的闰月")  // 闰六月初一
        isNextLunarMonthEqualToCurrentMonth(dateString: "2025-08-23", correctResultString: "下个月【不是】本月的闰月")  // 七月初一
    }
    
    @objc func findNextEqualLunarDate() {
        print("【农历】：纪念日为2020-03-23，即以农历每年二月三十为例（考虑今年或明年有没有二月三十,以及没有的时候是做回归到月末，还是补偿到下月初）+闰月")
        findNextEqualLunarDate(fromDateString: "2023-03-20", targetDateString: "2020-03-23", correctResultString: "2023-03-21")   // 二月三十
        findNextEqualLunarDate(fromDateString: "2023-03-22", targetDateString: "2020-03-23", correctResultString: "2023-04-19")   // 闰二月廿九（没有三十号）
    }
    
    @objc func findNextEqualLunarDate(fromDateString: String, targetDateString:String, correctResultString: String) {
        let fromDate = greDateFromYYYYMMDDString(dateString: fromDateString)
        let targetDate = greDateFromYYYYMMDDString(dateString: targetDateString)
        
        let nextEqualDate: Date? = targetDate.findNextEqualLunarDateFromDate(fromDate)
        var resultString: String
        if nextEqualDate == nil {
            resultString = "下个月没有与之相等的日期"
        } else {
            resultString = nextEqualDate!.format("yyyy-MM-dd")
        }
        
        if resultString != correctResultString {
            print("❌\(fromDateString)之后与\(targetDateString)相等的日期为\(correctResultString)，但结果错误\(resultString)")
        } else {
            print("✅\(fromDateString)之后与\(targetDateString)相等的日期为\(correctResultString)，结果正确")
        }
    }
    
    
    
    
    
    
    @objc func printLunarDateString() {
        // 不在 1984-2044 年之间的时间
        lunarStringForDate(dateString: "1982-01-01", correctResultDateString: "1981辛酉年腊月初七")
        lunarStringForDate(dateString: "1984-01-01", correctResultDateString: "1983癸亥年冬月廿九")
        lunarStringForDate(dateString: "1986-01-01", correctResultDateString: "1985乙丑年冬月廿一")
        lunarStringForDate(dateString: "2044-01-01", correctResultDateString: "2043癸亥年腊月初二")
        lunarStringForDate(dateString: "2025-08-01", correctResultDateString: "2025乙巳年闰六月初八")
        
        // 在 1984-2044 年之间的时间
        lunarStringForDate(dateString: "2024-03-19", correctResultDateString: "2024甲辰年二月初十")
        lunarStringForDate(dateString: "2024-10-01", correctResultDateString: "2024甲辰年八月廿九")
        lunarStringForDate(dateString: "2025-01-03", correctResultDateString: "2024甲辰年腊月初四")
        lunarStringForDate(dateString: "2025-02-05", correctResultDateString: "2025乙巳年正月初八")
        
        // 2064
        lunarStringForDate(dateString: "2025-08-01", correctResultDateString: "2025乙巳年闰六月初八")
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
        
        // 公历：纪念日为2020-01-31，即以公历每年1月31日为例（考虑下个月有没有31号,以及没有的时候是做回归到月末，还是补偿到下月初）
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2024-01-31", currentDateString: "2024-02-02", shouldFlyback: true, correctResultDateString: "2024-02-29")
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2025-01-31", currentDateString: "2025-02-02", shouldFlyback: false, correctResultDateString: "2025-03-03")
        checkNearbyMonth(isLunarCalendar: false, selectedDateString: "2025-01-31", currentDateString: "2025-02-02", shouldFlyback: true, correctResultDateString: "2025-02-28")

        // 农历
        checkNearbyMonth(isLunarCalendar: true, selectedDateString: "2024-03-19", currentDateString: "2024-03-09", correctResultDateString: "2024-03-19") // 农历二月初十
        checkNearbyMonth(isLunarCalendar: true, selectedDateString: "2024-04-08", currentDateString: "2024-11-29", correctResultDateString: "2024-11-30")

        
    }
    
    // 按年计算下一个周期
    @objc func getNextRepateDate_year() {
        print("按年计算下一个周期【公历】：纪念日为2020-02-28，即以公历每年2月28日为例（每年都有2月28日）")
        // 【公历】：纪念日为2020-02-28，即以公历每年2月28日为例（每年都有2月28日）
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-28", currentDateString: "2024-01-01", correctResultDateString: "2024-02-28")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-28", currentDateString: "2024-02-28", correctResultDateString: "2024-02-28")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-28", currentDateString: "2024-03-01", correctResultDateString: "2025-02-28")
        
        print("按年计算下一个周期【公历】：纪念日为2020-02-29，即以公历每年2月29日为例（考虑今年或明年有没有02月29号,以及没有的时候是做回归到月末，还是补偿到下月初）")
        // 【公历】：纪念日为2020-02-29，即以公历每年2月29日为例（考虑今年或明年有没有02月29号,以及没有的时候是做回归到月末，还是补偿到下月初）
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2023-01-01", shouldFlyback: true, correctResultDateString: "2023-02-28")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2023-01-01", shouldFlyback: false, correctResultDateString: "2023-03-01")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2023-03-01", shouldFlyback: true, correctResultDateString: "2024-02-29")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2024-01-01", shouldFlyback: true, correctResultDateString: "2024-02-29")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2024-02-29", shouldFlyback: true, correctResultDateString: "2024-02-29")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2024-03-01", shouldFlyback: true, correctResultDateString: "2025-02-28")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2024-03-01", shouldFlyback: false, correctResultDateString: "2025-03-01")
        
        
        print("按年计算下一个周期【农历】：纪念日为2026-07-14，即以农历每年六月初一为例（每年都有年六月初一）")
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2026-07-14", currentDateString: "2025-07-24", correctResultDateString: "2025-07-25")    // 当前2025-07-24农历六月三十
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2026-07-14", currentDateString: "2025-07-25", correctResultDateString: "2025-07-25")    // 当前2025-07-25农历闰六月初一
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2026-07-14", currentDateString: "2025-07-26", correctResultDateString: "2026-07-14")    // 当前2025-07-26农历闰六月初二
        print("按年计算下一个周期【农历】：纪念日为2019-03-06，即以农历每年正月三十为例（考虑今年或明年有没有正月三十,以及没有的时候是做回归到月末，还是补偿到下月初）")
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2019-03-06", currentDateString: "2024-03-01", shouldFlyback: true, correctResultDateString: "2024-03-09") // 结果 2024-03-09正月廿九
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2019-03-06", currentDateString: "2024-03-10", shouldFlyback: true, correctResultDateString: "2025-02-27") // 结果 2024-03-09正月三十
        print("按年计算下一个周期【农历】：纪念日为2020-03-23，即以农历每年二月三十为例（考虑今年或明年有没有二月三十,以及没有的时候是做回归到月末，还是补偿到下月初）+闰月")
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2020-03-23", currentDateString: "2023-03-20", shouldFlyback: true, correctResultDateString: "2023-03-21") // 结果 2023-03-21二月三十
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2020-03-23", currentDateString: "2023-03-21", shouldFlyback: true, correctResultDateString: "2023-03-21") // 结果 2023-03-21二月三十
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2020-03-23", currentDateString: "2023-03-22", shouldFlyback: true, correctResultDateString: "2023-04-19") // 结果 2023-04-19闰二月廿九
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2020-03-23", currentDateString: "2023-04-19", shouldFlyback: true, correctResultDateString: "2023-04-19") // 结果 2023-04-19闰二月廿九
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2020-03-23", currentDateString: "2024-04-20", shouldFlyback: true, correctResultDateString: "2025-03-28") // 结果 2025-03-28二月廿九
        
        
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-04-06", currentDateString: "2024-11-29", correctResultDateString: "2025-03-27")  // 纪念日农历二月廿八
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-04-07", currentDateString: "2024-11-29", correctResultDateString: "2025-03-28")  // 纪念日农历二月廿九
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-04-08", currentDateString: "2024-11-29", correctResultDateString: "2025-03-29")  // 纪念日农历二月三十
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2024-02-29", currentDateString: "2024-11-29", correctResultDateString: "2025-02-17")
        
        
        
        
        
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2024-11-29", correctResultDateString: "2025-03-01")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2024-10-02", shouldFlyback: false, correctResultDateString: "2025-03-01")
        checkNearbyYear(isLunarCalendar: false, selectedDateString: "2020-02-29", currentDateString: "2024-10-02", shouldFlyback: true, correctResultDateString: "2025-02-28")
        
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2023-02-01", currentDateString: "2024-11-29", correctResultDateString: "2025-02-08")   // 农历2023年正月十一
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2023-02-20", currentDateString: "2024-11-29", correctResultDateString: "2025-02-28")   // 农历2023年二月初一
        checkNearbyYear(isLunarCalendar: true, selectedDateString: "2023-03-22", currentDateString: "2024-11-29", correctResultDateString: "2025-02-28")   // 农历2023年闰二月初一
    }
    
    func lunarStringForDate(dateString: String, correctResultDateString: String) -> String {
        let date = greDateFromYYYYMMDDString(dateString: dateString)
        let lunarString = CJDateFormatterUtil.lunarStringForDate(from: date)
        if lunarString != correctResultDateString {
            print("❌\(CJDateFormatterUtil.formatGregorianDate(from: date))【\(correctResultDateString)】，农历展示错误\(lunarString)")
        } else {
            print("✅\(CJDateFormatterUtil.formatGregorianDate(from: date))【\(correctResultDateString)】，农历展示正确")
        }
        return lunarString
    }
    
    @objc func printLeapMonthInfo(dateString: String, correctResultDateString: String) {
        let date = greDateFromYYYYMMDDString(dateString: dateString)
        let lunarLeapMonthTuple = date.getThisYearLunarLeapMonthTuple()
        
        var resultString: String
        let year: Int = Int(dateString.prefix(4)) ?? 0
        if lunarLeapMonthTuple == nil {
            resultString = "\(year)年无农历闰月"
        } else {
            // 重要：如果是在农历里面找，并且该纪念月刚好是闰月则应该加上"闰"字
            let lunarLeapMonthCNName = lunarLeapMonthTuple!.lunarLeapMonthCNName
            resultString = "\(year)年有农历\(lunarLeapMonthCNName)"
        }
        
        if resultString != correctResultDateString {
            print("❌\(correctResultDateString)，但结果错误\(resultString)")
        } else {
            print("✅\(correctResultDateString)，结果正确")
        }
    }
    
    @objc func isNextLunarMonthEqualToCurrentMonth(dateString: String, correctResultString: String) {
        let date = greDateFromYYYYMMDDString(dateString: dateString)
        
        let isNextLeapMonth = date.isNextLunarMonthEqualToCurrentMonth()
        
        var resultString: String
        if isNextLeapMonth {
            resultString = "下个月【是】本月的闰月"
        } else {
            resultString = "下个月【不是】本月的闰月"
        }
        
        if resultString != correctResultString {
            print("❌\(correctResultString)，但结果错误\(resultString)")
        } else {
            print("✅\(correctResultString)，结果正确")
        }
    }
    
    func checkNearbyWeek(isLunarCalendar: Bool, selectedDateString: String, currentDateString: String, shouldFlyback: Bool = false, correctResultDateString: String) {
        let selectedDate = greDateFromYYYYMMDDString(dateString: selectedDateString)
        let comparisonDate = greDateFromYYYYMMDDString(dateString: currentDateString)
        
        let lunarCalendar = Calendar(identifier: isLunarCalendar ? .chinese : .gregorian)
        if let nextWeekDate = selectedDate.closestCommemorationDate(commemorationCycleType: .week, afterDate: comparisonDate, shouldFlyback: shouldFlyback, calendar: lunarCalendar) {
//            print("按周计算下一个日期为：\(lunarStringForDate(from: nextMonthDate, using: lunarCalendar))【\(formatGregorianDate(from: nextMonthDate))】")
            let correctResultDate = greDateFromYYYYMMDDString(dateString: correctResultDateString)
            if !CJDateCompareUtil.areDatesEqualIgnoringTime(nextWeekDate, correctResultDate) {
                print("❌每周周几不正确：\(CJDateFormatterUtil.lunarStringForDate(from: nextWeekDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextWeekDate))】【\(CJRepateDateGetter.getWeekdayString(from: nextWeekDate))】，应该为：\(CJDateFormatterUtil.lunarStringForDate(from: correctResultDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: correctResultDate))】【\(CJRepateDateGetter.getWeekdayString(from: correctResultDate))】")
            } else {
                print("✅每周周几正确：\(correctStringForDate(calendar: lunarCalendar, nextRepateDate: nextWeekDate, currentDate: comparisonDate)))")
            }
        }
    }
    
    
    func checkNearbyMonth(isLunarCalendar: Bool, selectedDateString: String, currentDateString: String, shouldFlyback: Bool = false, correctResultDateString: String) {
        let selectedDate = greDateFromYYYYMMDDString(dateString: selectedDateString)
        let comparisonDate = greDateFromYYYYMMDDString(dateString: currentDateString)
        
        let lunarCalendar = Calendar(identifier: isLunarCalendar ? .chinese : .gregorian)
        if let nextMonthDate = selectedDate.closestCommemorationDate(commemorationCycleType: .month, afterDate: comparisonDate, shouldFlyback: shouldFlyback, calendar: lunarCalendar) {
//            print("按月计算下一个日期为：\(lunarStringForDate(from: nextMonthDate, using: lunarCalendar))【\(formatGregorianDate(from: nextMonthDate))】")
            let correctResultDate = greDateFromYYYYMMDDString(dateString: correctResultDateString)
            if !CJDateCompareUtil.areDatesEqualIgnoringTime(nextMonthDate, correctResultDate) {
                print("❌每月几号不正确：\(CJDateFormatterUtil.lunarStringForDate(from: nextMonthDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextMonthDate))】，应该为：\(CJDateFormatterUtil.lunarStringForDate(from: correctResultDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: correctResultDate))】")
            } else {
                print("✅每月几号正确：\(correctStringForDate(calendar: lunarCalendar, nextRepateDate: nextMonthDate, currentDate: comparisonDate)))")
            }
        }
    }
    
    // 按年计算下一个周期
    func checkNearbyYear(isLunarCalendar: Bool, selectedDateString: String, currentDateString: String, shouldFlyback: Bool = false, correctResultDateString: String) {
        let selectedDate = greDateFromYYYYMMDDString(dateString: selectedDateString)
        let comparisonDate = greDateFromYYYYMMDDString(dateString: currentDateString)
        
        let lunarCalendar = Calendar(identifier: isLunarCalendar ? .chinese : .gregorian)
        if let nextYearDate = selectedDate.closestCommemorationDate(commemorationCycleType: .year, afterDate: comparisonDate, shouldFlyback: shouldFlyback, calendar: lunarCalendar) {
//            print("按年计算下一个日期为：\(lunarStringForDate(from: nextYearDate, using: lunarCalendar))【\(formatGregorianDate(from: nextYearDate))】")
            let correctResultDate = greDateFromYYYYMMDDString(dateString: correctResultDateString)
            if !CJDateCompareUtil.areDatesEqualIgnoringTime(nextYearDate, correctResultDate) {
                print("❌每年几月几号不正确：\(CJDateFormatterUtil.lunarStringForDate(from: nextYearDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextYearDate))】，应该为：\(CJDateFormatterUtil.lunarStringForDate(from: correctResultDate, using: lunarCalendar))【\(CJDateFormatterUtil.formatGregorianDate(from: correctResultDate))】")
            } else {
                print("✅每年几月几号正确：\(correctStringForDate(calendar: lunarCalendar, nextRepateDate: nextYearDate, currentDate: comparisonDate)))")
            }
        }
    }
    

    func correctStringForDate(calendar: Calendar, nextRepateDate: Date, currentDate: Date) -> String {
        let string: String = "\(CJDateFormatterUtil.lunarStringForDate(from: nextRepateDate, using: calendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextRepateDate))】与当前相差\(nextRepateDate.daysBetween(endDate: currentDate))天"
        return string
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
    
    func greDateFromYYYYMMDDString(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

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
