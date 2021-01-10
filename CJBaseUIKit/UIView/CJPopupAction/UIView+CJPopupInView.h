//
//  UIView+CJPopupInView.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 15/11/12.
//  Copyright (c) 2015年 dvlproad. All rights reserved.
//
//  本视图弹出到指定视图(如window)中的方法

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void(^CJTapBlankViewCompleteBlock)(void);


typedef NS_ENUM(NSUInteger, CJWindowPosition) {
    CJWindowPositionBottom = 0,
    CJWindowPositionCenter
};

typedef NS_ENUM(NSUInteger, CJAnimationType) {
    //    MJPopupViewAnimationFade = 0,
    //    MJPopupViewAnimationSlideBottomTop = 1,
    //    MJPopupViewAnimationSlideBottomBottom,
    //    MJPopupViewAnimationSlideTopTop,
    //    MJPopupViewAnimationSlideTopBottom,
    //    MJPopupViewAnimationSlideLeftLeft,
    //    MJPopupViewAnimationSlideLeftRight,
    //    MJPopupViewAnimationSlideRightLeft,
    //    MJPopupViewAnimationSlideRightRight,
    CJAnimationTypeNone = 0,   //Directly
    CJAnimationTypeNormal,     //通过设置frame来实现
    CJAnimationTypeCATransform3D
};




NS_ASSUME_NONNULL_BEGIN

@interface UIView (CJPopupInView) {
    
}
@property (nonatomic, assign, readonly, getter=isCJPopupViewShowing) BOOL cjPopupViewShowing;   /**< 判断当前是否有弹出视图显示 */

/*
 *  将本View以size大小弹出到showInView视图中location位置
 *
 *  @param popupSuperview               弹出视图的父视图view
 *  @param popupViewOrigin              弹出视图的左上角origin坐标
 *  @param popupViewSize                弹出视图的size大小
 *  @param blankViewCreateBlock         空白区域视图的创建方法
 *  @param showPopupViewCompleteBlock   显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock    点击空白区域后的操作(要自己执行cj_hidePopupView...来隐藏，因为有时候点击背景是不执行隐藏的)
 */
- (void)cj_popupInView:(UIView *)popupSuperview
            withOrigin:(CGPoint)popupViewOrigin
                  size:(CGSize)popupViewSize
  blankViewCreateBlock:(UIView *(^ _Nullable)(void))blankViewCreateBlock
          showComplete:(void(^ _Nullable)(void))showPopupViewCompleteBlock
      tapBlankComplete:(void(^ _Nullable)(void))tapBlankViewCompleteBlock;


/*
 *  将当前视图弹出到window中央
 *
 *  @param animationType                弹出时候的动画采用的类型
 *  @param popupViewSize                弹出视图的大小
 *  @param centerOffset                 弹窗弹出位置的中心与window中心的偏移量
 *  @param blankViewCreateBlock         空白区域视图的创建方法
 *  @param showPopupViewCompleteBlock   显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock    点击空白区域后的操作(要自己执行cj_hidePopupView...来隐藏，因为有时候点击背景是不执行隐藏的)
 */
- (void)cj_popupInCenterWindow:(CJAnimationType)animationType
                      withSize:(CGSize)popupViewSize
                  centerOffset:(CGPoint)centerOffset
          blankViewCreateBlock:(UIView *(^ _Nullable)(void))blankViewCreateBlock
                  showComplete:(void(^ _Nullable)(void))showPopupViewCompleteBlock
              tapBlankComplete:(void(^ _Nullable)(void))tapBlankViewCompleteBlock;


/*
 *  将当前视图弹出到window底部
 *
 *  @param animationType                弹出时候的动画采用的类型
 *  @param popupViewHeight              弹出视图的高度
 *  @param edgeInsets                   弹窗与window的(左右下)边距
 *  @param blankViewCreateBlock         空白区域视图的创建方法
 *  @param showPopupViewCompleteBlock   显示弹出视图后的操作
 *  @param tapBlankViewCompleteBlock    点击空白区域后的操作(要自己执行cj_hidePopupView...来隐藏，因为有时候点击背景是不执行隐藏的)
 */
- (void)cj_popupInBottomWindow:(CJAnimationType)animationType
                    withHeight:(CGFloat)popupViewHeight
                    edgeInsets:(UIEdgeInsets)edgeInsets
                  blankViewCreateBlock:(UIView *(^ _Nullable)(void))blankViewCreateBlock
                  showComplete:(void(^ _Nullable)(void))showPopupViewCompleteBlock
              tapBlankComplete:(void(^ _Nullable)(void))tapBlankViewCompleteBlock;

/**
 *  隐藏弹出视图
 */
- (void)cj_hidePopupView;
/**
 *  隐藏弹出视图
 */
- (void)cj_hidePopupViewWithAnimationType:(CJAnimationType)animationType;

@end

NS_ASSUME_NONNULL_END
