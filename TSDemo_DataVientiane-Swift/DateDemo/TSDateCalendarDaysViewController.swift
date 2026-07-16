import UIKit
import CQDemoKit

@objc class TSDateCalendarDaysViewController: CJUIKitBaseBigTextViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "获取指定时间所在年份的月数和天数"

        var sectionDataModels: [CQDMSectionDataModel] = []

        // 农历
        let lunarSection = CQDMSectionDataModel()
        lunarSection.theme = "农历"

        let lunarData: [(text: String, months: Int, days: Int)] = [
            ("2017-07-22", 13, 29),
            ("2017-08-20", 13, 30),
            ("2025-07-24", 13, 30),
            ("2025-08-22", 13, 29),
            ("2025-01-28", 12, 29),
            ("2024-02-08", 13, 30),
            ("2023-01-20", 13, 30),
        ]

        for data in lunarData {
            let model = CJDealTextModel()
            model.text = data.text
            model.actionTitle = "农历月天数"
            model.hopeResultText = "\(data.months)个月\(data.days)天"
            model.autoExec = true
            model.actionBlock = { oldString in
                let date = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                let monthAndDayTuple = date.currentMonthDayCountTuple(inLunarCalendar: true)
                if monthAndDayTuple == nil {
                    return "获取失败"
                }
                return "\(monthAndDayTuple!.monthCount)个月\(monthAndDayTuple!.dayCount)天"
            }
            lunarSection.values.add(model)
        }

        sectionDataModels.append(lunarSection)

        // 公历
        let solarSection = CQDMSectionDataModel()
        solarSection.theme = "公历"

        let solarData: [(text: String, months: Int, days: Int)] = [
            ("2020-01-20", 12, 31),
            ("2020-02-01", 12, 29),
            ("2021-02-01", 12, 28),
            ("2021-04-01", 12, 30),
        ]

        for data in solarData {
            let model = CJDealTextModel()
            model.text = data.text
            model.actionTitle = "公历月天数"
            model.hopeResultText = "\(data.months)个月\(data.days)天"
            model.autoExec = true
            model.actionBlock = { oldString in
                let date = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                let monthAndDayTuple = date.currentMonthDayCountTuple(inLunarCalendar: false)
                if monthAndDayTuple == nil {
                    return "获取失败"
                }
                return "\(monthAndDayTuple!.monthCount)个月\(monthAndDayTuple!.dayCount)天"
            }
            solarSection.values.add(model)
        }

        sectionDataModels.append(solarSection)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
