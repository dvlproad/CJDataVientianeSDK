//
//  UIWindow+CJSnapshot.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2017/9/29.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (CJSnapshot)

/**
 *  对window(包括view)进行截图
 *
 *  @rerun 截图后所得的图片
 */
- (UIImage *)cj_snapshot;

@end

NS_ASSUME_NONNULL_END
