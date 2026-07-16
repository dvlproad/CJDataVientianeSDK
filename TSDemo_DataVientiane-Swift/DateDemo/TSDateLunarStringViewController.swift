import UIKit
import CJDataVientianeSDK_Swift
import CQDemoKit

@objc class TSDateLunarStringViewController: CQTSLongBaseAutoTestMethodViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "农历格式显示"

        var sectionDataModels: [CQDMSectionDataModel] = []

        let section = CQDMSectionDataModel()
        section.theme = "农历格式显示"

        let dates: [(text: String, expected: String)] = [
            ("1982-01-01", "1981辛酉年腊月初七"),
            ("1984-01-01", "1983癸亥年冬月廿九"),
            ("2025-08-01", "2025乙巳年闰六月初八"),
            ("2025-01-28", "2024甲辰年腊月廿九"),
            ("2025-02-03", "2025乙巳年正月初六"),
            ("2024-03-19", "2024甲辰年二月初十"),
            ("2024-10-01", "2024甲辰年八月廿九"),
            ("2025-01-03", "2024甲辰年腊月初四"),
            ("2025-02-05", "2025乙巳年正月初八"),
        ]

        for date in dates {
            let model = CQTSAutoTestMethodModel()
            model.text = date.text
            model.actionTitle = "农历字符串"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let date = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                return CJDateFormatterUtil.lunarStringForDate(from: date)
            }
            section.values.add(model)
        }

        sectionDataModels.append(section)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
