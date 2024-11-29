//
//  CJDateUtil.swift
//  CJUIKitDemo
//
//  Created by qian on 2024/11/30.
//  Copyright © 2024 dvlproad. All rights reserved.
//
//  重复日计算（支持公历和农历）
// 根据当前日期的农历时间，获取下一个周期的指定类型的时间。例如当前日期是2024-03-10，即其为农历二月初十。则当按月计算下一个时间的时候，应该是农历三月初始的那个时间。如果按年的话是明年的农历二月初十。请给出算法，确保运行结果正确，并且需要考虑到当按月的时候，如果下个月不存在该天，则往后一天，即如果是正月三十，下个月是二月，但是二月可能只有二十八或者二十九天（根据是否闰年不同），没有三十号，则应该对应到三月之后的初一或者初二了。
// 在以上基础上，增加如果要计算的日期相比另一个指定日期，当按月时候如果要计算的日期的天大于指定日期的天，则月份不用加，反之则要加1。同样的，当按年的时候，如果要计算的日期的月大于指定日期的月，则年不用加，反之则年要加1

import Foundation

// 周期类型定义
enum CycleType {
    case month
    case year
}

struct CJRepateDateGetter {
    /// 获取下一个周期的农历时间
    /// - Parameters:
    ///   - selectedDate: 当前日期（公历）
    ///   - calendar: 使用的农历 `Calendar`
    ///   - cycleType: 周期类型（按月 or 按年）
    ///   - comparisonDate: 用于比较的指定日期（公历）
    ///   - shouldFlyback: 当前为1月31号，则点击每月时候，为每月31号，当到2月的时候是否需要回退到月末
    /// - Returns: 下一个重复周期的日期（公历）
    static func nextLunarCycleDate(from selectedDate: Date, using calendar: Calendar = Calendar(identifier: .chinese), cycleType: CycleType, comparisonDate: Date, shouldFlyback: Bool) -> Date? {
        print("\n要计算的日期：\(CJDateFormatterUtil.formatLunarDate(from: selectedDate, using: calendar))【\(CJDateFormatterUtil.formatGregorianDate(from: selectedDate))】")
        print("比较当前日期：\(CJDateFormatterUtil.formatLunarDate(from: comparisonDate, using: calendar))【\(CJDateFormatterUtil.formatGregorianDate(from: comparisonDate))】")
        
        // 获取当前日期和指定比较日期的农历信息
        var selectedComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let comparisonComponents = calendar.dateComponents([.year, .month, .day], from: comparisonDate)
        
        guard let selectedDay = selectedComponents.day, let comparisonDay = comparisonComponents.day, let comparisonMonth = comparisonComponents.month else {
            return nil
        }
        
        var cycleTypeString = ""
        var compareResultString = ""
        switch cycleType {
        case .month:
            cycleTypeString = "每月\(selectedDay)号"
            // 比较“天”是否需要调整月份
            if comparisonDay > selectedDay {
                compareResultString = "本月现在已是\(comparisonDay)号，已过了\(selectedDay)号，即下个\(selectedDay)号得到下月"
                selectedComponents.month = (comparisonComponents.month ?? 1) + 1
            } else {
                compareResultString = "本月现在还是\(comparisonDay)号，还未到\(selectedDay)号，即下个\(selectedDay)号还在本月"
                selectedComponents.month = (comparisonComponents.month ?? 1)
            }
            
        case .year:
            // 比较“月”是否需要调整年份
            if let selectedMonth = selectedComponents.month {
                cycleTypeString = "每年\(selectedMonth)月\(selectedDay)号"
                if comparisonMonth > selectedMonth || (comparisonMonth == selectedMonth && comparisonDay > selectedDay ) {
                    compareResultString = "今年现在已是\(comparisonMonth)月\(comparisonDay)号，已过了\(selectedMonth)月\(selectedDay)号，即下个\(selectedMonth)月\(selectedDay)号得到明年"
                    selectedComponents.year = (comparisonComponents.year ?? 0) + 1
                } else {
                    compareResultString = "今年现在还是\(comparisonMonth)月\(comparisonDay)号，还未到\(selectedMonth)月\(selectedDay)号，即下个\(selectedMonth)月\(selectedDay)号还在今年"
                    selectedComponents.year = (comparisonComponents.year ?? 0)
                }
            } else {
                compareResultString = "按年计算时候，出错了。。。"
            }
            
        }
        
        if shouldFlyback { // 当前为1月31号，则点击每月时候，为每月31号，当到2月的时候是否需要回退到月末
            var nextMonthComponents = selectedComponents
            nextMonthComponents.day = 1
            if let nextMonthDate = calendar.date(from: nextMonthComponents) {
                let range = calendar.range(of: .day, in: .month, for: nextMonthDate)
                let daysInNextMonth = range?.count ?? 0 // 最后一天是几号
                if selectedDay > daysInNextMonth {
                    let selectedDateRange = calendar.range(of: .day, in: .month, for: selectedDate)
                    let daysInSelectedDate = selectedDateRange?.count ?? 0
                    selectedComponents.day = daysInNextMonth // 让其为最后一天
                }
            }
        }
        
        // 确保下一个周期的日期存在，处理农历月份天数不一致的问题
        if let nextDate = calendar.date(from: selectedComponents) {
            print("\(cycleTypeString)：<\(compareResultString)>的日期存在：\(CJDateFormatterUtil.formatLunarDate(from: nextDate, using: calendar))【\(CJDateFormatterUtil.formatGregorianDate(from: nextDate))】")
            return nextDate
        } else {
            // 如果当前农历日不存在于下一个周期，则向后调整到有效日期
            print("当前农历日 \(comparisonDay) 在目标月份无效，开始调整...")
            var adjustedComponents = comparisonComponents
            while adjustedComponents.day ?? 1 > 1 {
                adjustedComponents.day! -= 1
                if let validDate = calendar.date(from: adjustedComponents) {
                    print("\(cycleTypeString)：<\(compareResultString)>但调整后的有效日期为：\(CJDateFormatterUtil.formatLunarDate(from: validDate, using: calendar))【\(CJDateFormatterUtil.formatGregorianDate(from: validDate))】")
                    return validDate
                }
            }
            print("未找到有效日期")
            return nil
        }
    }
}

struct CJDateIntervalUtil {
    /// 获取指定日期所在月份的所有天数
    /// - Parameter date: 输入的日期
    /// - Returns: 包含所有天数的数组
    static func getDaysInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        
        // 获取当前月份的范围
        guard let monthRange = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        
        // 获取当前月份的开始日期
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }
        
        // 遍历范围并生成每一天的 Date
        return monthRange.compactMap { day -> Date? in
            var components = calendar.dateComponents([.year, .month], from: monthStart)
            components.day = day
            return calendar.date(from: components)
        }
    }

}

struct CJDateFormatterUtil {
    /// 格式化农历日期
    static func formatLunarDate(from date: Date, using calendar: Calendar) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let lunarYear = components.year ?? 0
        let lunarMonth = components.month ?? 0
        let lunarDay = components.day ?? 0
        return "农历 \(lunarYear)年\(lunarMonth)月\(lunarDay)日"
    }
    
    /// 格式化公历日期
    static func formatGregorianDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

struct CJDateCompareUtil {
    //比较两个日期是否相等，只考虑年、月、日
    static func areDatesEqualIgnoringTime(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
//        let componentsToCompare: Set<Calendar.Component> = [.year, .month, .day]
        
        return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
    }
}


