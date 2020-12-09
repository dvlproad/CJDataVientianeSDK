//
//  AccuracyStringViewController.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2017/12/29.
//  Copyright © 2017年 dvlproad. All rights reserved.
//

#import "AccuracyStringViewController.h"
#import "CJDecimalUtil.h"

typedef NS_ENUM(NSUInteger, ValidateStringType) {
    ValidateStringTypeNone = 0,     /**< 不验证 */
    ValidateStringTypeEmail,        /**< 邮箱 */
    ValidateStringTypePhone,        /**< 手机号码 */
    ValidateStringTypeCarNo,        /**< 车牌号 */
    ValidateStringTypeCarType,      /**< 车型 */
    ValidateStringTypeUserName,     /**< 用户名 */
    ValidateStringTypePassword,     /**< 密码 */
    ValidateStringTypeNickname,     /**< 昵称 */
    ValidateStringTypeIdentityCard, /**< 身份证号 */
};

@interface AccuracyStringViewController ()

@end

@implementation AccuracyStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"数值处理(取整、去尾0等)", nil);
    self.fixCellResultLableWidth = 120;  // 固定result的视图宽度（该值大于20才生效），默认为0<20，表示自适应宽度
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    // 去除小数部分的尾部多余0的显示
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"去除小数部分的尾部多余0的显示";
        sectionDataModel.values = [self dealTextModels_removeDecimalFractionZero];
        
        [sectionDataModels addObject:sectionDataModel];
    }
    // 精确到百分位(向上取整、向下取整、四舍五入)
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"精确到百分位(向上取整、向下取整、四舍五入)";
        sectionDataModel.values = [self dealTextModels_accurateToHundredth];
        
        [sectionDataModels addObject:sectionDataModel];
    }
    // 精确到个位(向上取整、向下取整、四舍五入)
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"精确到个位(向上取整、向下取整、四舍五入)";
        sectionDataModel.values = [self dealTextModels_accurateToUnit];
        
        [sectionDataModels addObject:sectionDataModel];
    }
    // 精确到百位(向上取整、向下取整、四舍五入)
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"精确到百位(向上取整、向下取整、四舍五入)";
        sectionDataModel.values = [self dealTextModels_accurateToHundred];
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    self.sectionDataModels = sectionDataModels;
}

#pragma mark - 去除小数部分的尾部多余0的显示
/// 去除小数部分的尾部多余0的显示
- (NSMutableArray<CJDealTextModel *> *)dealTextModels_removeDecimalFractionZero {
    NSMutableArray<CJDealTextModel *> *dealTextModels = [[NSMutableArray alloc] init];
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"0.090222120000";
        dealTextModel.hopeResultText = @"0.09022212";
        dealTextModel.actionTitle = @"去除小数部分的尾部多余0的显示";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            NSString *lastNumberString = [CJDecimalUtil removeDecimalFractionZeroForNumberString:oldString];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"0.0900";
        dealTextModel.hopeResultText = @"0.09";
        dealTextModel.actionTitle = @"去除小数部分的尾部多余0的显示";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            NSString *lastNumberString = [CJDecimalUtil removeDecimalFractionZeroForNumberString:oldString];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"10.00";
        dealTextModel.hopeResultText = @"10";
        dealTextModel.actionTitle = @"去除小数部分的尾部多余0的显示";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            NSString *lastNumberString = [CJDecimalUtil removeDecimalFractionZeroForNumberString:oldString];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    
    return dealTextModels;
}


#pragma mark - 精确到百分位(向上取整、向下取整、四舍五入)
/// 精确到百分位(向上取整、向下取整、四舍五入)
- (NSMutableArray<CJDealTextModel *> *)dealTextModels_accurateToHundredth {
    NSInteger decimalPlaces = -2;
    NSMutableArray<CJDealTextModel *> *dealTextModels = [[NSMutableArray alloc] init];
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"9.555";
        dealTextModel.hopeResultText = @"9.56";
        dealTextModel.actionTitle = @"精确到百分位,向上取整";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            NSString *lastNumberString = [CJDecimalUtil stringValueFromSValue:oldString accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeCeil];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"9.555";
        dealTextModel.hopeResultText = @"9.55";
        dealTextModel.actionTitle = @"精确到百分位,向下取整";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            NSString *lastNumberString = [CJDecimalUtil stringValueFromSValue:oldString accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeFloor];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"9.555";
        dealTextModel.hopeResultText = @"9.56";
        dealTextModel.actionTitle = @"精确到百分位,四舍五入";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            NSString *lastNumberString = [CJDecimalUtil stringValueFromSValue:oldString accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeRound];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"9.554";
        dealTextModel.hopeResultText = @"9.55";
        dealTextModel.actionTitle = @"精确到百分位,四舍五入";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            NSString *lastNumberString = [CJDecimalUtil stringValueFromSValue:oldString accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeRound];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    
    return dealTextModels;
}

