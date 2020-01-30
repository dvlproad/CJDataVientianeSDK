//
//  CJMessageAlertView.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2018/9/27.
//  Copyright © 2018年 dvlproad. All rights reserved.
//

#import "CJMessageAlertView.h"
//#import <CJFoundation/NSString+CJTextSize.h>
//#import <CJBaseUIKit/UIButton+CJMoreProperty.h>
//#import <CJBaseUIKit/UIColor+CJHex.h>
#import "CJThemeManager.h"

@interface CJMessageAlertView () {
    
}
@property (nonatomic, assign, readonly) CGSize imageViewSize;
@property (nonatomic, assign, readonly) CGFloat titleLabelLeftOffset;
@property (nonatomic, assign, readonly) CGFloat messageLabelLeftOffset;
@property (nonatomic, assign, readonly) CGFloat bottomButtonsLeftOffset;

@end



@implementation CJMessageAlertView

- (instancetype)initWithFlagImage:(UIImage *)flagImage
                            title:(NSString *)title
                          message:(NSString *)message
                    okButtonTitle:(NSString *)okButtonTitle
                         okHandle:(void(^)(void))okHandle
{
    self = [super init];
    if (self) {
        CJAlertThemeModel *alertThemeModel = [CJThemeManager serviceThemeModel].alertThemeModel;
        
        // flagImage、title、message
        [self __commonSetupWithAlertThemeModel:alertThemeModel flagImage:flagImage title:title message:message];
        
        // buttons
        _bottomButtonsLeftOffset = alertThemeModel.bottomButtonsLeftOffset;
        [self addOnlyOneBottomButtonWithOKButtonTitle:okButtonTitle okHandle:okHandle];
        
        // 设置布局约束
        [self __setupConstraints];
    }
    return self;
}

- (instancetype)initWithFlagImage:(UIImage *)flagImage
                            title:(NSString *)title
                          message:(NSString *)message
                cancelButtonTitle:(NSString *)cancelButtonTitle
                    okButtonTitle:(NSString *)okButtonTitle
                     cancelHandle:(void(^)(void))cancelHandle
                         okHandle:(void(^)(void))okHandle
{
    self = [super init];
    if (self) {
        CJAlertThemeModel *alertThemeModel = [CJThemeManager serviceThemeModel].alertThemeModel;
        
        // flagImage、title、message
        [self __commonSetupWithAlertThemeModel:alertThemeModel flagImage:flagImage title:title message:message];
        
        // buttons
        _bottomButtonsLeftOffset = alertThemeModel.bottomButtonsLeftOffset;
        [super addTwoButtonsWithCancelButtonTitle:cancelButtonTitle okButtonTitle:okButtonTitle cancelHandle:cancelHandle okHandle:okHandle];
        
        // 设置布局约束
        [self __setupConstraints];
    }
    return self;
}

- (void)__commonSetupWithAlertThemeModel:(CJAlertThemeModel *)alertThemeModel
                               flagImage:(UIImage *)flagImage
                                   title:(NSString *)title
                                 message:(NSString *)message
{
    self.layer.cornerRadius = 14;
    self.backgroundColor = CJColorFromHexString(alertThemeModel.backgroundColor);
    self.clipsToBounds = YES;
    
    CGSize popupViewSize = CGSizeMake(alertThemeModel.alertWidth, 150);
    self.size = popupViewSize;
    
    // flagImage
    _imageViewSize = flagImage.size;
    [self addFlagImage:flagImage size:self.imageViewSize];
    
    //title
    _titleLabelLeftOffset = alertThemeModel.titleLabelLeftOffset;
    [super addTitle:title margin:self.titleLabelLeftOffset];
    
    //message
    _messageLabelLeftOffset = alertThemeModel.messageLabelLeftOffset;
    [self addMessage:message margin:self.messageLabelLeftOffset];
}

///添加指示图标
- (void)addFlagImage:(UIImage *)flagImage size:(CGSize)imageViewSize {
    if (_flagImageView == nil && flagImage != nil) {
        UIImageView *flagImageView = [CJAlertComponentFactory flagImage:flagImage];
        [self addSubview:flagImageView];
        
        _flagImageView = flagImageView;
    }
    
    _flagImageViewHeight = imageViewSize.height;
}

