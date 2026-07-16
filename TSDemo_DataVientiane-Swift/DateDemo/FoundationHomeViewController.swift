//
//  FoundationHomeViewController.swift
//  TSDemo_DataVientiane-Swift
//
//  Converted from Objective-C on 2026/7/16.
//

import UIKit
import CQDemoKit

class FoundationHomeViewController: CJUIKitBaseHomeViewController {

    private var recoveDateModule: CQDMModuleModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("Home首页", comment: "")

        var sectionDataModels: [CQDMSectionDataModel] = []

        // MARK: - NSDate相关
        do {
            let section = CQDMSectionDataModel()
            section.theme = "NSDate相关"

            do {
                let m = CQDMModuleModel()
                m.title = "NSDate指定日期的日期数据"
                m.content = "获取指定时间所在的 公历年份 和 农历年份 中有多少个月，以及当前月有多少天"
                m.contentLines = 2
                m.actionBlock = {
                    TestSwift1.getCalendarMonthsAndDays()
                }
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate日期与字符串转换"
                m.content = "24小时制下标准保存，24制/12制下恢复"
                m.actionBlock = {
                    TSDateFormatterUtil.testRecover24DateIn12()
                }
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate日期与字符串转换"
                m.content = "12小时制下标准保存，12制/24制下恢复"
                m.actionBlock = {
                    TSDateFormatterUtil.testRecover12DateIn24()
                }
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate日期与字符串转换：保存"
                m.content = "24小时制下保存，12制下恢复"
                m.actionBlock = { [weak self] in
                    let testDate = TSDateFormatterUtil.createTestDate()
                    let needRecoverString = TSDateFormatterUtil.testyyyyMMddHHmmssString_from_date(testDate)
                    self?.recoveDateModule.content = "24小时制下保存，12制下恢复\n待恢复：\(needRecoverString ?? "")"
                    self?.tableView.reloadData()
                }
                section.values.add(m)
                self.recoveDateModule = m
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate日期与字符串转换：恢复"
                m.content = "24小时制下保存，12制下恢复"
                m.contentLines = 3
                m.actionBlock = { [weak self] in
                    guard let self = self else { return }
                    let recoverDateString = TSDateFormatterUtil.test_Date_from_yyyyMMddHHmmssString()
                    var currentContentString = self.recoveDateModule.content ?? ""
                    let components = currentContentString.components(separatedBy: "\n")
                    if components.count > 2 {
                        currentContentString = Array(components.prefix(2)).joined(separator: "\n")
                    }
                    self.recoveDateModule.content = "\(currentContentString)\n恢复成：\(recoverDateString ?? "")"
                    self.tableView.reloadData()
                }
                section.values.add(m)
                self.recoveDateModule = m
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate农历格式"
                m.actionBlock = {
                    TestSwift1.printLunarDateString()
                }
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate是否有闰月"
                m.actionBlock = {
                    TestSwift1.getLeapMonth()
                }
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate农历：下个月的月份是否和本月相等，即下个月是否是闰月"
                m.actionBlock = {
                    TestSwift1.isNextLunarMonthEqual()
                }
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate农历：找下一个月与之相等的农历日期"
                m.actionBlock = {
                    TestSwift1.findNextEqualLunarDate()
                }
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate每周重复"
                m.actionBlock = {
                    TestSwift1.getNextRepateDate_week()
                }
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate每月重复"
                m.actionBlock = {
                    TestSwift1.getNextRepateDate_month()
                }
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "NSDate每年周期"
                m.actionBlock = {
                    TestSwift1.getNextRepateDate_year()
                }
                section.values.add(m)
            }

            sectionDataModels.append(section)
        }

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