- (NSString *(^)(NSString *oldString))actionTextBlockForAccurateToDecimalPlaces:(NSInteger)decimalPlaces
                                        decimalDealType:(CJDecimalDealType)decimalDealType
{
    NSString *(^actionTextBlock)(NSString *) = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
        NSString *lastNumberString = [CJDecimalUtil stringValueFromSValue:oldString
                                                  accurateToDecimalPlaces:decimalPlaces
                                                          decimalDealType:decimalDealType];
        return lastNumberString;
    };
    
    return actionTextBlock;
}

#pragma mark - 精确到个位(向上取整、向下取整、四舍五入)
/// 精确到个位(向上取整、向下取整、四舍五入)
- (NSMutableArray<CJDealTextModel *> *)dealTextModels_accurateToUnit {
    NSInteger decimalPlaces = 1;
    NSMutableArray<CJDealTextModel *> *dealTextModels = [[NSMutableArray alloc] init];
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"99.45";
        dealTextModel.hopeResultText = @"100";
        dealTextModel.actionTitle = @"精确到个位,向上取整";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            CGFloat originNumber = [oldString floatValue];
            NSInteger lastNumber = [CJDecimalUtil floatValueFromFValue:originNumber accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeCeil];
            
            NSString *lastNumberString = [NSString stringWithFormat:@"%zd", lastNumber];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"99.45";
        dealTextModel.hopeResultText = @"99";
        dealTextModel.actionTitle = @"精确到个位,向下取整";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            CGFloat originNumber = [oldString floatValue];
            NSInteger lastNumber = [CJDecimalUtil floatValueFromFValue:originNumber accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeFloor];
            
            NSString *lastNumberString = [NSString stringWithFormat:@"%zd", lastNumber];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"99.45";
        dealTextModel.hopeResultText = @"99";
        dealTextModel.actionTitle = @"精确到个位,四舍五入";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            CGFloat originNumber = [oldString floatValue];
            NSInteger lastNumber = [CJDecimalUtil floatValueFromFValue:originNumber accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeRound];
            
            NSString *lastNumberString = [NSString stringWithFormat:@"%zd", lastNumber];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"99.54";
        dealTextModel.hopeResultText = @"100";
        dealTextModel.actionTitle = @"精确到个位,四舍五入";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            CGFloat originNumber = [oldString floatValue];
            NSInteger lastNumber = [CJDecimalUtil floatValueFromFValue:originNumber accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeRound];
            
            NSString *lastNumberString = [NSString stringWithFormat:@"%zd", lastNumber];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    
    return dealTextModels;
}

#pragma mark - 精确到百位(向上取整、向下取整、四舍五入)
/// 精确到百位(向上取整、向下取整、四舍五入)
- (NSMutableArray<CJDealTextModel *> *)dealTextModels_accurateToHundred {
    NSInteger decimalPlaces = 3;
    NSMutableArray<CJDealTextModel *> *dealTextModels = [[NSMutableArray alloc] init];
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"1121";
        dealTextModel.hopeResultText = @"1200";
        dealTextModel.actionTitle = @"精确到百位,向上取整";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            CGFloat originNumber = [oldString floatValue];
            NSInteger lastNumber = [CJDecimalUtil floatValueFromFValue:originNumber accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeCeil];
            
            NSString *lastNumberString = [NSString stringWithFormat:@"%zd", lastNumber];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"1121";
        dealTextModel.hopeResultText = @"1100";
        dealTextModel.actionTitle = @"精确到百位,向下取整";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            CGFloat originNumber = [oldString floatValue];
            NSInteger lastNumber = [CJDecimalUtil floatValueFromFValue:originNumber accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeFloor];
            
            NSString *lastNumberString = [NSString stringWithFormat:@"%zd", lastNumber];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    {
        CJDealTextModel *dealTextModel = [[CJDealTextModel alloc] init];
        dealTextModel.placeholder = @"请输入要验证的值";
        dealTextModel.text = @"1121";
        dealTextModel.hopeResultText = @"1100";
        dealTextModel.actionTitle = @"精确到百位,四舍五入";
        dealTextModel.autoExec = YES;
        dealTextModel.actionBlock = ^NSString * _Nonnull(NSString * _Nonnull oldString) {
            CGFloat originNumber = [oldString floatValue];
            NSInteger lastNumber = [CJDecimalUtil floatValueFromFValue:originNumber accurateToDecimalPlaces:decimalPlaces decimalDealType:CJDecimalDealTypeRound];
            
            NSString *lastNumberString = [NSString stringWithFormat:@"%zd", lastNumber];
            return lastNumberString;
        };
        [dealTextModels addObject:dealTextModel];
    }
    
    return dealTextModels;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
