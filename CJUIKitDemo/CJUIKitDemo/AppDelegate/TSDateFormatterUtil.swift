//
//  TSDateFormatterUtil.swift
//  CJUIKitDemo
//
//  Created by qian on 2024/12/4.
//  Copyright © 2024 dvlproad. All rights reserved.
//

import Foundation
import CQDemoKit

class TSDateFormatterUtil: NSObject {
    @objc static var needRecoverDate: Date = Date() // 这里要用Date，不要用string，不然比较恢复正确与否没用
    @objc static var needRecoveryyyyMMddHHmmssString: String = "2023-05-10 00:00:00"
    @objc static func createTestDate() -> Date  {
        let tenThousandHoursComponents = DateComponents(
            year: 2023,
            month: 5,
            day: 10
        )
        let date: Date = Calendar.current.date(from: tenThousandHoursComponents) ?? Date()
//        print("2023年5月10号 \(date.description(with: Locale.current)).")
//        print("UTC时间: \(date.description).")
        return date
    }
    
    /// 请将24小时制的时间字符串 2023-05-10 00:00:00 在手机设备为12小时制的情况下恢复为正确的Date
    @objc static func testRecover24DateIn12()  {
        if let date = Date.fromTimeString("2023-05-10 00:00:00") {
            print("✅\(Date.is12HourSystem() ? "12小时制": "24小时制")正确还原24小时制的Date对象: \(date)")
        } else {
            print("❌解析失败")
        }
    }
    
    @objc static func testRecover12DateIn24()  {
        if let date = Date.fromTimeString("2023-05-10 12:00:00 AM") {
            print("✅\(Date.is12HourSystem() ? "12小时制": "24小时制")正确还原12小时制的Date对象: \(date)")
        } else {
            print("❌解析失败")
        }
        
        if let date = Date.fromTimeString("2015-01-01 上午12:00:00") {
            print("✅\(Date.is12HourSystem() ? "12小时制": "24小时制")正确还原12小时制的Date对象: \(date)")
        } else {
            print("❌解析失败")
        }
    }
    
    @objc static func testyyyyMMddHHmmssString_from_date(_ date: Date) -> String {
        let dateString: String = date.toTimeString()
        CJUIKitToastUtil.showMessage("需要恢复的日期字符串为：\(dateString)")
        
        TSDateFormatterUtil.needRecoverDate = date
        TSDateFormatterUtil.needRecoveryyyyMMddHHmmssString = dateString
        return dateString
    }
    
    @objc static func test_Date_from_yyyyMMddHHmmssString() -> String {
        let dateString = TSDateFormatterUtil.needRecoveryyyyMMddHHmmssString
        let recoverDate: Date? = Date.fromTimeString(dateString)
        guard recoverDate != nil else {
            CJUIKitToastUtil.showMessage("❌字符串转Date失败：\(dateString)")
            return "字符串转Date失败"
        }
        
        let originDateString = TSDateFormatterUtil.needRecoverDate.toTimeString() // 这里要用原来的时间转，而不是用原来时间转成的字符串
        let recoverDateString = recoverDate!.toTimeString()
        if originDateString == recoverDateString {
            CJUIKitToastUtil.showMessage("✅恢复成功:\(dateString)")
        } else {
            CJUIKitToastUtil.showMessage("❌恢复失败:\(dateString)")
        }
        return recoverDateString
    }
}
