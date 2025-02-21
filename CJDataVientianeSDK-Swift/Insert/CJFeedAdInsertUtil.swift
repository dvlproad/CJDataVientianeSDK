//
//  CJFeedAdInsertUtil.swift
//  CJUIKitDemo
//
//  Created by qian on 2024/12/3.
//  Copyright © 2024 dvlproad. All rights reserved.
//

import Foundation


open class CJFeedAdInsertUtil {
    public static func insertElementsIfNeeded(in array: inout [Any], afterEveryRowSteps: inout [Int], remainderEveryRowStep: Int, itemCountPerRow: Int, insertElementGetter: () -> Any) -> [Any] {
        var toArray:[Any] = []
        var appendModels: [Any] = array
        
        var lastArrayCount = 0
        var lastInsertIndex: Int = -1
        insertElementsIfNeeded(in: &appendModels, lastArrayCount: lastArrayCount, lastInsertIndex: &lastInsertIndex, afterEveryRowSteps: &afterEveryRowSteps, remainderEveryRowStep: remainderEveryRowStep, itemCountPerRow: itemCountPerRow, insertElementGetter: insertElementGetter)
        
        toArray.append(contentsOf: appendModels)
    
        return toArray
    }
    
    // 在数组中持续插入新元素，并且只有在当前位置距离上次插入位置超过4个元素时才进行插入
    /// - Parameter lastArrayCount: array 可能是要追加的元素，所以需要 lastArrayCount 标记 array 前有多少个元素了
    /// - Parameter afterEveryRowSteps: 优先使用指定的间距，当使用完才使用默认的
    public static func insertElementsIfNeeded(in array: inout [Any], lastArrayCount: Int, lastInsertIndex: inout Int, afterEveryRowSteps: inout [Int], remainderEveryRowStep: Int, itemCountPerRow: Int, insertElementGetter: () -> Any) {
        func getNextAfterEveryStep() -> Int {
            var afterEveryRowStep: Int = 0
            if afterEveryRowSteps.count > 0 {
                afterEveryRowStep = afterEveryRowSteps[0]
                afterEveryRowSteps.remove(at: 0)
            } else {
                afterEveryRowStep = remainderEveryRowStep
            }
            let afterEveryStep = afterEveryRowStep * itemCountPerRow
            return afterEveryStep
        }
        
        var afterEveryStep: Int = getNextAfterEveryStep()
        guard afterEveryStep > 0 else {
            return
        }
        
        // 检查当前位置是否距离上次插入位置超过4个元素
        var tempArray: [Any] = []
        
        
        var index = 0
        var insertCount = 0
        while index < array.count + insertCount, afterEveryStep > 0 {   // 避免 afterEveryStep 为 0，然后死循环导致内存溢出
//            if (index + lastArrayCount + 1) % (afterEveryStep+1) == 0 { // 4-9-14-19-24-29-34
            if index + lastArrayCount - lastInsertIndex > afterEveryStep { // 4-9-14-19-24-29-34
                let element = insertElementGetter()
                
                tempArray.insert(element, at: index)
                lastInsertIndex = index + lastArrayCount
                insertCount += 1
                
                afterEveryStep = getNextAfterEveryStep()
            }
            
            if index < array.count {
                tempArray.append(array[index])
            }
            index += 1
        }
        array = tempArray
    }
}
