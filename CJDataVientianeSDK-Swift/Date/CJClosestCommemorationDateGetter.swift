//
//  CJClosestCommemorationDateGetter.swift
//  TSDataVientianeDemo
//
//  Created by qian on 2024/11/30.
//  Copyright © 2024 dvlproad. All rights reserved.
//
//  最近的纪念日Recent anniversaries / 重复日计算（支持公历和农历）
// 根据当前日期的农历时间，获取下一个周期的指定类型的时间。例如当前日期是2024-03-10，即其为农历二月初十。则当按月计算下一个时间的时候，应该是农历三月初始的那个时间。如果按年的话是明年的农历二月初十。请给出算法，确保运行结果正确，并且需要考虑到当按月的时候，如果下个月不存在该天，则往后一天，即如果是正月三十，下个月是二月，但是二月可能只有二十八或者二十九天（根据是否闰年不同），没有三十号，则应该对应到三月之后的初一或者初二了。
// 在以上基础上，增加如果要纪念的日期相比另一个指定日期，当按月时候如果要纪念的日期的天大于指定日期的天，则月份不用加，反之则要加1。同样的，当按年的时候，如果要纪念的日期的月大于指定日期的月，则年不用加，反之则年要加1

import Foundation

// MARK: 1、以本时间为纪念日，按指定纪念周期，获取指定日期后的最临近的纪念日；2、将本纪念日时间根据纪念周期输出指定的格式（公历/农历）
// 纪念日周期类型定义
public enum CJCommemorationCycleType: String, Codable {
    case none   // 不重复
    case week   // 每周重复
    case month  // 每月重复
    case year   // 每年重复
}

public extension Date {
    static public func getLatestSpecifiedDate(month: Int, day: Int) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? TimeZone.current
        
        let now = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.month = month
        components.day = day

        // 如果今天的日期已经过了元旦，则返回明年的元旦
        if calendar.compare(now, to: calendar.date(from: components)!, toGranularity: .day) == .orderedDescending {
            components.year = components.year! + 1
        }

