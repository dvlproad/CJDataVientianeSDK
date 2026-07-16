import UIKit
import CQDemoKit

@objc class TSDateFindEqualLunarDateViewController: CJUIKitBaseBigTextViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "找下一个相等的农历日期"

        var sectionDataModels: [CQDMSectionDataModel] = []

        let section = CQDMSectionDataModel()
        section.theme = "找下一个相等的农历日期"

        let dates: [(text: String, target: String, monthMustEqual: Bool, expected: String)] = [
            ("2023-01-01", "2020-03-23", true, "下个月没有与之相等的日期"),
            ("2023-03-20", "2020-03-23", true, "2023-03-21"),
            ("2023-03-22", "2020-03-23", true, "2023-04-19"),
            ("2025-07-25", "2008-02-08", false, "2025-07-26"),
            ("2025-07-25", "2024-02-09", false, "2025-08-22"),
        ]

        for date in dates {
            let model = CJDealTextModel()
            model.text = date.text
            model.actionTitle = "找相等日期"
            model.hopeResultText = date.expected
            model.autoExec = true
            model.actionBlock = { oldString in
                let fromDate = TestSwift1.greDateFromYYYYMMDDString(dateString: oldString)
                let targetDate = TestSwift1.greDateFromYYYYMMDDString(dateString: date.target)
                let nextEqualDate: Date? = targetDate.findNextEqualLunarDateFromDate(fromDate, isMonthMustEqual: date.monthMustEqual)
                if nextEqualDate == nil {
                    return "下个月没有与之相等的日期"
                } else {
                    return nextEqualDate!.format("yyyy-MM-dd")
                }
            }
            section.values.add(model)
        }

        sectionDataModels.append(section)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
