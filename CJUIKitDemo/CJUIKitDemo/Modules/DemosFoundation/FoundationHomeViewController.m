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


@interface FoundationHomeViewController () {
    
}
@property (nonatomic, strong) CQDMModuleModel *recoveDateModule;

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
            CQDMModuleModel *dateModule = [[CQDMModuleModel alloc] init];
            dateModule.title = @"NSDate日期与字符串转换";
            dateModule.content = @"24小时制下标准保存，24制/12制下恢复";
            dateModule.actionBlock = ^{
                [TSDateFormatterUtil testRecover24DateIn12];
            };
            [sectionDataModel.values addObject:dateModule];
        }
        {
            CQDMModuleModel *dateModule = [[CQDMModuleModel alloc] init];
            dateModule.title = @"NSDate日期与字符串转换";
            dateModule.content = @"12小时制下标准保存，12制/24制下恢复";
            dateModule.actionBlock = ^{
                [TSDateFormatterUtil testRecover12DateIn24];
            };
            [sectionDataModel.values addObject:dateModule];
        }
        
        {
            CQDMModuleModel *dateModule = [[CQDMModuleModel alloc] init];
            dateModule.title = @"NSDate日期与字符串转换：保存";
            dateModule.content = @"24小时制下保存，12制下恢复";
            dateModule.actionBlock = ^{
                NSDate *testDate = [TSDateFormatterUtil createTestDate];
                NSString *needRecoverString = [TSDateFormatterUtil testyyyyMMddHHmmssString_from_date:testDate];
                self.recoveDateModule.content = [NSString stringWithFormat:@"24小时制下保存，12制下恢复\n待恢复：%@", needRecoverString];
                [self.tableView reloadData];
            };
            [sectionDataModel.values addObject:dateModule];
        }
        {
            CQDMModuleModel *dateModule = [[CQDMModuleModel alloc] init];
            dateModule.title = @"NSDate日期与字符串转换：恢复";
            dateModule.content = @"24小时制下保存，12制下恢复";
            dateModule.contentLines = 3;
            dateModule.actionBlock = ^{
                NSString *recoverDateString = [TSDateFormatterUtil test_Date_from_yyyyMMddHHmmssString];
                NSString *currentContentString = self.recoveDateModule.content;
                NSArray<NSString *> *components = [currentContentString componentsSeparatedByString:@"\n"];
                if (components.count > 2) {
                    NSArray *firstTwoComponents = [components subarrayWithRange:NSMakeRange(0, 2)];
                    currentContentString = [firstTwoComponents componentsJoinedByString:@"\n"];
                }
                self.recoveDateModule.content = [NSString stringWithFormat:@"%@\n恢复成：%@", currentContentString, recoverDateString];
                [self.tableView reloadData];
            };
            [sectionDataModel.values addObject:dateModule];
            self.recoveDateModule = dateModule;
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
