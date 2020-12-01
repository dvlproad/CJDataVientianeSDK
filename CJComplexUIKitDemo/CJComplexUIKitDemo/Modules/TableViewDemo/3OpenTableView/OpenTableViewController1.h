//
//  OpenTableViewController1.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 8/26/15.
//  Copyright (c) 2015 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CQDemoKit/CQDMSectionDataModel.h>
#import "TableViewHeader.h"


//实际只需采用CJTableViewHeaderFooterView和CQDMSectionDataModel即可实现
@interface OpenTableViewController1 : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CQDMSectionDataModel *> *sectionModels;

@end