- (void)addMessage:(NSString *)message margin:(CGFloat)messageLabelLeftOffset {
    
    if (message.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.lineSpacing = 3;
        paragraphStyle.firstLineHeadIndent = 10;
//        [self addMessageWithText:message font:[UIFont systemFontOfSize:15.0] textAlignment:NSTextAlignmentCenter margin:messageLabelLeftOffset paragraphStyle:paragraphStyle];
        CGFloat messageLabelMaxWidth = self.size.width - 2*messageLabelLeftOffset;
        CJAlertMessageLableModel *messageLabelModel = [CJAlertComponentFactory messageLabelWithText:message
                                                                                               font:[UIFont systemFontOfSize:15.0]
                                                                                      textAlignment:NSTextAlignmentCenter
                                                                               messageLabelMaxWidth:messageLabelMaxWidth
                                                                                     paragraphStyle:paragraphStyle];
        self.messageScrollView = messageLabelModel.messageScrollView;
        self.messageLabel = messageLabelModel.messageLabel;
        self.messageLabelHeight = messageLabelModel.messageTextHeight;
        
        [self addSubview:self.messageScrollView];
    }
    
}


///添加 message 的边框等(几乎不会用到)
- (void)addMessageLayerWithBorderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor cornerRadius:(CGFloat)cornerRadius {
    NSAssert(self.messageScrollView, @"请先添加messageScrollView");
    
    self.messageScrollView.layer.borderWidth = borderWidth;
    
    if (borderColor) {
        self.messageScrollView.layer.borderColor = borderColor;
    }
    
    self.messageScrollView.layer.cornerRadius = cornerRadius;
}

///更改 Message 文字颜色
- (void)updateMessageTextColor:(UIColor *)textColor {
    self.messageLabel.textColor = textColor;
}


///获取当前alertView最小应有的高度值，处信息之外
- (CGFloat)getMinHeightExpectMessageLabel {
    CGFloat minHeightWithoutMessageLabel = self.totalMarginVertical + self.flagImageViewHeight + self.titleLabelHeight + self.bottomPartHeight;
    minHeightWithoutMessageLabel = ceil(minHeightWithoutMessageLabel);
    
    return minHeightWithoutMessageLabel;
}

///获取当前alertView最小应有的高度值
- (CGFloat)getMinHeight {
    CGFloat minHeightWithoutMessageLabel = [self getMinHeightExpectMessageLabel];
    CGFloat minHeight = minHeightWithoutMessageLabel + self.messageLabelHeight;
    
    return minHeight;
}

- (void)showWithShouldFitHeight:(BOOL)shouldFitHeight blankBGColor:(UIColor *)blankBGColor
{
    CGFloat fixHeight = 0;
    if (shouldFitHeight) {
        CGFloat minHeight = [self getMinHeight];
        fixHeight = minHeight;
    } else {
        fixHeight = self.size.height;
    }

    [self showWithFixHeight:fixHeight blankBGColor:blankBGColor];
}

/**
 *  显示弹窗并且是以指定高度显示的
 *
 *  @param fixHeight        高度
 *  @param blankBGColor     空白区域的背景颜色
 */
- (void)showWithFixHeight:(CGFloat)fixHeight blankBGColor:(UIColor *)blankBGColor {
    CGFloat minHeightWithoutMessageLabel = [self getMinHeightExpectMessageLabel];
    CGFloat minHeight = minHeightWithoutMessageLabel + self.messageLabelHeight;
    if (fixHeight < minHeight) {
        NSString *warningString = [NSString stringWithFormat:@"CJ警告：您设置的size高度小于视图本身的最小高度%.2lf，会导致视图显示不全，请检查", minHeight];
        NSLog(@"%@", warningString);
    }
    
    CGFloat maxHeight = CGRectGetHeight([UIScreen mainScreen].bounds) - 200;
    if (fixHeight > maxHeight) {
        fixHeight = maxHeight;
        
        //NSString *warningString = [NSString stringWithFormat:@"CJ警告：您设置的size高度超过视图本身的最大高度%.2lf，会导致视图显示不全，已自动缩小", maxHeight];
        //NSLog(@"%@", warningString);
        if (self.messageScrollView) {
            _messageLabelHeight = fixHeight - minHeightWithoutMessageLabel;
            [self.messageScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self->_messageLabelHeight);
            }];
        }
    }
    
    CGSize popupViewSize = CGSizeMake(self.size.width, fixHeight);
    [self showPopupViewSize:popupViewSize];
}


