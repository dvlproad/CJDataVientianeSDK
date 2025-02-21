//
//  TSInsertFeedHomeViewController.m
//  CJFoundationDemo
//
//  Created by ciyouzen on 2016/3/26.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import "TSInsertFeedHomeViewController.h"

#import "CJUIKitDemo-Swift.h"


@interface TSInsertFeedHomeViewController () {
    
}
@property (nonatomic, strong) TSFeedAdInsertUtil *feedAdInsertUtil1;
@property (nonatomic, strong) TSFeedAdInsertUtil *feedAdInsertUtil2;

@property (nonatomic, strong) TSFeedAdInsertUtil *feedAdInsertUtil11;
@property (nonatomic, strong) NSMutableArray<TSTempDataModel *> *currentDataModels;


@end

@implementation TSInsertFeedHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"广告流插入测试首页", nil);
    
    self.feedAdInsertUtil1 = [[TSFeedAdInsertUtil alloc] initWithCurrentDataModels:@[] afterEveryRowSteps:@[] remainderEveryRowStep:4 itemCountPerRow:1];
    self.feedAdInsertUtil2 = [[TSFeedAdInsertUtil alloc] initWithCurrentDataModels:@[] afterEveryRowSteps:@[@2] remainderEveryRowStep:1 itemCountPerRow:3];
    
    NSMutableArray *currentDataModels = [[NSMutableArray alloc] init];
    for (int i = 0; i < 50; i++) {
        TSTempDataModel *tempDataModel = [[TSTempDataModel alloc] init];
        [currentDataModels addObject:tempDataModel];
    }
    self.currentDataModels = currentDataModels;
    self.feedAdInsertUtil11 = [[TSFeedAdInsertUtil alloc] initWithCurrentDataModels:self.currentDataModels afterEveryRowSteps:@[@2] remainderEveryRowStep:1 itemCountPerRow:3];
    
    NSMutableArray *sectionDataModels = [[NSMutableArray alloc] init];
    
    // FeedAd
    {
        CQDMSectionDataModel *sectionDataModel = [[CQDMSectionDataModel alloc] init];
        sectionDataModel.theme = @"广告流FeedAd插入相关";
        {
            CQDMModuleModel *dateModule = [[CQDMModuleModel alloc] init];
            dateModule.title = @"广告流FeedAd插入相关--在分页数据中添加";
            dateModule.content = [self.feedAdInsertUtil1 getInsertDescription];
            dateModule.contentLines = 4;
            dateModule.actionBlock = ^{
                [self.feedAdInsertUtil1 insertElementsToAppendArray];
            };
            [sectionDataModel.values addObject:dateModule];
        }
        {
            CQDMModuleModel *dateModule = [[CQDMModuleModel alloc] init];
            dateModule.title = @"广告流FeedAd插入相关--在分页数据中添加";
            dateModule.content = [self.feedAdInsertUtil2 getInsertDescription];
            dateModule.contentLines = 4;
            dateModule.actionBlock = ^{
                [self.feedAdInsertUtil2 insertElementsToAppendArray];
            };
            [sectionDataModel.values addObject:dateModule];
        }
        {
            CQDMModuleModel *dateModule = [[CQDMModuleModel alloc] init];
            dateModule.title = @"广告流FeedAd插入相关--整理自身";
            dateModule.content = [self.feedAdInsertUtil11 getInsertDescription];
            dateModule.contentLines = 4;
            dateModule.actionBlock = ^{
                [self.feedAdInsertUtil11 insertElementsToSelf];
            };
            [sectionDataModel.values addObject:dateModule];
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