        return calendar.date(from: components) ?? now
    }
    
    /// 以本时间为纪念日，按指定纪念周期，获取指定日期后的最临近的纪念日
    /// eg：以本时间为纪念日，按每年重复，获取当前时间之后最临近的纪念日
    /// - Parameters:
    ///   - commemorationCycleType: 周期类型（按周 or 按月 or 按年）
    ///   - afterDate: 在指定日期后
    ///   - shouldFlyback: 当前为1月31号，则点击每月时候，为每月31号，当到2月的时候是否需要回退到月末
    ///   - calendar: 使用的农历 `Calendar`
    /// - Returns: 指定日期后的最临近的纪念日
    public func closestCommemorationDate(commemorationCycleType: CJCommemorationCycleType, afterDate: Date, shouldFlyback: Bool, calendar: Calendar = Calendar(identifier: .chinese)) -> Date? {
//        if self.timeZone != calendar.timeZone {
//            cj_print("xxxxxxxxxxx\(self.timeZone) \(calendar.timeZone)")
//        }
        
        if commemorationCycleType == .none {
            return self
        }
            
        let commemorationDate: Date = self
        cj_print("\n要纪念的日期：\(commemorationDate.lunarDateString())【\(CJDateFormatterUtil.formatGregorianDate(from: commemorationDate))】【\(CJRepateDateGetter.getWeekdayString(from: commemorationDate))】")
        cj_print("比较当前日期：\(afterDate.lunarDateString())【\(CJDateFormatterUtil.formatGregorianDate(from: afterDate))】【\(CJRepateDateGetter.getWeekdayString(from: afterDate))】")
        
        // 获取当前日期和指定比较日期的农历信息
        let commemorationComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: commemorationDate)
        let comparisonComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: afterDate)
        
        guard let selectedDay = commemorationComponents.day, let comparisonDay = comparisonComponents.day, let comparisonMonth = comparisonComponents.month else {
            return nil
        }
        
        var resultComponents = commemorationComponents
        var cycleTypeString = ""
        var compareResultString = ""
        switch commemorationCycleType {
        case .week:
            // 比较“星期几”是否需要调整到周
            let comparisonWeekdayIndex = (comparisonComponents.weekday ?? 1) - 1
            let selectedWeekdayIndex = (commemorationComponents.weekday ?? 1) - 1
            
            let weekdayStrings = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
            let selectedWeekdayString = weekdayStrings[selectedWeekdayIndex]
            let comparisonWeekdayString = weekdayStrings[comparisonWeekdayIndex]
            cycleTypeString = "每周\(selectedWeekdayString)"
            
            // 周7 > 周2 : 相差2 = 2-7 + 7
            // 周6 > 周3 : 相差4 = 3-6 + 7
            // 周3 < 周4 : 相差1 = 4-3 + 0
            var shouldAddDayCount: Int
            if comparisonWeekdayIndex > selectedWeekdayIndex {
                compareResultString = "本周现在已是\(comparisonWeekdayString)，已过了\(selectedWeekdayString)，即下个\(selectedWeekdayString)得到下周"
                shouldAddDayCount = (selectedWeekdayIndex-comparisonWeekdayIndex) + 7
            } else {
                compareResultString = "本周在还是\(comparisonWeekdayString)，还未到\(selectedWeekdayString)，即下个\(selectedWeekdayString)还在本周"
                shouldAddDayCount = (selectedWeekdayIndex-comparisonWeekdayIndex)
            }
            let newDate = calendar.date(byAdding: .day, value: shouldAddDayCount, to: afterDate)
            return newDate
            
        case .month:
            resultComponents = DateComponents()
            resultComponents.day = commemorationComponents.day
            
            cycleTypeString = "每月\(selectedDay)号"
            // 比较“天”是否需要调整月份
            if comparisonDay <= selectedDay {
                compareResultString = "本月现在还是\(comparisonDay)号，还未到\(selectedDay)号，即下个\(selectedDay)号还在本月"
                resultComponents.month = (comparisonComponents.month ?? 1)
            } else {
                // 如果日期已经超过，判断下个月是否还有
                // 计算当前时间afterDate的下个月的月份是否还是与这个月相等，是则代表当前时间是闰月前一月，否则则是闰月那一月
                let stillCurrnetMonth: Bool = afterDate.isNextLunarMonthEqualToCurrentMonth()
                if calendar.identifier == .chinese && stillCurrnetMonth {
                    compareResultString = "本月现在已是\(comparisonDay)号，已过了\(selectedDay)号，但是下个月是本月的闰月，所以下个\(selectedDay)号所在的compontent的month应该保持不变。至于"
                    resultComponents.month = (comparisonComponents.month ?? 1) + 0
                } else {
                    compareResultString = "本月现在已是\(comparisonDay)号，已过了\(selectedDay)号，即下个\(selectedDay)号得到下月"
                    resultComponents.month = (comparisonComponents.month ?? 1) + 1
                }
            }
            resultComponents.year = comparisonComponents.year
            
        case .year:
            // 一定要新起一个值避免被干扰，这里曾经因为使用的是 resultComponents = commemorationComponents 而导致 2024-11-29 后的二月初一找错了
            resultComponents = DateComponents()
            resultComponents.month = commemorationComponents.month
            resultComponents.day = commemorationComponents.day
            // 比较“月”是否需要调整年份
            if let selectedMonth = commemorationComponents.month {
                cycleTypeString = "每年\(selectedMonth)月\(selectedDay)号"
                if comparisonMonth > selectedMonth {
                    // 重要：如果是在农历里面找，并且该纪念月刚好是闰月则应该减去1
                    let stillCurrnetMonth: Bool = afterDate.isNextLunarMonthEqualToCurrentMonth()
                    if calendar.identifier == .chinese && stillCurrnetMonth {
                        compareResultString = "今年现在已是\(comparisonMonth)月，已过了\(selectedMonth)月，但是下个月是本月的闰月，所以下个\(selectedMonth)月\(selectedDay)号还是在今年"
                        resultComponents.year = (comparisonComponents.year ?? 0) + 0
                        
                    } else {
                        compareResultString = "今年现在已是\(comparisonMonth)月，已过了\(selectedMonth)月，所以下个\(selectedMonth)月\(selectedDay)号得到明年"
                        resultComponents.year = (comparisonComponents.year ?? 0) + 1
                    }
                    
                } else if comparisonMonth == selectedMonth {
                    if comparisonDay <= selectedDay {
                        compareResultString = "今年现在还是\(comparisonMonth)月\(comparisonDay)号，还未到\(selectedMonth)月\(selectedDay)号，即下个\(selectedMonth)月\(selectedDay)号还在今年"
                        resultComponents.year = (comparisonComponents.year ?? 0)
                    } else {
                        // 如果日期已经超过，判断下个月是否还有
                        // 计算当前时间afterDate的下个月的月份是否还是与这个月相等，是则代表当前时间是闰月前一月，否则则是闰月那一月
                        let stillCurrnetMonth: Bool = afterDate.isNextLunarMonthEqualToCurrentMonth()
                        if calendar.identifier == .chinese && stillCurrnetMonth {
                            compareResultString = "今年现在已是\(comparisonMonth)月\(comparisonDay)号，已过了\(selectedMonth)月\(selectedDay)号，但是下个月是本月的闰月，所以下个\(selectedMonth)月\(selectedDay)号还是在今年"
                            resultComponents.year = (comparisonComponents.year ?? 0)
                        } else {
                            compareResultString = "今年现在已是\(comparisonMonth)月\(comparisonDay)号，已过了\(selectedMonth)月\(selectedDay)号，所以下个\(selectedMonth)月\(selectedDay)号得到明年"
                            resultComponents.year = (comparisonComponents.year ?? 0) + 1
                        }
                        
    //                    // 如果所纪念的月份在刚好是当前年的闰月前一月(前提为有闰月)，则不等到明年。如果所纪念的月份在刚好是当前年的闰月，则按正常算即要等到明年。
    //                    let lunarLeapMonthTuple = afterDate.getThisYearLunarLeapMonthTuple()
    //                    if lunarLeapMonthTuple != nil && lunarLeapMonthTuple!.lunarLeapMonth == selectedMonth { // 此处两种可能：闰月前一月，或闰月那一月
    //
    //
    //                    } else {
    //                        compareResultString = "今年现在已是\(comparisonMonth)月\(comparisonDay)号，已过了\(selectedMonth)月\(selectedDay)号，并且没有闰月，即下个\(selectedMonth)月\(selectedDay)号得到明年"
    //                        resultComponents.year = (comparisonComponents.year ?? 0) + 1
    //                    }
                    }
                    
                } else {
                    compareResultString = "今年现在还是\(comparisonMonth)月\(comparisonDay)号，还未到\(selectedMonth)月\(selectedDay)号，即下个\(selectedMonth)月\(selectedDay)号还在今年"
                    resultComponents.year = (comparisonComponents.year ?? 0)
                }
            } else {
                compareResultString = "按年计算时候，出错了。。。"
            }
            
        case .none:
            //cj_print("不用处理")
            resultComponents = commemorationComponents
        }
        
        if shouldFlyback { // 当前为1月31号，则点击每月时候，为每月31号，当到2月的时候是否需要回退到月末
            var nextMonthComponents = resultComponents
            nextMonthComponents.day = 1
            if let nextMonthDate = calendar.date(from: nextMonthComponents) {
                let range = calendar.range(of: .day, in: .month, for: nextMonthDate)
                let daysInNextMonth = range?.count ?? 0 // 最后一天是几号
                if selectedDay > daysInNextMonth {
                    //let selectedDateRange = calendar.range(of: .day, in: .month, for: commemorationDate)
                    //let daysInSelectedDate = selectedDateRange?.count ?? 0
                    resultComponents.day = daysInNextMonth // 让其为最后一天
                }
            }
        }

        // 确保下一个周期的日期存在，处理农历月份天数不一致的问题
        if var nextDate = calendar.date(from: resultComponents) {
//            let calendarTypeString: String = calendar.identifier == .chinese ? "农历" : "公历"
            let calendarTypeString: String = "农历"
            cj_print("\(calendarTypeString)\(cycleTypeString)：<\(compareResultString)>的日期存在：\(nextDate.lunarDateString())【\(CJDateFormatterUtil.formatGregorianDate(from: nextDate))】")
            // 判断所得的日期是否在指定日期后，避免查找每年六月初一的时候，当前是2025-07-25农历六月初一，得到的结果是2025-06-25也是农历六月初一，
            // 请确保创建生成的之前的 afterDate 以及 用来生成nextDate的self时间是格林时间。不然下面比较可能导致 nextDate < afterDate
            
            let nextDateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: afterDate)
            let result: ComparisonResult = nextDate.compareDatesByYearMonthDay(afterDate) // nextDate < afterDate 只比较年月日，避免其他因素影响
            if result == .orderedAscending && calendar.identifier == .chinese {
            //if nextDate < afterDate && calendar.identifier == .chinese {
                nextDate = self.findNextEqualLunarDateFromDate(nextDate, isMonthMustEqual: commemorationCycleType == .year ? true : false) ?? nextDate
            }
            return nextDate
        } else {
            // 如果当前农历日不存在于下一个周期，则向后调整到有效日期
            cj_print("当前农历日 \(comparisonDay) 在目标月份无效，开始调整...")
            var adjustedComponents = comparisonComponents
            while adjustedComponents.day ?? 1 > 1 {
                adjustedComponents.day! -= 1
                if let validDate = calendar.date(from: adjustedComponents) {
                    cj_print("\(cycleTypeString)：<\(compareResultString)>但调整后的有效日期为：\(validDate.lunarDateString()))【\(CJDateFormatterUtil.formatGregorianDate(from: validDate))】")
                    return validDate
                }
            }
            cj_print("未找到有效日期")
            return nil
        }
    }
    
    /// 将本纪念日时间根据纪念周期输出指定的格式（公历/农历）
    /// - Parameters:
    ///   - commemorationCycleType: 周期类型（按周 or 按月 or 按年）
    ///   - showInLunarType: 输出格式是农历，还是公历
    /// - Returns: 本纪念日时间根据纪念周期及指定的格式（公历/农历）输出的字符串
    public func commemorationDateString(cycleType: CJCommemorationCycleType, showInLunarType: Bool) -> String {
        var dateString: String = ""
        switch cycleType {
        case .week:
            let weekDayString = self.weekdayString()
            dateString = "每周 \(weekDayString)"
            
        case .month:
            if showInLunarType {
                let lunarTuple = self.lunarTuple()
                dateString = "农历每月\(lunarTuple.dayString)"
            } else {
                let selectedComponents = Calendar.current.dateComponents([.year, .month ,.day], from: self)
                dateString = "每月\(selectedComponents.day ?? 1)日"
            }
        case .year:
            if showInLunarType {
                let lunarTuple = self.lunarTuple()
                dateString = "农历每年 \(lunarTuple.monthString)月\(lunarTuple.dayString)"
            } else {
                let selectedComponents = Calendar.current.dateComponents([.year, .month ,.day], from: self)
                dateString = "每年 \(selectedComponents.month ?? 1)月\(selectedComponents.day ?? 1)日"
            }
        case .none:
            if showInLunarType {
                let lunarTuple = self.lunarTuple()
                dateString = "\(lunarTuple.lunarYear)\(lunarTuple.stemBranch)年\(lunarTuple.monthString)月\(lunarTuple.dayString)"
            } else {
                let selectedComponents = Calendar.current.dateComponents([.year, .month ,.day], from: self)
                dateString = "\(selectedComponents.year ?? 1)年\(selectedComponents.month ?? 1)月\(selectedComponents.day ?? 1)日"
            }
        }
        return dateString
    }
    
    public func weekdayString(type: Int = 0) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        let weekday = components.weekday ?? 1
        var weekdayStrings = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        if type == 1 {
            weekdayStrings = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        }
        return weekdayStrings[weekday - 1]
    }
    
    /// 比较两个日期的大小，要求只考虑年月日，不考虑时分秒
    public func compareDatesByYearMonthDay(_ date: Date) -> ComparisonResult {
        let calendar = Calendar.current
        
        // 获取去掉时分秒的日期（归一化到当天的开始时间）
        let normalizedDate1 = calendar.startOfDay(for: self)
        let normalizedDate2 = calendar.startOfDay(for: date)
        
        // 比较两个日期
        return normalizedDate1.compare(normalizedDate2)
    }
}


