//
//  TSDataVientianeMainViewController.swift
//  TSDemo_DataVientiane-Swift
//
//  Converted from Objective-C on 2026/7/16.
//

import UIKit
import CQDemoKit
import CQDemoResource
import TSDemo_DataVientiane

public class TSDataVientianeMainViewController: CJUIKitBaseTabBarViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        var tabBarModels: [CQDMTabBarModel] = []

        do {
            let m = CQDMTabBarModel()
            m.title = NSLocalizedString("String", comment: "")
            m.normalImage = UIImage.cqresource_imageNamed("icons8-home")
            m.classEntry = StringForInputHomeViewController.self
            tabBarModels.append(m)
        }
        do {
            let m = CQDMTabBarModel()
            m.title = NSLocalizedString("Date", comment: "")
            m.normalImage = UIImage.cqresource_imageNamed("icons8-menu")
            m.classEntry = TSDateHomeViewController.self
            tabBarModels.append(m)
        }
        do {
            let m = CQDMTabBarModel()
            m.title = NSLocalizedString("Logic", comment: "")
            m.normalImage = UIImage.cqresource_imageNamed("icons8-calendar")
            m.classEntry = ValidateStringViewController.self
            tabBarModels.append(m)
        }
        do {
            let m = CQDMTabBarModel()
            m.title = NSLocalizedString("广告插入", comment: "")
            m.normalImage = UIImage.cqresource_imageNamed("icons8-folder")
            m.classEntry = TSInsertFeedHomeViewController.self
            tabBarModels.append(m)
        }

        self.tabBarModels = tabBarModels
    }
}
