//
//  CJTimerManager.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2015/09/06.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJTimerModel.h"

NS_ASSUME_NONNULL_BEGIN

//typedef NS_ENUM(NSUInteger, MyCountDownTimeZeroAction) {
//    MyCountDownTimeZeroActionInvalidate,    /**< 销毁(结束定时器) */
//    MyCountDownTimeZeroActionRestore,       /**< 还原(多用于循环定时,会自动将定时器时间还原到周期时间) */
//};


/**
 *  一个全局倒计时管理器(全局定时器的时候才用，其他的自己创建定时器就好了)
 *  eg:(因为计时器有可能属于ViewController，但也有可能属于一个全局的，比如全局监控一个数组，如果数组未空，则启动计时器，直到数组为空，才取消计时器，下次数组有值加入，又变成未空时候，再启动计时器)
 */
@interface CJTimerManager : NSObject
{
    
}

+ (CJTimerManager *)sharedInstance;

@property (nonatomic, strong) NSMutableArray<CJTimerModel *> *timerModels;

/**
 *  创建计时器
 *
 *  @param timeInterval 计时器间隔
 */
- (void)createTimerWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 *  计时器是否有效
 *
 *  @return 是否有效
 */
- (BOOL)isTimerValid;

/**
 *  启动计时器
 */
- (void)fireTimer;

/**
 *  销毁/结束定时器（下次使用，需重新create）
 */
- (void)invalidateTimerWithCompleteBlock:(void(^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
