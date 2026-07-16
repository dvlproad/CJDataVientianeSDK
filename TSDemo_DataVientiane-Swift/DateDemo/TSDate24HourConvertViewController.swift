import UIKit
import CQDemoKit

@objc class TSDate24HourConvertViewController: CQTSLongBaseAutoTestMethodViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "24小时制/12小时制时间还原"

        var sectionDataModels: [CQDMSectionDataModel] = []

        let section = CQDMSectionDataModel()
        section.theme = "24小时制/12小时制时间还原"

        // 24→12还原
        let model1 = CQTSAutoTestMethodModel()
        model1.text = "2023-05-10 00:00:00"
        model1.actionTitle = "24→12还原"
        model1.hopeResultText = "还原成功: 2023-05-10 00:00:00"
        model1.autoExec = true
        model1.actionBlock = { oldString in
            if let date = Date.fromTimeString("2023-05-10 00:00:00") {
                return "还原成功: \(date)"
            } else {
                return "解析失败"
            }
        }
        section.values.add(model1)

        // 12→24还原
        let model2 = CQTSAutoTestMethodModel()
        model2.text = "2023-05-10 12:00:00 AM"
        model2.actionTitle = "12→24还原"
        model2.hopeResultText = "还原成功: 2023-05-10 00:00:00"
        model2.autoExec = true
        model2.actionBlock = { oldString in
            if let date = Date.fromTimeString("2023-05-10 12:00:00 AM") {
                return "还原成功: \(date)"
            } else {
                return "解析失败"
            }
        }
        section.values.add(model2)

        sectionDataModels.append(section)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