#pragma mark - Private Method
- (void)__setupConstraints
{
    // alert 竖直上的间距:alertMarginVertical
    NSArray *alertMarginVerticals = @[@0, @0, @0, @0];
    NSInteger flagImageVerticalIndex = -1;
    NSInteger titleVerticalIndex = -1;
    NSInteger messageVerticalIndex = -1;
    NSInteger buttonsVerticalIndex = -1;
    if (self.flagImageView) {
        alertMarginVerticals = [CJThemeManager serviceThemeModel].alertThemeModel.marginVertical_flagImage_title_message_buttons;
        flagImageVerticalIndex = 0;
        titleVerticalIndex = 1;
        messageVerticalIndex = 2;
        buttonsVerticalIndex = 3;
    } else {
        if (self.titleLabel) {
            if (self.messageLabel) {
                alertMarginVerticals = [CJThemeManager serviceThemeModel].alertThemeModel.marginVertical_title_message_buttons;
                flagImageVerticalIndex = -1;
                titleVerticalIndex = 0;
                messageVerticalIndex = 1;
                buttonsVerticalIndex = 2;
            } else {
                alertMarginVerticals = [CJThemeManager serviceThemeModel].alertThemeModel.marginVertical_title_buttons;
                flagImageVerticalIndex = -1;
                titleVerticalIndex = 0;
                messageVerticalIndex = -1;
                buttonsVerticalIndex = 1;
            }
        } else {
            alertMarginVerticals = [CJThemeManager serviceThemeModel].alertThemeModel.marginVertical_message_buttons;
            flagImageVerticalIndex = -1;
            titleVerticalIndex = -1;
            messageVerticalIndex = 0;
            buttonsVerticalIndex = 1;
        }
    }
    
    for (NSInteger i = 0; i <= buttonsVerticalIndex; i++) {
        NSNumber *marginVertical = alertMarginVerticals[i];
        self.totalMarginVertical += [marginVertical floatValue];
    }
    
    
    if (self.flagImageView) {
        NSNumber *flagImageMarginTop = alertMarginVerticals[flagImageVerticalIndex];
        [self.flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self.imageViewSize.width);
            make.top.mas_equalTo(self).mas_offset(flagImageMarginTop);
            make.height.mas_equalTo(self.imageViewSize.height);
        }];
    }
    
    if (self.titleLabel) {
        CGFloat titleTextHeight = self.titleLabelHeight;
        NSNumber *titleMarginTop = alertMarginVerticals[titleVerticalIndex];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.left.mas_equalTo(self).mas_offset(self.titleLabelLeftOffset);
            if (self.flagImageView) {
                make.top.mas_equalTo(self.flagImageView.mas_bottom).mas_offset(titleMarginTop);
            } else {
                make.top.mas_greaterThanOrEqualTo(self).mas_offset(titleMarginTop);//优先级
            }
            make.height.mas_equalTo(titleTextHeight);
        }];
    }
    
    
    if (self.messageScrollView) {
        CGFloat messageTextHeight = self.messageLabelHeight;
        NSNumber *messageMarginTop = alertMarginVerticals[messageVerticalIndex];
        [self.messageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.left.mas_equalTo(self).mas_offset(self.messageLabelLeftOffset);
            if (self.titleLabel) {
                if (self.flagImageView) {
                    make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(messageMarginTop);
                } else {
                    make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(messageMarginTop);
                }
            } else if (self.flagImageView) {
                make.top.mas_greaterThanOrEqualTo(self.flagImageView.mas_bottom).mas_offset(messageMarginTop);//优先级
            } else {
                make.top.mas_greaterThanOrEqualTo(self).mas_offset(messageMarginTop);//优先级
            }
            
            make.height.mas_equalTo(messageTextHeight);
        }];
    }
    
    NSNumber *buttonMarginTop = alertMarginVerticals[buttonsVerticalIndex];
    NSNumber *buttonMarginBottom = alertMarginVerticals[buttonsVerticalIndex+1];
    CGFloat actionButtonHeight = 45;
    [self.bottomButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(buttonMarginTop);
        make.bottom.mas_equalTo(-[buttonMarginBottom floatValue]);
        make.height.mas_equalTo(actionButtonHeight);
        make.left.mas_equalTo(self).mas_offset(self.bottomButtonsLeftOffset);
        make.centerX.mas_equalTo(self);
    }];
}


@end