//MARK: 从公历日期中获取农历日期（含天干地支）的各种数据
public extension Date {
    // 将日期格式化为农历日期（含天干地支）
    public func lunarDateString() -> String {
        let lunarTuple = self.lunarTuple()
        let adjustedLunarYear: Int = lunarTuple.lunarYear
        let lunarYearWithStemBranch: String = lunarTuple.stemBranch
        let lunarMonthName: String = lunarTuple.monthString
        let lunarDayName: String = lunarTuple.dayString
        let lunarDateString = "\(adjustedLunarYear)\(lunarYearWithStemBranch)年\(lunarMonthName)月\(lunarDayName)"
        return lunarDateString
    }
    
    /*
    // 从公历日期中获取农历日期（含天干地支）的各种数据(TODO: 1984年之前的计算会有问题，其他正确)
    func lunarTuple_after1984() -> (lunarYear: Int, stemBranch: String, monthString: String, dayString: String) {
        // 使用农历日历（中国农历）
        let lunarCalendar = Calendar(identifier: .chinese)
        
        // 获取公历日期的农历年、月、日
        let components = lunarCalendar.dateComponents([.year, .month, .day], from: self)
        
        // 获取年份、月份和日期
        let lunarYear = components.year ?? 0
        let lunarMonth = components.month ?? 0
        let lunarDay = components.day ?? 0
        
        // 如果年份为40或41等小年份，可以推测它是基于农历纪年起始年份的偏差
        // 这里可以做一个简单的年份修正，如果是从41年开始的纪年
        let adjustedLunarYear = lunarYear + 1983  // 因为41年对应的是1984年农历纪年
//        let gregorianDate = self  // 获取当前公历日期
//        let adjustedLunarYear = Calendar(identifier: .chinese).dateComponents([.year], from: gregorianDate).year ?? lunarYear
        
        // 根据甲子年的纪年法计算天干地支
        let baseYear = 1984 // 甲子年对应的公历年份(上一个甲子年是1984年，下一个甲子年是60年后的2044年)
        let heavenlyStems = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
        let earthlyBranches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
        let yearDifference = adjustedLunarYear - baseYear
        // 计算天干地支的循环周期及获取天干和地支
        let stemIndex = yearDifference % 10  // 天干的循环周期（10年一轮）
        let branchIndex = yearDifference % 12  // 地支的循环周期（12年一轮）
        let stem = heavenlyStems[stemIndex]
        let branch = earthlyBranches[branchIndex]
        let lunarYearWithStemBranch = "\(stem)\(branch)"  // 农历天干地支年份，例如 "乙巳"
        
        // 农历的天数和月份的中文表示
        let monthDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        let months = ["正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "冬", "腊"]
        
        // 重要：如果是在农历里面找，并且该纪念月刚好是闰月则应该加上"闰"字
        var lunarMonthName = months[lunarMonth - 1]
        let isLeapMonth = self.isLunarLeapMonth()
        if isLeapMonth {
            lunarMonthName = "闰" + lunarMonthName
        }
        
        // 获取天数的中文表示
        let lunarDayName = monthDays[lunarDay - 1]
        
//        let normalDateString = formatGregorianDate(from: date)
//        // 返回格式化后的农历日期
//        let lunarDateString = "\(adjustedLunarYear)\(lunarYearWithStemBranch)年\(lunarMonthName)月\(lunarDayName)"
//        cj_print("\(normalDateString)【\(lunarDateString)】")
        
        return (adjustedLunarYear, lunarYearWithStemBranch, lunarMonthName, lunarDayName)
    }
    */
    
