//
//  TSDateHomeViewController.swift
//  TSDemo_DataVientiane-Swift
//
//  Converted from Objective-C on 2026/7/16.
//

import UIKit
import CQDemoKit
import TSDemo_DataVientiane

class TSDateHomeViewController: CJUIKitBaseHomeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "NSDate 验证测试"

        var sectionDataModels: [CQDMSectionDataModel] = []

        // MARK: - 计算下一个周期
        do {
            let section = CQDMSectionDataModel()
            section.theme = "Date"

            do {
                let m = CQDMModuleModel()
                m.title = "Date"
                m.classEntry = DateViewController.self
                section.values.add(m)
            }

            sectionDataModels.append(section)
        }
        
        // MARK: - NSDate 验证测试分类
        do {
            let section = CQDMSectionDataModel()
            section.theme = "NSDate 验证测试分类(旧版：在Home里操作)"

            do {
                let m = CQDMModuleModel()
                m.title = "Date"
                m.classEntry = FoundationHomeViewController.self
                section.values.add(m)
            }

            sectionDataModels.append(section)
        }
        
        // MARK: - NSDate 验证测试分类
        do {
            let section = CQDMSectionDataModel()
            section.theme = "NSDate 验证测试分类(新版：使用DealTextModel操作)"

            do {
                let m = CQDMModuleModel()
                m.title = "获取指定时间所在年份的月数和天数"
                m.classEntry = TSDateCalendarDaysViewController.self
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "农历格式显示"
                m.classEntry = TSDateLunarStringViewController.self
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "农历闰月信息"
                m.classEntry = TSDateLeapMonthViewController.self
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "下个月是否是本月的闰月"
                m.classEntry = TSDateNextLeapMonthViewController.self
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "找下一个相等的农历日期"
                m.classEntry = TSDateFindEqualLunarDateViewController.self
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "24小时制/12小时制时间还原"
                m.classEntry = TSDate24HourConvertViewController.self
                section.values.add(m)
            }

            sectionDataModels.append(section)
        }

        // MARK: - 计算下一个周期
        do {
            let section = CQDMSectionDataModel()
            section.theme = "计算下一个周期"

            do {
                let m = CQDMModuleModel()
                m.title = "按周计算下一个周期"
                m.classEntry = TSDateWeeklyRepeatViewController.self
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "按月计算下一个周期"
                m.classEntry = TSDateMonthlyRepeatViewController.self
                section.values.add(m)
            }
            do {
                let m = CQDMModuleModel()
                m.title = "按年计算下一个周期"
                m.classEntry = TSDateYearlyRepeatViewController.self
                section.values.add(m)
            }

            sectionDataModels.append(section)
        }

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
