//
//  TSFeedAdInsertPage.swift
//  CJUIKitDemo
//
//  Created by qian on 2024/12/30.
//  Copyright © 2025 dvlproad. All rights reserved.
//

import Foundation
import SwiftUI
import CJDataVientianeSDK_Swift

class TSTempDataModel: NSObject {
    var isAdBannerModel: Bool = false
}



class TSFeedAdInsertUtil: NSObject {
    var currentDataModels: [Any]
    var lastInsertIndex: Int = -1
    var afterEveryRowSteps: [Int] // 前2行壁纸之后固定展示1个信息流广告。此后每隔*行壁纸展示一个信息流广告，后台信息流广告间隔行数配置
    var remainderEveryRowStep: Int
    var itemCountPerRow: Int
    
    @objc init(currentDataModels: [Any], afterEveryRowSteps: [Int], remainderEveryRowStep: Int, itemCountPerRow: Int) {
        self.currentDataModels = currentDataModels
        self.afterEveryRowSteps = afterEveryRowSteps
        self.remainderEveryRowStep = remainderEveryRowStep
        self.itemCountPerRow = itemCountPerRow
    }
    
    @objc func getInsertDescription() -> String {
        var string: String = ""
        
        string += "每行元素数:\(itemCountPerRow)\n"
        
        var customInsertString: String = ""
        for i in 0 ..< afterEveryRowSteps.count {
            let stepString = "第\(i+1)次插入在第\(afterEveryRowSteps[i])行"
            customInsertString += stepString
        }
        string += customInsertString
        
        if afterEveryRowSteps.count > 0 {
            string += "\n剩余"
        } else {
            string += "全部"
        }
        string += "每隔\(remainderEveryRowStep)行插入"
        
        return string
    }
    
    
    @objc func insertElementsToAppendArray() {
        var appendModels: [Any] = []
        for i in 0 ..< 10 {
            let model = TSTempDataModel()
            appendModels.append(model)
        }
        

        let lastArrayCount = currentDataModels.count
        CJFeedAdInsertUtil.insertElementsIfNeeded(in: &appendModels, lastArrayCount: lastArrayCount, lastInsertIndex: &lastInsertIndex, afterEveryRowSteps: &afterEveryRowSteps, remainderEveryRowStep: remainderEveryRowStep, itemCountPerRow: itemCountPerRow, insertElementGetter: {
            
            let model = TSTempDataModel()
            model.isAdBannerModel = true
            
            return model
        })
        currentDataModels.append(contentsOf: appendModels)
        
        self.printResultString()
    }
    
    @objc func insertElementsToSelf() {
        currentDataModels = CJFeedAdInsertUtil.insertElementsIfNeeded(in: &currentDataModels, afterEveryRowSteps: &afterEveryRowSteps, remainderEveryRowStep: remainderEveryRowStep, itemCountPerRow: itemCountPerRow, insertElementGetter: {
            
            let model = TSTempDataModel()
            model.isAdBannerModel = true
            
            return model
        })
        
        self.printResultString()
    }
    
    

    private func printResultString() {
        var string: String = ""
        for i in 0 ..< currentDataModels.count {
            let model = currentDataModels[i]
            if let model = model as? TSTempDataModel {
                string += "\(i): \(model.isAdBannerModel ? "【✅是】广告" : "【不是】广告")\n"
            }
        }
        print(string)
    }
}