    // 从公历日期中获取农历日期（含天干地支）的各种数据(已处理闰月情况)
    public func lunarTuple() -> (lunarYear: Int, stemBranch: String, monthString: String, dayString: String) {
        let dateStyle: DateFormatter.Style = .long
        
        let chineseFormatter = DateFormatter()
        chineseFormatter.locale = Locale(identifier: "zh_CN")
        chineseFormatter.dateStyle = dateStyle
        chineseFormatter.calendar = Calendar(identifier: .chinese)
        
        let lunarDateFullString = chineseFormatter.string(from: self)
        
        // 检查字符串长度
        guard lunarDateFullString.count >= 9 else {
            //cj_print("输入的农历日期格式不正确")
            return (0, "", "", "")
        }

        // 截取年份（1-4位）
        let adjustedLunarYearString = String(lunarDateFullString.prefix(4))
        let adjustedLunarYear = Int(adjustedLunarYearString) ?? 0
        
        // 截取天干地支（5-6位）
        let lunarYearWithStemBranch = String(lunarDateFullString.dropFirst(4).prefix(2))
        
        // 截取月份（8位）
        let monthLength = lunarDateFullString.contains("闰") ? 2 : 1
        let lunarMonthName = String(lunarDateFullString.dropFirst(7).prefix(monthLength))
        
        // 截取日期（9位之后的部分）
        let dayCropIndex = 7 + monthLength + 1
        let lunarDayName = String(lunarDateFullString.dropFirst(dayCropIndex))
        
        return (adjustedLunarYear, lunarYearWithStemBranch, lunarMonthName, lunarDayName)
    }
}

