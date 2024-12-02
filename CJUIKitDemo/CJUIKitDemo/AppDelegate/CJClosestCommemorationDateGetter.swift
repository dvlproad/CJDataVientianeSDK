//
//  CJClosestCommemorationDateGetter.swift
//  CJUIKitDemo
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
enum CommemorationCycleType {
    case none   // 不重复
    case week   // 每周重复
    case month  // 每月重复
    case year   // 每年重复
}

extension Date {
    /// 以本时间为纪念日，按指定纪念周期，获取指定日期后的最临近的纪念日
    /// eg：以本时间为纪念日，按每年重复，获取当前时间之后最临近的纪念日
    /// - Parameters:
    ///   - commemorationCycleType: 周期类型（按周 or 按月 or 按年）
    ///   - afterDate: 在指定日期后
    ///   - shouldFlyback: 当前为1月31号，则点击每月时候，为每月31号，当到2月的时候是否需要回退到月末
    ///   - calendar: 使用的农历 `Calendar`
    /// - Returns: 指定日期后的最临近的纪念日
    func closestCommemorationDate(commemorationCycleType: CommemorationCycleType, afterDate: Date, shouldFlyback: Bool, calendar: Calendar = Calendar(identifier: .chinese)) -> Date? {
        let commemorationDate: Date = self
        print("\n要纪念的日期：\(commemorationDate.lunarDateString())【\(CJDateFormatterUtil.formatGregorianDate(from: commemorationDate))】【\(CJRepateDateGetter.getWeekdayString(from: commemorationDate))】")
        print("比较当前日期：\(afterDate.lunarDateString()))【\(CJDateFormatterUtil.formatGregorianDate(from: afterDate))】【\(CJRepateDateGetter.getWeekdayString(from: afterDate))】")
        
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
            if comparisonWeekdayIndex > selectedWeekdayIndex {
                compareResultString = "本周现在已是\(comparisonWeekdayString)，已过了\(selectedWeekdayString)，即下个\(selectedWeekdayString)得到下周"
                resultComponents.day = (comparisonComponents.day ?? 1) + (selectedWeekdayIndex-comparisonWeekdayIndex) + 7
            } else {
                compareResultString = "本周在还是\(comparisonWeekdayString)，还未到\(selectedWeekdayString)，即下个\(selectedWeekdayString)还在本周"
                resultComponents.day = (comparisonComponents.day ?? 1) + (selectedWeekdayIndex-comparisonWeekdayIndex)
            }
            resultComponents.month = comparisonComponents.month
            resultComponents.year = comparisonComponents.year
            
        case .month:
            cycleTypeString = "每月\(selectedDay)号"
            // 比较“天”是否需要调整月份
            if comparisonDay > selectedDay {
                compareResultString = "本月现在已是\(comparisonDay)号，已过了\(selectedDay)号，即下个\(selectedDay)号得到下月"
                resultComponents.month = (comparisonComponents.month ?? 1) + 1
            } else {
                compareResultString = "本月现在还是\(comparisonDay)号，还未到\(selectedDay)号，即下个\(selectedDay)号还在本月"
                resultComponents.month = (comparisonComponents.month ?? 1)
            }
            
        case .year:
            // 比较“月”是否需要调整年份
            if let selectedMonth = commemorationComponents.month {
                cycleTypeString = "每年\(selectedMonth)月\(selectedDay)号"
                if comparisonMonth > selectedMonth || (comparisonMonth == selectedMonth && comparisonDay > selectedDay ) {
                    compareResultString = "今年现在已是\(comparisonMonth)月\(comparisonDay)号，已过了\(selectedMonth)月\(selectedDay)号，即下个\(selectedMonth)月\(selectedDay)号得到明年"
                    resultComponents.year = (comparisonComponents.year ?? 0) + 1
                } else {
                    compareResultString = "今年现在还是\(comparisonMonth)月\(comparisonDay)号，还未到\(selectedMonth)月\(selectedDay)号，即下个\(selectedMonth)月\(selectedDay)号还在今年"
                    resultComponents.year = (comparisonComponents.year ?? 0)
                }
            } else {
                compareResultString = "按年计算时候，出错了。。。"
            }
            
        case .none:
            print("不用处理")
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
        
        // 重要：如果是在农历里面找，并且该纪念月刚好是闰月则应该减去1
        if calendar.identifier == .chinese && self.isLunarLeapMonth() {
            resultComponents.month = (resultComponents.month ?? 1) - 1
        }

        // 确保下一个周期的日期存在，处理农历月份天数不一致的问题
        if var nextDate = calendar.date(from: resultComponents) {
//            let calendarTypeString: String = calendar.identifier == .chinese ? "农历" : "公历"
            let calendarTypeString: String = "农历"
            print("\(calendarTypeString)\(cycleTypeString)：<\(compareResultString)>的日期存在：\(nextDate.lunarDateString())【\(CJDateFormatterUtil.formatGregorianDate(from: nextDate))】")
            // 判断所得的日期是否在指定日期后，避免查找每年六月初一的时候，当前是2025-07-25农历六月初一，得到的结果是2025-06-25也是农历六月初一，
            if nextDate < afterDate {
                for iAdd in 1..<40 {
                    let tempDate = nextDate.addingTimeInterval(TimeInterval(iAdd * 24 * 60 * 60)) // 加1小时
                    
                    let tempComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: tempDate)
                    if tempComponents.month == commemorationComponents.month && tempComponents.day == commemorationComponents.day {
                        nextDate = tempDate
                        break
                    }
                }
            }
            return nextDate
        } else {
            // 如果当前农历日不存在于下一个周期，则向后调整到有效日期
            print("当前农历日 \(comparisonDay) 在目标月份无效，开始调整...")
            var adjustedComponents = comparisonComponents
            while adjustedComponents.day ?? 1 > 1 {
                adjustedComponents.day! -= 1
                if let validDate = calendar.date(from: adjustedComponents) {
                    print("\(cycleTypeString)：<\(compareResultString)>但调整后的有效日期为：\(validDate.lunarDateString()))【\(CJDateFormatterUtil.formatGregorianDate(from: validDate))】")
                    return validDate
                }
            }
            print("未找到有效日期")
            return nil
        }
    }
    
    /// 将本纪念日时间根据纪念周期输出指定的格式（公历/农历）
    /// - Parameters:
    ///   - commemorationCycleType: 周期类型（按周 or 按月 or 按年）
    ///   - showInLunarType: 输出格式是农历，还是公历
    /// - Returns: 本纪念日时间根据纪念周期及指定的格式（公历/农历）输出的字符串
    func commemorationDateString(cycleType: CommemorationCycleType, showInLunarType: Bool) -> String {
        var dateString: String = ""
        switch cycleType {
        case .week:
            let weekDayString = self.weekdayString()
            dateString = "每周 \(weekDayString)"
            
        case .month:
            if showInLunarType {
                let lunarTuple = self.lunarTuple()
                dateString = "农历每月 \(lunarTuple.dayString)"
            } else {
                let selectedComponents = Calendar.current.dateComponents([.year, .month ,.day], from: self)
                dateString = "每月 \(selectedComponents.day ?? 1)日"
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
                dateString = "\(selectedComponents.year ?? 1)年 \(selectedComponents.month ?? 1)月\(selectedComponents.day ?? 1)日"
            }
        }
        return dateString
    }
    
    func weekdayString() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        let weekday = components.weekday ?? 1
        let weekdayStrings = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return weekdayStrings[weekday - 1]
    }
}


