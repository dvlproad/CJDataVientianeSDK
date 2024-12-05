//
//  CJCalendarDateExtension.swift
//  CJUIKitDemo
//
//  Created by qian on 2024/12/5.
//  Copyright © 2024 dvlproad. All rights reserved.
//
//  时间在日历中的扩展

import Foundation

extension Date {
    /// 获取本时间所在的【公历/农历】年份中有多少个月，以及当前月有多少天。请不要使用此方法计算农历有多少个月，因为本方法在农历有闰月的时候计算结果不对。
    /// 场景：日期选择器弹起来的时候，天那一列要有多少个元素
    func currentMonthDayCountTuple(inLunarCalendar: Bool = false) -> (monthCount: Int, dayCount: Int)? {
        let calendar = Calendar(identifier: inLunarCalendar ? .chinese : .gregorian)
 
        let monthRange = calendar.range(of: .month, in: .year, for: self)
        let monthCount: Int? = monthRange?.count
        if monthCount == nil {
            return nil
        }
        
        let dayRange = calendar.range(of: .day, in: .month, for: self)
        let dayCount: Int? = dayRange?.count
        if dayCount == nil {
            return nil
        }
        
        return (monthCount!, dayCount!)
    }
    
    /// 获取农历指定年有的月数。使用场景：日历表滑动时候，判断指定的年有多少个月，避免当前是31号，然后选的那月没有31号，而导致调到下个月。正确的应该是显示那月的末尾
    /// - Parameters:
    ///   - inLunarCalendar: 是否是农历
    ///   - year: 指定的年
    ///   - leapMonthNumber: 那年闰月所在的位置，有闰月的时候值为1-12，没有闰月的时候值为0
    /// - Returns: 农历指定年有的月数
    static func getLunarMonthStringsInSpicialYear(year: Int, leapMonthNumber: Int) -> [String] {
        var lunarMonthNumberStrings = ["正", "二" ,"三", "四", "五", "六", "七", "八" ,"九", "十", "冬", "腊"]
        if leapMonthNumber > 0 {
            let leapMonthString = "闰\(lunarMonthNumberStrings[leapMonthNumber - 1])"
            lunarMonthNumberStrings.insert(leapMonthString, at: leapMonthNumber)
        }
        return lunarMonthNumberStrings
    }
    
    /// 获取公历/农历指定年月有的天数。使用场景：日历表滑动时候，判断指定的年月有多少天，避免当前是31号，然后选的那月没有31号，而导致调到下个月。正确的应该是显示那月的末尾
    /// - Parameters:
    ///   - inLunarCalendar: 是否是农历
    ///   - year: 指定的年
    ///   - monthNumberString: 指定的月。为月的数字字符串。格林时候为1-12，中文日历时候为正、二、三、...、腊，不包含月字
    /// - Returns: 公历/农历指定年月有的天数
    static func getDayStringsInSpicialYearAndMonth(inLunarCalendar: Bool, year: Int, monthNumberString: String) -> [String] {
        var newDateWithMonthFirstDay: Date
        if inLunarCalendar {
            let lunarMediumString = "\(year)年\(monthNumberString)月初一" // 不能使用之前的值，因为之前可能是三十号，但新的这个month所在的月可能没有三十号，而导致到时候会跳到下个月去
            newDateWithMonthFirstDay = Date.fromLunarMediumString(lunarMediumString) ?? errorDate()
        } else {
            let calendar = Calendar.current
            var components = DateComponents()
            components.year = year
            components.month = (monthNumberString as NSString).integerValue
            components.day = 1
            components.calendar = Calendar(identifier: .gregorian)
            newDateWithMonthFirstDay = calendar.date(from: components) ?? errorDate()
        }
        let monthAndDayTuple = newDateWithMonthFirstDay.currentMonthDayCountTuple(inLunarCalendar: inLunarCalendar)
        let dayCount: Int = monthAndDayTuple?.dayCount ?? 29
        
        if inLunarCalendar {
            let maxDays = ["初一", "初二" ,"初三", "初四", "初五", "初六", "初七", "初八" ,"初九", "初十", "十一", "十二", "十三", "十四" ,"十五", "十六", "十七", "十八", "十九", "二十" ,"廿一", "廿二", "廿三", "廿四", "廿五", "廿六" ,"廿七", "廿八", "廿九", "三十"]
            return Array(maxDays.prefix(dayCount))
        } else {
            return (1...dayCount).map { "\($0)日" }
        }
    }
    
    /// 将形如 "2025年腊月二十" String 转为 Date
    static func fromLunarMediumString(_ lunarMediumString: String) -> Date? {
        let calendar = Calendar(identifier: .chinese)

        let chineseFormatter = DateFormatter()
        chineseFormatter.locale = Locale(identifier: "zh_CN")
        chineseFormatter.dateStyle = .medium
        chineseFormatter.calendar = calendar
        
        let date: Date? = chineseFormatter.date(from: lunarMediumString)
        return date
    }
}