// MARK: 提供给 OC 使用的方法
public struct CJRepateDateGetter {
    /// 已知纪念日时间，按指定纪念周期，获取指定日期后的最临近的纪念日
    /// eg：已知纪念日时间，按每年重复，获取当前时间之后最临近的纪念日
    /// - Parameters:
    ///   - commemorationDate: 纪念日
    ///   - commemorationCycleType: 周期类型（按周 or 按月 or 按年）
    ///   - afterDate: 在指定日期后
    ///   - shouldFlyback: 当前为1月31号，则点击每月时候，为每月31号，当到2月的时候是否需要回退到月末
    ///   - calendar: 使用的农历 `Calendar`
    /// - Returns: 指定日期后的最临近的纪念日
    static func closestCommemorationDate(commemorationDate: Date, commemorationCycleType: CJCommemorationCycleType, afterDate: Date, shouldFlyback: Bool, calendar: Calendar = Calendar(identifier: .chinese)) -> Date? {
        return commemorationDate.closestCommemorationDate(commemorationCycleType: commemorationCycleType, afterDate: afterDate, shouldFlyback: shouldFlyback, calendar: calendar)
    }
        
    
    static public func getWeekdayString(from date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        let weekday = components.weekday ?? 1
        let weekdayStrings = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return weekdayStrings[weekday - 1]
    }
}

