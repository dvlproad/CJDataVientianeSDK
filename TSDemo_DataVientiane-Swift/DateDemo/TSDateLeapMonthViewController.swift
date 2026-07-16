import UIKit
import CQDemoKit

@objc class TSDateLeapMonthViewController: CQTSLongBaseAutoTestMethodViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "农历闰月信息"

        var sectionDataModels: [CQDMSectionDataModel] = []

        let section = CQDMSectionDataModel()
        section.theme = "农历闰月信息"

        let dates: [(text: String, expected: String)] = [
            ("2023-01-01", "2023年有农历闰二月"),
            ("2024-01-01", "2024年无农历闰月"),
            ("2025-01-01", "2025年有农历闰六月"),
        ]

        for date in dates {
            let model = CQTSAutoTestMethodModel()
            model.text = date.text
            model.actionTitle = "闰月信息"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let date = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                let lunarLeapMonthTuple = date.getThisYearLunarLeapMonthTuple()
                let year: Int = Int(oldString.prefix(4)) ?? 0
                if lunarLeapMonthTuple == nil {
                    return "\(year)年无农历闰月"
                } else {
                    let lunarLeapMonthCNName = lunarLeapMonthTuple!.lunarLeapMonthCNName
                    return "\(year)年有农历\(lunarLeapMonthCNName)"
                }
            }
            section.values.add(model)
        }

        sectionDataModels.append(section)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
