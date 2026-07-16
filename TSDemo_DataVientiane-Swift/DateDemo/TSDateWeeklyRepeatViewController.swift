import UIKit
import CJDataVientianeSDK_Swift
import CQDemoKit

@objc class TSDateWeeklyRepeatViewController: CQTSLongBaseAutoTestMethodViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "按周计算下一个周期"

        var sectionDataModels: [CQDMSectionDataModel] = []

        // 公历
        let solarSection = CQDMSectionDataModel()
        solarSection.theme = "公历"

        let solarDates: [(text: String, selected: String, expected: String)] = [
            ("2024-03-09", "2020-05-19", "2024-03-12"),
            ("2023-12-25", "2024-05-01", "2023-12-27"),
            ("2023-12-28", "2024-05-01", "2024-01-03"),
        ]

        for date in solarDates {
            let model = CQTSAutoTestMethodModel()
            model.text = date.text
            model.actionTitle = "公历按周"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let selectedDate = TestSwift1.greDateFromYYYYMMDDString(dateString: date.selected)
                let comparisonDate = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                let lunarCalendar = Calendar(identifier: .gregorian)
                if let nextWeekDate = selectedDate.closestCommemorationDate(commemorationCycleType: .week, afterDate: comparisonDate, shouldFlyback: false, calendar: lunarCalendar) {
                    return CJDateFormatterUtil.formatGregorianDate(from: nextWeekDate)
                }
                return "未找到"
            }
            solarSection.values.add(model)
        }

        sectionDataModels.append(solarSection)

        // 农历
        let lunarSection = CQDMSectionDataModel()
        lunarSection.theme = "农历"

        let lunarDates: [(text: String, selected: String, expected: String)] = [
            ("2024-03-09", "2020-05-19", "2024-03-12"),
            ("2023-12-25", "2024-05-01", "2023-12-27"),
            ("2023-12-28", "2024-05-01", "2024-01-03"),
            ("2025-07-25", "2024-07-06", "2025-07-26"),
        ]

        for date in lunarDates {
            let model = CQTSAutoTestMethodModel()
            model.text = date.text
            model.actionTitle = "农历按周"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let selectedDate = TestSwift1.greDateFromYYYYMMDDString(dateString: date.selected)
                let comparisonDate = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                let lunarCalendar = Calendar(identifier: .chinese)
                if let nextWeekDate = selectedDate.closestCommemorationDate(commemorationCycleType: .week, afterDate: comparisonDate, shouldFlyback: false, calendar: lunarCalendar) {
                    return CJDateFormatterUtil.formatGregorianDate(from: nextWeekDate)
                }
                return "未找到"
            }
            lunarSection.values.add(model)
        }

        sectionDataModels.append(lunarSection)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
