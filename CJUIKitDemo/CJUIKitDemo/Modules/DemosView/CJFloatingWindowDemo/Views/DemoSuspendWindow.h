//
//  DemoSuspendWindow.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2017/5/20.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

#ifdef TEST_CJBASEUIKIT_POD
#import "UIView+CJDragAction.h"
#else
#import <CJBaseUIKit/UIView+CJDragAction.h>
#endif


/**
 *  用于弹出log视图的悬浮球
 */
@interface DemoSuspendWindow : UIWindow {
    
}
@property(nonatomic, copy) NSString *windowIdentifier;
@property (nonatomic, copy) void (^clickWindowBlock)(UIButton *clickButton);
@property (nonatomic, copy) void (^closeWindowBlock)(void);

- (void)removeFromScreen;

@end