struct CJDateIntervalUtil {
    /// 获取指定日期所在月份的所有天数
    /// - Parameter date: 输入的日期
    /// - Returns: 包含所有天数的数组
    static public func getDaysInMonth(for date: Date) -> [Date] {
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

// MARK: 格式化+天数差
public extension Date {
    func daysBetween(endDate: Date) -> Int {
        let startFormatedString = self.format("yyyy-MM-dd")
        let startYMDDate: Date = Date.dateFromString(startFormatedString, format: "yyyy-MM-dd") ?? self
        
        let endFormatedString = endDate.format("yyyy-MM-dd")
        let endYMDDate: Date = Date.dateFromString(endFormatedString, format: "yyyy-MM-dd") ?? endDate
        
        let days = endYMDDate.days(endDate: startYMDDate)
        //cj_print("😊😃还有\(days)天：从\(startYMDDate)到\(endFormatedString)")
        return days
    }
    
    /// 格式转换
    public func format(_ str: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormat = DateFormatter()
        // 解决带上下午问题
        dateFormat.calendar = .init(identifier: .gregorian)
//        dateFormat.locale = Locale(identifier: localIdentifier.rawValue)
        
        dateFormat.dateFormat = str
        dateFormat.timeZone = .current
        let dateStr = dateFormat.string(from: self)
        return dateStr
        
    }
    
    static public func dateFromString(_ dateString: String?, format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        guard let dateString = dateString, !dateString.isEmpty else {
            return nil
        }
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = .current
        let date: Date? = dateFormatter.date(from: dateString)
        return date
    }
    
    /// 计算两个日期之间的天数
    /// - Parameter endDate: 结束日期
    /// - Returns: 总天数
    public func days(endDate: Date, containsUpRange: Bool = true, useLunarDate: Bool = false) -> Int {
        guard !Date.isSameDay(date1: self, date2: endDate) else {
            return 0
        }
        let components = Calendar(identifier: .chinese).dateComponents([.day], from: self, to: endDate)
        guard (components.day ?? 0) >= 0 else {
            return components.day ?? 0
        }
        let days = (components.day ?? 0)
        //cj_print("😭😃还有\(days)天：从\(self.format())到\(endDate.format())")
        return days
    }
    static public func isSameDay(date1: Date, date2: Date) -> Bool {
        
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}


public struct CJDateFormatterUtil {
    // 静态方法：将公历日期格式化为农历日期（含天干地支）
    static public func lunarStringForDate(from date: Date, using calendar: Calendar = Calendar(identifier: .chinese)) -> String {
        return date.lunarDateString()
    }
    
    // 从公历日期中获取农历日期（含天干地支）的各种数据
    static public func lunarTupleForDate(from date: Date) -> (lunarYear: Int, stemBranch: String, monthString: String, dayString: String) {
        return date.lunarTuple()
    }

    
    /// 格式化公历日期
    static public func formatGregorianDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

public struct CJDateCompareUtil {
    //比较两个日期是否相等，只考虑年、月、日
    static public func areDatesEqualIgnoringTime(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
//        let componentsToCompare: Set<Calendar.Component> = [.year, .month, .day]
        
        return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
    }
}


public func cj_print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//    print(items, separator: separator, terminator: terminator)
}
