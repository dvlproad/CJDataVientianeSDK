//
//  TestDataUtil.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 2016/11/12.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TestDataUtil.h"

@implementation TestDataUtil

/** 完整的描述请参见文件头部 */
+ (NSMutableArray<CQDMSectionDataModel *> *)getTestSectionDataModels {
    CQDMSectionDataModel *secctionModel1 = [[CQDMSectionDataModel alloc] init];
    secctionModel1.theme = @"A区";
    secctionModel1.values = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 5; i++) {
        TestDataModel *cellModel = [[TestDataModel alloc]init];
        cellModel.name = [NSString stringWithFormat:@"%ld", 10+i];
        [secctionModel1.values addObject:cellModel];
    }
    secctionModel1.selected = YES;
    
    
    CQDMSectionDataModel *secctionModel2 = [[CQDMSectionDataModel alloc]init];
    secctionModel2.theme = @"B区";
    secctionModel2.values = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 3; i++) {
        TestDataModel *cellModel = [[TestDataModel alloc]init];
        cellModel.name = [NSString stringWithFormat:@"%ld", 20+i];
        [secctionModel2.values addObject:cellModel];
    }
    secctionModel2.selected = YES;
    
    CQDMSectionDataModel *secctionModel3 = [[CQDMSectionDataModel alloc]init];
    secctionModel3.theme = @"C区";
    secctionModel3.values = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 4; i++) {
        TestDataModel *cellModel = [[TestDataModel alloc]init];
        cellModel.name = [NSString stringWithFormat:@"%ld", 30+i];
        [secctionModel3.values addObject:cellModel];
    }
    secctionModel3.selected = YES;
    
    NSMutableArray *secctionModels = [NSMutableArray arrayWithArray:@[secctionModel1, secctionModel2, secctionModel3]];
    return secctionModels;
}

//typedef NS_ENUM(NSInteger, UITableViewCellStyle) {
//    UITableViewCellStyleDefault,    // Simple cell with text label and optional image view (behavior of UITableViewCell in iPhoneOS 2.x)
//    UITableViewCellStyleValue1,        // Left aligned label on left and right aligned label on right with blue text (Used in Settings)
//    UITableViewCellStyleValue2,        // Right aligned label on left with blue text and left aligned label on right (Used in Phone/Contacts)
//    UITableViewCellStyleSubtitle    // Left aligned label on top and left aligned label on bottom with gray text (Used in iPod).
//};             // available in iPhone OS 3.0

/** 完整的描述请参见文件头部 */
+ (NSMutableArray<CQDMSectionDataModel *> *)testDataForDemoTableViewController {
    //secctionModel1
    CQDMSectionDataModel *secctionModel1 = [[CQDMSectionDataModel alloc] init];
    secctionModel1.type = UITableViewCellStyleDefault;
    secctionModel1.theme = @"CJBaseTableViewCell_Default";
    secctionModel1.values = [[NSMutableArray alloc]init];
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"00";
        dataModel.nickname = @"111";
        [secctionModel1.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"01";
        dataModel.nickname = @"1111";
        [secctionModel1.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"02";
        dataModel.nickname = @"1111";
        [secctionModel1.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"03";
        dataModel.nickname = @"1111";
        [secctionModel1.values addObject:dataModel];
    }
    
    //secctionModel2
    CQDMSectionDataModel *secctionModel2 = [[CQDMSectionDataModel alloc] init];
    secctionModel2.type = UITableViewCellStyleValue1;
    secctionModel2.theme = @"CJBaseTableViewCell_Value1";
    secctionModel2.values = [[NSMutableArray alloc]init];
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"10";
        dataModel.nickname = @"1111";
        [secctionModel2.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"11";
        dataModel.nickname = @"1111";
        [secctionModel2.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"12";
        dataModel.nickname = @"1111";
        [secctionModel2.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"13";
        dataModel.nickname = @"1111";
        [secctionModel2.values addObject:dataModel];
    }
    
    //secctionModel3
    CQDMSectionDataModel *secctionModel3 = [[CQDMSectionDataModel alloc] init];
    secctionModel3.type = UITableViewCellStyleValue2;
    secctionModel3.theme = @"CJBaseTableViewCell_Value2";
    secctionModel3.values = [[NSMutableArray alloc]init];
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"20";
        dataModel.nickname = @"1111";
        [secctionModel3.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"21";
        dataModel.nickname = @"1111";
        [secctionModel3.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"22";
        dataModel.nickname = @"1111";
        [secctionModel3.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"23";
        dataModel.nickname = @"1111";
        [secctionModel3.values addObject:dataModel];
    }
    
    //secctionModel4
    CQDMSectionDataModel *secctionModel4 = [[CQDMSectionDataModel alloc] init];
    secctionModel4.type = UITableViewCellStyleSubtitle;
    secctionModel4.theme = @"CJBaseTableViewCell_Subtitle";
    secctionModel4.values = [[NSMutableArray alloc]init];
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"30";
        dataModel.nickname = @"1111";
        [secctionModel4.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"31";
        dataModel.nickname = @"1111";
        [secctionModel4.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"32";
        dataModel.nickname = @"1111";
        [secctionModel4.values addObject:dataModel];
    }
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"33";
        dataModel.nickname = @"1111";
        [secctionModel4.values addObject:dataModel];
    }
    
    //secctionModel5
    CQDMSectionDataModel *secctionModel5 = [[CQDMSectionDataModel alloc] init];
    secctionModel5.theme = @"UITableViewCellStyleDefault";
    secctionModel5.values = [[NSMutableArray alloc]init];
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"40";
        dataModel.nickname = @"1111";
        [secctionModel5.values addObject:dataModel];
    }
    
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"41";
        dataModel.nickname = @"1111";
        [secctionModel5.values addObject:dataModel];
    }
    
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"42";
        dataModel.nickname = @"1111";
        [secctionModel5.values addObject:dataModel];
    }
    
    {
        TestDataModel *dataModel = [[TestDataModel alloc] init];
        dataModel.name = @"43";
        dataModel.nickname = @"1111";
        [secctionModel5.values addObject:dataModel];
    }
    
    NSMutableArray *secctionModels = [NSMutableArray arrayWithObjects:secctionModel1, secctionModel2, secctionModel3, secctionModel4, secctionModel5, nil];
    return secctionModels;
}

@end
