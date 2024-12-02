//
//  FoundationHomeViewController.m
//  CJFoundationDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "FoundationHomeViewController.h"

// String
#import "StringHomeViewController.h"

#import "DateViewController.h"
#import "TypeConvertViewController.h"

#import "CJUIKitDemo-Swift.h"


@interface FoundationHomeViewController ()

@end

@implementation FoundationHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Home首页", nil);
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    //NSString
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"NSString相关";
        {
            CQDMModuleModel *NSStringModule = [[CQDMModuleModel alloc] init];
            NSStringModule.title = @"String";
            NSStringModule.classEntry = [StringHomeViewController class];
            [sectionDataModel.values addObject:NSStringModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    
    //NSDate
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"NSDate相关";
        {
            CQDMModuleModel *NSDateModule = [[CQDMModuleModel alloc] init];
            NSDateModule.title = @"NSDate";
            NSDateModule.classEntry = [DateViewController class];
            [sectionDataModel.values addObject:NSDateModule];
        }
        {
            CQDMModuleModel *NSDateModule = [[CQDMModuleModel alloc] init];
            NSDateModule.title = @"NSDate农历格式";
            NSDateModule.actionBlock = ^{
                [[TestSwift1 new] printLunarDateString];
            };
            [sectionDataModel.values addObject:NSDateModule];
        }
        
        // 示例调用
        {
            CQDMModuleModel *NSDateModule = [[CQDMModuleModel alloc] init];
            NSDateModule.title = @"NSDate是否有闰月";
            NSDateModule.actionBlock = ^{
                [[TestSwift1 new] getLeapMonth];
            };
            [sectionDataModel.values addObject:NSDateModule];
        }
        {
            CQDMModuleModel *NSDateModule = [[CQDMModuleModel alloc] init];
            NSDateModule.title = @"NSDate农历：下个月的月份是否和本月相等，即下个月是否是闰月";
            NSDateModule.actionBlock = ^{
                [[TestSwift1 new] isNextLunarMonthEqual];
            };
            [sectionDataModel.values addObject:NSDateModule];
        }
        {
            CQDMModuleModel *NSDateModule = [[CQDMModuleModel alloc] init];
            NSDateModule.title = @"NSDate农历：找下一个月与之相等的农历日期";
            NSDateModule.actionBlock = ^{
                [[TestSwift1 new] findNextEqualLunarDate];
            };
            [sectionDataModel.values addObject:NSDateModule];
        }
        {
            CQDMModuleModel *NSDateModule = [[CQDMModuleModel alloc] init];
            NSDateModule.title = @"NSDate每周重复";
            NSDateModule.actionBlock = ^{
                [[TestSwift1 new] getNextRepateDate_week];
            };
            [sectionDataModel.values addObject:NSDateModule];
        }
        {
            CQDMModuleModel *NSDateModule = [[CQDMModuleModel alloc] init];
            NSDateModule.title = @"NSDate每月重复";
            NSDateModule.actionBlock = ^{
                [[TestSwift1 new] getNextRepateDate_month];
            };
            [sectionDataModel.values addObject:NSDateModule];
        }
        {
            CQDMModuleModel *NSDateModule = [[CQDMModuleModel alloc] init];
            NSDateModule.title = @"NSDate每年周期";
            NSDateModule.actionBlock = ^{
                [[TestSwift1 new] getNextRepateDate_year];
            };
            [sectionDataModel.values addObject:NSDateModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    //Json-Model类型转换
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"Json-Model类型转换相关";
        {
            //TypeConvert
            CQDMModuleModel *TypeConvertModule = [[CQDMModuleModel alloc] init];
            TypeConvertModule.title = @"TypeConvertModule（类型转换）";
            TypeConvertModule.classEntry = [TypeConvertViewController class];
            [sectionDataModel.values addObject:TypeConvertModule];
        }
        
        [sectionDataModels addObject:sectionDataModel];
    }
    
    self.sectionDataModels = sectionDataModels;
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
