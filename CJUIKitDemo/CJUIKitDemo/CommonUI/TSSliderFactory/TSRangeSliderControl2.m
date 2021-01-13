//
//  TSRangeSliderControl2.m
//  CJUIKitDemo
//
//  Created by qian on 2020/11/9.
//  Copyright © 2020 dvlproad. All rights reserved.
//

#import "TSRangeSliderControl2.h"
#import "CJSliderPopover.h"
#import <CQDemoKit/CJUIKitToastUtil.h>

@interface TSRangeSliderControl2 () {
    
}
@property (nonatomic, copy) void(^chooseCompleteBlock)(CGFloat minValue, CGFloat maxValue);

@end

@implementation TSRangeSliderControl2

/*
 *  初始化
 *
 *  @param minRangeValue                选择范围的最小值
 *  @param maxRangeValue                选择范围的最大值
 *  @param startRangeValue              初始范围的起始值
 *  @param endRangeValue                初始范围的结束值
 *  @param chooseCompleteBlock          选择结束，返回选择的最大和最小值
 *
 *  @param slider滑块视图
 */
- (instancetype)initWithMinRangeValue:(CGFloat)minRangeValue
                        maxRangeValue:(CGFloat)maxRangeValue
                      startRangeValue:(CGFloat)startRangeValue
                        endRangeValue:(CGFloat)endRangeValue
                  chooseCompleteBlock:(void(^)(CGFloat minValue, CGFloat maxValue))chooseCompleteBlock
{
    self = [super initWithMinRangeValue:minRangeValue maxRangeValue:maxRangeValue startRangeValue:startRangeValue endRangeValue:endRangeValue createTrackViewBlock:^UIView *{
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor redColor];
        return view;
    } createFrontViewBlock:^UIView *{
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor greenColor];
        return view;
    } createPopoverViewBlock:^UIView *(BOOL left) {
        CGFloat popoverHeight = self.popoverSize.height;// 弹出框的高
        CGFloat popoverWidth = self.popoverSize.width;  // 弹出框的宽
        UIView *popoverView = [[CJSliderPopover alloc] initWithFrame:CGRectMake(0, 0, popoverWidth, popoverHeight)];
        return popoverView;
    } valueChangedBlock:^(CJRangeSliderControl *bSlider, CJSliderValueChangeHappenType happenType, CGFloat leftThumbPercent, CGFloat rightThumbPercent, CGFloat leftPopoverNum, CGFloat rightPopoverNum) {
        [self __ageUpdateValueByHappenType:happenType
                          leftThumbPercent:leftThumbPercent
                         rightThumbPercent:rightThumbPercent];
    } gestureStateChangeBlock:^(CJSliderGRState gestureRecognizerState) {
        if (gestureRecognizerState == CJSliderGRStateThumbDragEnd || gestureRecognizerState == CJSliderGRStateTrackTouchEnd) {
            [CJUIKitToastUtil showMessage:@"做抖动动作"];
        }
    }];
    if (self) {
        _chooseCompleteBlock = chooseCompleteBlock;
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor cyanColor];
    
    self.trackHeight = 15;                  // 设置滑道高度
    self.popoverSize = CGSizeMake(30, 32);  // 设置弹出框大小
    self.popoverSpacing = 2;                // 设置弹出框底部与滑块顶部间距大小
    [self configThumbMoveMinXMargin:0
                      leftThumbSize:CGSizeMake(100, 30)
      trackViewMinXIsLeftThumbXType:CJThumbXTypeMid];
    [self configThumbMoveMaxXMargin:0
                     rightThumbSize:CGSizeMake(100, 30)
     trackViewMaxXIsRightThumbXType:CJThumbXTypeMid];
    
    UIImage *normalImage = [UIImage imageNamed:@"slider_double_thumbImage_a"];
    UIImage *highlightedImage = [UIImage imageNamed:@"slider_double_thumbImage_b"];
    [self.leftThumb setImage:normalImage forState:UIControlStateNormal];
    [self.leftThumb setImage:highlightedImage forState:UIControlStateHighlighted];
    [self.rightThumb setImage:normalImage forState:UIControlStateNormal];
    [self.rightThumb setImage:highlightedImage forState:UIControlStateHighlighted];
    
    self.leftThumb.alpha = 0.5;
    self.rightThumb.alpha = 0.5;
    [self.leftThumb setBackgroundColor:[UIColor purpleColor]];
    [self.rightThumb setBackgroundColor:[UIColor brownColor]];
}


#pragma mark - Private Method
/*
 *  根据选中的值更新popover上的值
 *
 *  @param happenInLeft         滑块上的值改变发生的事件来源类型
 *  @param leftThumbPercent     左边滑块中心点所在滑道的比例
 *  @param rightThumbPercent    右边滑块中心点所在滑道的比例
 */
- (void)__ageUpdateValueByHappenType:(CJSliderValueChangeHappenType)happenType
                    leftThumbPercent:(CGFloat)leftThumbPercent
                   rightThumbPercent:(CGFloat)rightThumbPercent
{
    CGFloat leftPopoverNum    = leftThumbPercent  * (self.maxValue - self.minValue);
    CGFloat rightPopoverNum   = rightThumbPercent * (self.maxValue - self.minValue);
    
    BOOL shouldUpdateLeft = YES;
    BOOL shouldUpdateRight = YES;
    
    switch (happenType) {
        case CJSliderValueChangeHappenTypeInit: {
            shouldUpdateLeft = YES;
            shouldUpdateRight = YES;
            break;
        }
        case CJSliderValueChangeHappenTypeLeftMove: {
            shouldUpdateLeft = YES;
            shouldUpdateRight = NO;
            break;
        }
        case CJSliderValueChangeHappenTypeRightMove: {
            shouldUpdateLeft = NO;
            shouldUpdateRight = YES;
            break;
        }
        default:{
            shouldUpdateLeft = YES;
            shouldUpdateRight = YES;
            break;
        }
    }
    
    NSInteger minAge = (NSInteger)leftPopoverNum;
    NSInteger maxAge = (NSInteger)rightPopoverNum;
    if (shouldUpdateLeft) {
        NSString *leftContent = [NSString stringWithFormat:@"%zd", minAge];
        [(CJSliderPopover *)self.leftPopover updatePopoverTextValue:leftContent];
    }
    
    if (shouldUpdateRight) {
        NSString *rightContent = [NSString stringWithFormat:@"%zd", maxAge];
        [(CJSliderPopover *)self.rightPopover updatePopoverTextValue:rightContent];
    }
    //NSLog(@"age rangeSlider rangion:%f,%f", minValue, maxValue);

    !_chooseCompleteBlock ?: _chooseCompleteBlock(minAge, maxAge);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
