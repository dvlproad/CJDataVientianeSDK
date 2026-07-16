import UIKit
import CJDataVientianeSDK_Swift
import CQDemoKit

@objc class TSDateMonthlyRepeatViewController: CJUIKitBaseBigTextViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "按月计算下一个周期"

        var sectionDataModels: [CQDMSectionDataModel] = []

        // 农历
        let lunarSection = CQDMSectionDataModel()
        lunarSection.theme = "农历"

        let lunarDates: [(text: String, selected: String, expected: String)] = [
            ("2025-06-24", "2026-07-14", "2025-06-25"),
            ("2025-06-25", "2026-07-14", "2025-06-25"),
            ("2025-06-26", "2026-07-14", "2025-07-25"),
        ]

        for date in lunarDates {
            let model = CJDealTextModel()
            model.text = date.text
            model.actionTitle = "农历按月"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let selectedDate = TestSwift1.greDateFromYYYYMMDDString(dateString: date.selected)
                let comparisonDate = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                let lunarCalendar = Calendar(identifier: .chinese)
                if let nextMonthDate = selectedDate.closestCommemorationDate(commemorationCycleType: .month, afterDate: comparisonDate, shouldFlyback: false, calendar: lunarCalendar) {
                    return CJDateFormatterUtil.formatGregorianDate(from: nextMonthDate)
                }
                return "未找到"
            }
            lunarSection.values.add(model)
        }

        sectionDataModels.append(lunarSection)

        // 公历
        let solarSection = CQDMSectionDataModel()
        solarSection.theme = "公历"

        let solarDates: [(text: String, selected: String, expected: String)] = [
            ("2024-03-09", "2024-03-19", "2024-03-19"),
            ("2024-11-29", "2024-04-08", "2024-12-08"),
        ]

        for date in solarDates {
            let model = CJDealTextModel()
            model.text = date.text
            model.actionTitle = "公历按月"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let selectedDate = TestSwift1.greDateFromYYYYMMDDString(dateString: date.selected)
                let comparisonDate = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                let lunarCalendar = Calendar(identifier: .gregorian)
                if let nextMonthDate = selectedDate.closestCommemorationDate(commemorationCycleType: .month, afterDate: comparisonDate, shouldFlyback: false, calendar: lunarCalendar) {
                    return CJDateFormatterUtil.formatGregorianDate(from: nextMonthDate)
                }
                return "未找到"
            }
            solarSection.values.add(model)
        }

        sectionDataModels.append(solarSection)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
