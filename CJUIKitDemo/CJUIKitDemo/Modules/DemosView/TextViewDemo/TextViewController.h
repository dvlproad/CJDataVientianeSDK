//
//  TextViewController.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2015/12/23.
//  Copyright © 2015年 dvlproad. All rights reserved.
//

#import "CJUIKitBaseViewController.h"
#import "CJTextView.h"

@interface TextViewController : CJUIKitBaseViewController

@property (nonatomic, weak) IBOutlet CJTextView *textView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;

@end

