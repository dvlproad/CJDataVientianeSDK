//
//  TSInsertFeedHomeViewController.swift
//  CJUIKitDemo
//
//  Converted from Objective-C on 2026/7/16.
//

import UIKit
import CQDemoKit

@objc public class TSInsertFeedHomeViewController: CJUIKitBaseHomeViewController {

    private var feedAdInsertUtil1: TSFeedAdInsertUtil!
    private var feedAdInsertUtil2: TSFeedAdInsertUtil!
    private var feedAdInsertUtil11: TSFeedAdInsertUtil!
    private var currentDataModels: [TSTempDataModel] = []

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = NSLocalizedString("广告流插入测试首页", comment: "")

        self.feedAdInsertUtil1 = TSFeedAdInsertUtil(
            currentDataModels: [],
            afterEveryRowSteps: [],
            remainderEveryRowStep: 4,
            itemCountPerRow: 1
        )
        self.feedAdInsertUtil2 = TSFeedAdInsertUtil(
            currentDataModels: [],
            afterEveryRowSteps: [2],
            remainderEveryRowStep: 1,
            itemCountPerRow: 3
        )

        var models: [TSTempDataModel] = []
        for _ in 0..<50 {
            models.append(TSTempDataModel())
        }
        self.currentDataModels = models
        self.feedAdInsertUtil11 = TSFeedAdInsertUtil(
            currentDataModels: self.currentDataModels,
            afterEveryRowSteps: [2],
            remainderEveryRowStep: 1,
            itemCountPerRow: 3
        )

        var sectionDataModels: [CQDMSectionDataModel] = []

        // FeedAd
        let sectionDataModel = CQDMSectionDataModel()
        sectionDataModel.theme = "广告流FeedAd插入相关"

        let module1 = CQDMModuleModel()
        module1.title = "广告流FeedAd插入相关--在分页数据中添加"
        module1.content = self.feedAdInsertUtil1.getInsertDescription()
        module1.contentLines = 4
        module1.actionBlock = { [weak self] in
            self?.feedAdInsertUtil1.insertElementsToAppendArray()
        }
        sectionDataModel.values.add(module1)

        let module2 = CQDMModuleModel()
        module2.title = "广告流FeedAd插入相关--在分页数据中添加"
        module2.content = self.feedAdInsertUtil2.getInsertDescription()
        module2.contentLines = 4
        module2.actionBlock = { [weak self] in
            self?.feedAdInsertUtil2.insertElementsToAppendArray()
        }
        sectionDataModel.values.add(module2)

        let module3 = CQDMModuleModel()
        module3.title = "广告流FeedAd插入相关--整理自身"
        module3.content = self.feedAdInsertUtil11.getInsertDescription()
        module3.contentLines = 4
        module3.actionBlock = { [weak self] in
            self?.feedAdInsertUtil11.insertElementsToSelf()
        }
        sectionDataModel.values.add(module3)

        sectionDataModels.append(sectionDataModel)

        self.sectionDataModels = NSMutableArray(array: sectionDataModels)
    }
}
