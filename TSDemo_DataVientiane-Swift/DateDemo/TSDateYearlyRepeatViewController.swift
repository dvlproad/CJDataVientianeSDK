import UIKit
import CJDataVientianeSDK_Swift
import CQDemoKit

@objc class TSDateYearlyRepeatViewController: CQTSLongBaseAutoTestMethodViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "按年计算下一个周期"

        var sectionDataModels: [CQDMSectionDataModel] = []

        // 公历：纪念日为2020-02-28
        let solarSection1 = CQDMSectionDataModel()
        solarSection1.theme = "公历：纪念日为2020-02-28"

        let solarDates1: [(text: String, expected: String)] = [
            ("2024-01-01", "2024-02-28"),
            ("2024-02-28", "2024-02-28"),
            ("2024-03-01", "2025-02-28"),
        ]

        for date in solarDates1 {
            let model = CQTSAutoTestMethodModel()
            model.text = date.text
            model.actionTitle = "公历按年"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let selectedDate = TestSwift1.greDateFromYYYYMMDDString(dateString: "2020-02-28")
                var comparisonDate = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                comparisonDate = comparisonDate.addingTimeInterval(TimeInterval(1 * 60 * 60))
                let lunarCalendar = Calendar(identifier: .gregorian)
                if let nextYearDate = selectedDate.closestCommemorationDate(commemorationCycleType: .year, afterDate: comparisonDate, shouldFlyback: false, calendar: lunarCalendar) {
                    return CJDateFormatterUtil.formatGregorianDate(from: nextYearDate)
                }
                return "未找到"
            }
            solarSection1.values.add(model)
        }

        sectionDataModels.append(solarSection1)

        // 公历：纪念日为2020-02-29
        let solarSection2 = CQDMSectionDataModel()
        solarSection2.theme = "公历：纪念日为2020-02-29"

        let solarDates2: [(text: String, shouldFlyback: Bool, expected: String)] = [
            ("2023-01-01", true, "2023-02-28"),
            ("2023-01-01", false, "2023-03-01"),
            ("2024-01-01", true, "2024-02-29"),
        ]

        for date in solarDates2 {
            let model = CQTSAutoTestMethodModel()
            model.text = date.text
            model.actionTitle = "公历闰年按年"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let selectedDate = TestSwift1.greDateFromYYYYMMDDString(dateString: "2020-02-29")
                var comparisonDate = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                comparisonDate = comparisonDate.addingTimeInterval(TimeInterval(1 * 60 * 60))
                let lunarCalendar = Calendar(identifier: .gregorian)
                if let nextYearDate = selectedDate.closestCommemorationDate(commemorationCycleType: .year, afterDate: comparisonDate, shouldFlyback: date.shouldFlyback, calendar: lunarCalendar) {
                    return CJDateFormatterUtil.formatGregorianDate(from: nextYearDate)
                }
                return "未找到"
            }
            solarSection2.values.add(model)
        }

        sectionDataModels.append(solarSection2)

        // 农历：纪念日为2026-07-14
        let lunarSection = CQDMSectionDataModel()
        lunarSection.theme = "农历：纪念日为2026-07-14"

        let lunarDates: [(text: String, expected: String)] = [
            ("2025-06-24", "2025-06-25"),
            ("2025-06-25", "2025-06-25"),
            ("2025-06-26", "2025-07-25"),
        ]

        for date in lunarDates {
            let model = CQTSAutoTestMethodModel()
            model.text = date.text
            model.actionTitle = "农历按年"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let selectedDate = TestSwift1.greDateFromYYYYMMDDString(dateString: "2026-07-14")
                var comparisonDate = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                comparisonDate = comparisonDate.addingTimeInterval(TimeInterval(1 * 60 * 60))
                let lunarCalendar = Calendar(identifier: .chinese)
                if let nextYearDate = selectedDate.closestCommemorationDate(commemorationCycleType: .year, afterDate: comparisonDate, shouldFlyback: false, calendar: lunarCalendar) {
                    return CJDateFormatterUtil.formatGregorianDate(from: nextYearDate)
                }
                return "未找到"
            }
            lunarSection.values.add(model)
        }

        sectionDataModels.append(lunarSection)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
