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



/// 广告流插入工具类，封装 CJFeedAdInsertUtil，演示如何在列表数据中按规则插入广告元素。
///
/// 插入规则由两个参数控制：
/// - `afterEveryRowSteps`: 前 N 次插入的间隔行数（用完后使用 remainderEveryRowStep）
/// - `remainderEveryRowStep`: 剩余部分每隔多少行插入一个广告
///
/// 例如 `afterEveryRowSteps: [2], remainderEveryRowStep: 1, itemCountPerRow: 3` 表示：
/// 前 2 行数据后插入第一个广告，之后每隔 1 行插入一个广告，每行有 3 个元素。
class TSFeedAdInsertUtil: NSObject {
    /// 当前数据源数组（包含普通内容和广告元素）
    var currentDataModels: [Any]
    /// 上次插入广告的位置索引，用于计算下次插入间距
    var lastInsertIndex: Int = -1
    /// 前 N 次插入的间隔行数数组，依次消费；用完后使用 remainderEveryRowStep。
    /// 前2行壁纸之后固定展示1个信息流广告。此后每隔*行壁纸展示一个信息流广告，后台信息流广告间隔行数配置
    /// 例如 `[2, 3]` 表示第 1 次在第 2 行后插入，第 2 次在第 3 行后插入，之后每隔 remainderEveryRowStep 行插入。
    var afterEveryRowSteps: [Int]
    /// 前 N 次自定义间隔用完后，每隔多少行插入一个广告
    var remainderEveryRowStep: Int
    /// 每行展示的元素个数（用于将行数转换为实际元素索引间距）
    var itemCountPerRow: Int
    
    /// - Parameters:
    ///   - currentDataModels: 初始数据源数组
    ///   - afterEveryRowSteps: 前 N 次插入的间隔行数，依次消费
    ///   - remainderEveryRowStep: 自定义间隔用完后，每隔多少行插入一个广告
    ///   - itemCountPerRow: 每行展示的元素个数
    @objc init(currentDataModels: [Any], afterEveryRowSteps: [Int], remainderEveryRowStep: Int, itemCountPerRow: Int) {
        self.currentDataModels = currentDataModels
        self.afterEveryRowSteps = afterEveryRowSteps
        self.remainderEveryRowStep = remainderEveryRowStep
        self.itemCountPerRow = itemCountPerRow
    }
    
    /// 返回当前插入规则的可读描述字符串，用于 UI 展示。
    /// 内容包含：每行元素数、自定义间隔、默认间隔等信息。
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
    
    
    /// 模拟分页加载：新创建 10 个数据模型，按规则在其中插入广告元素，然后追加到 currentDataModels。
    ///
    /// 适用场景：上拉加载更多时，广告插入逻辑作用于新加载的这批数据，
    /// 插入完成后再合并到已有数据源中。内部会维护 lastInsertIndex 以跨次调用保持间距连续。
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
    
    /// 直接在 currentDataModels 内部按规则重新插入广告元素。
    ///
    /// 适用场景：数据源已全部加载完毕（如本地缓存、一次性全量数据），
    /// 需要对整个数组重新排布广告。调用后 currentDataModels 会被替换为插入后的新数组。
    @objc func insertElementsToSelf() {
        currentDataModels = CJFeedAdInsertUtil.insertElementsIfNeeded(in: &currentDataModels, afterEveryRowSteps: &afterEveryRowSteps, remainderEveryRowStep: remainderEveryRowStep, itemCountPerRow: itemCountPerRow, insertElementGetter: {
            
            let model = TSTempDataModel()
            model.isAdBannerModel = true
            
            return model
        })
        
        self.printResultString()
    }
    
    

    /// 打印当前数据源中每个元素的位置和广告标记，用于调试验证插入结果。
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
