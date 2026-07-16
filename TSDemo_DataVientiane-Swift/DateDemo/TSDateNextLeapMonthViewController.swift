import UIKit
import CQDemoKit

@objc class TSDateNextLeapMonthViewController: CJUIKitBaseBigTextViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "下个月是否是本月的闰月"

        var sectionDataModels: [CQDMSectionDataModel] = []

        let section = CQDMSectionDataModel()
        section.theme = "下个月是否是本月的闰月"

        let dates: [(text: String, expected: String)] = [
            ("2025-06-25", "下个月【是】本月的闰月"),
            ("2025-07-24", "下个月【是】本月的闰月"),
            ("2025-07-25", "下个月【不是】本月的闰月"),
            ("2025-08-23", "下个月【不是】本月的闰月"),
        ]

        for date in dates {
            let model = CJDealTextModel()
            model.text = date.text
            model.actionTitle = "闰月判断"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let date = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                let isNextLeapMonth = date.isNextLunarMonthEqualToCurrentMonth()
                if isNextLeapMonth {
                    return "下个月【是】本月的闰月"
                } else {
                    return "下个月【不是】本月的闰月"
                }
            }
            section.values.add(model)
        }

        sectionDataModels.append(section)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