//MARK: 从公历日期中获取农历日期（含天干地支）的各种数据
extension Date {
    // 将日期格式化为农历日期（含天干地支）
    func lunarDateString() -> String {
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
//        print("\(normalDateString)【\(lunarDateString)】")
        
        return (adjustedLunarYear, lunarYearWithStemBranch, lunarMonthName, lunarDayName)
    }
    */
    
    // 从公历日期中获取农历日期（含天干地支）的各种数据(已处理闰月情况)
    func lunarTuple() -> (lunarYear: Int, stemBranch: String, monthString: String, dayString: String) {
        let dateStyle: DateFormatter.Style = .long
        
        let chineseFormatter = DateFormatter()
        chineseFormatter.locale = Locale(identifier: "zh_CN")
        chineseFormatter.dateStyle = dateStyle
        chineseFormatter.calendar = Calendar(identifier: .chinese)
        
        let lunarDateFullString = chineseFormatter.string(from: self)
        
        // 检查字符串长度
        guard lunarDateFullString.count >= 9 else {
            //print("输入的农历日期格式不正确")
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

// MARK: 闰年、闰月判断
extension Date {
    /// 判断公历年份是否是闰年
    func isGregorianLeapYear(year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }

    /// 手动判断农历年份是否包含闰月
    func isLunarYearLeap(year: Int) -> Bool {
        let chineseCalendar = Calendar(identifier: .chinese)
        if let startOfYear = chineseCalendar.date(from: DateComponents(year: year - 1, month: 11, day: 1)),
           let startOfNextYear = chineseCalendar.date(from: DateComponents(year: year, month: 11, day: 1)) {
            let months = chineseCalendar.dateComponents([.month], from: startOfYear, to: startOfNextYear).month ?? 0
            return months > 12 // 农历年有 13 个月
        }
        return false
    }

    /// 判断农历月份是否为闰月（兼容 iOS 17 以下）
    func isLunarLeapMonth() -> Bool {
        guard #available(iOS 17, *) else {
            return _isLunarLeapMonthManual(for: self)
        }
        
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.isLeapMonth], from: self)
        return components.isLeapMonth ?? false
        
    }
    
