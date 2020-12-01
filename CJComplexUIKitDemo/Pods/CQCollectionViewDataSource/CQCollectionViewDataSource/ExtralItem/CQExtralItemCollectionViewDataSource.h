//
//  CQExtralItemCollectionViewDataSource.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2016/11/12.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CJDataSourceSettingModel.h"

/**
 *  tableView只有一种Cell，且tableView不分区时候的dataSoure
 */
@interface CQExtralItemCollectionViewDataSource : NSObject <UICollectionViewDataSource> {
    
}
@property (nonatomic, strong) NSArray *dataModels;
@property (nonatomic, strong, readonly) CJDataSourceSettingModel *dataSourceSettingModel;

/*
 *  初始化dataSource类(初始化完之后，必须在之后设置想要展示的数据dataModels)
 *
 *  @param dataSourceSettingModel           集合视图的数据类
 *  @param cellForItemAtIndexPathBlock          dataSource中的cell(含dataCell和extralCell)进行定制用的block
 */
- (id)initWithDataSourceSettingModel:(CJDataSourceSettingModel *)dataSourceSettingModel
         cellForItemAtIndexPathBlock:(UICollectionViewCell* (^)(UICollectionView *collectionView, NSIndexPath *indexPath, BOOL isExtralItem))cellForItemAtIndexPathBlock;



#pragma mark - Update
/// 更新额外cell的样式即位置，(默认不添加）
- (void)updateExtralItemSetting:(CJExtralItemSetting)extralItemSetting;

/*
 *  dataSoure中indexPath位置的dataModel值
 *
 *  @param indexPath    tableView的indexPath
 */
- (id)dataModelAtIndexPath:(NSIndexPath *)indexPath;

/*
*  判断indexPath是否是非数据即额外加上去的cell（如添加图片的cell）
*
*  @param indexPath     要判断的indexPath
*
*  @return indexPath    是否是非数据即额外加上去的cell（如添加图片的cell）
*/
- (BOOL)isExtraItemIndexPath:(NSIndexPath *)indexPath;

@end