    /// 判断该月是否为农历的闰月（iOS 17 以下的手动实现）
    private func _isLunarLeapMonthManual(for date: Date) -> Bool {
        guard #available(iOS 17, *) else {
            return false
        }
        
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.month, .isLeapMonth], from: date)
        
        if let isLeapMonth = components.isLeapMonth {
            return isLeapMonth
        }
        
        // 手动判断农历闰月，检查是否是超过 12 的月份
        let gregorianCalendar = Calendar(identifier: .gregorian)
        let year = gregorianCalendar.component(.year, from: date)
        
        if isLunarYearLeap(year: year) {
            return components.month ?? 0 > 12 // 闰月通常是 13 月以上的月份
        }
        return false
    }
}


// MARK: 提供给 OC 使用的方法
struct CJRepateDateGetter {
    /// 已知纪念日时间，按指定纪念周期，获取指定日期后的最临近的纪念日
    /// eg：已知纪念日时间，按每年重复，获取当前时间之后最临近的纪念日
    /// - Parameters:
    ///   - commemorationDate: 纪念日
    ///   - commemorationCycleType: 周期类型（按周 or 按月 or 按年）
    ///   - afterDate: 在指定日期后
    ///   - shouldFlyback: 当前为1月31号，则点击每月时候，为每月31号，当到2月的时候是否需要回退到月末
    ///   - calendar: 使用的农历 `Calendar`
    /// - Returns: 指定日期后的最临近的纪念日
    static func closestCommemorationDate(commemorationDate: Date, commemorationCycleType: CommemorationCycleType, afterDate: Date, shouldFlyback: Bool, calendar: Calendar = Calendar(identifier: .chinese)) -> Date? {
        return commemorationDate.closestCommemorationDate(commemorationCycleType: commemorationCycleType, afterDate: afterDate, shouldFlyback: shouldFlyback, calendar: calendar)
    }
        
    
    static func getWeekdayString(from date: Date) -> String {
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

// MARK: 格式化+天数差
extension Date {
    func daysBetween(endDate: Date) -> Int {
        let startFormatedString = self.format("yyyy-MM-dd")
        let startYMDDate: Date = Date.dateFromString(startFormatedString, format: "yyyy-MM-dd") ?? self
        
        let endFormatedString = endDate.format("yyyy-MM-dd")
        let endYMDDate: Date = Date.dateFromString(endFormatedString, format: "yyyy-MM-dd") ?? endDate
        
        let days = endYMDDate.days(endDate: startYMDDate)
        //print("😊😃还有\(days)天：从\(startYMDDate)到\(endFormatedString)")
        return days
    }
    
    /// 格式转换
    func format(_ str: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormat = DateFormatter()
        // 解决带上下午问题
        dateFormat.calendar = .init(identifier: .gregorian)
//        dateFormat.locale = Locale(identifier: localIdentifier.rawValue)
        
        dateFormat.dateFormat = str
        dateFormat.timeZone = .current
        let dateStr = dateFormat.string(from: self)
        return dateStr
        
    }
    
    static func dateFromString(_ dateString: String?, format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
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
    func days(endDate: Date, containsUpRange: Bool = true, useLunarDate: Bool = false) -> Int {
        guard !Date.isSameDay(date1: self, date2: endDate) else {
            return 0
        }
        let components = Calendar(identifier: .chinese).dateComponents([.day], from: self, to: endDate)
        guard (components.day ?? 0) >= 0 else {
            return components.day ?? 0
        }
        let days = (components.day ?? 0)
        //print("😭😃还有\(days)天：从\(self.format())到\(endDate.format())")
        return days
    }
    static func isSameDay(date1: Date, date2: Date) -> Bool {
        
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}


struct CJDateFormatterUtil {
    // 静态方法：将公历日期格式化为农历日期（含天干地支）
    static func lunarStringForDate(from date: Date, using calendar: Calendar = Calendar(identifier: .chinese)) -> String {
        return date.lunarDateString()
    }
    
    // 从公历日期中获取农历日期（含天干地支）的各种数据
    static func lunarTupleForDate(from date: Date) -> (lunarYear: Int, stemBranch: String, monthString: String, dayString: String) {
        return date.lunarTuple()
    }

    
    /// 格式化公历日期
    static func formatGregorianDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
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


