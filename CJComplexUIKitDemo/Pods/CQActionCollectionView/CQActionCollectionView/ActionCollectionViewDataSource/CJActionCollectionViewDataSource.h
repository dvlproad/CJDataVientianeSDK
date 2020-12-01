//
//  CJActionCollectionViewDataSource.h
//  CJUIKitDemo
//
//  Created by ciyouzen on 2016/11/12.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CJActionCollectionViewDataSource;
typedef UICollectionViewCell* (^CQPreSufItemCellAtIndexPathBlock)(CJActionCollectionViewDataSource *bDataSource, UICollectionView *collectionView, NSIndexPath *indexPath);

/**
 *  tableView只有一种Cell，且tableView不分区时候的dataSoure
 */
@interface CJActionCollectionViewDataSource : NSObject <UICollectionViewDataSource> {
    
}
@property (nonatomic, strong) NSMutableArray *dataModels;
@property (nonatomic, assign, readonly) NSInteger currentCanMaxAddCount;  /**< 当前剩余最多可添加多少个 */

/*
 *  初始化dataSource类(初始化完之后，必须在之后设置想要展示的数据dataModels)
 *
 *  @param maxDataModelShowCount        最大显示的dataModel数目
 *  @param cellForPrefixBlock           头部prefixCell定制用的block
 *  @param cellForSuffixBlock           尾部suffixCell定制用的block
 *  @param cellForItemBlock             数据cell定制用的block
 *  @param getItemCountBlock            获取item个数的回调
 */
- (id)initWithMaxShowCount:(NSUInteger)maxDataModelShowCount
        cellForPrefixBlock:(CQPreSufItemCellAtIndexPathBlock)cellForPrefixBlock
        cellForSuffixBlock:(CQPreSufItemCellAtIndexPathBlock)cellForSuffixBlock
          cellForItemBlock:(CQPreSufItemCellAtIndexPathBlock)cellForItemBlock
//         getItemCountBlock:(NSInteger(^)(void))getItemCountBlock
            NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/*
*  IndexPath 位置的 itemIndex 是多少(如果为-1，则代表不是item的位置)
*
*  @param indexPath    collectionView的indexPath
*/
- (NSInteger)itemIndexByIndexPath:(NSIndexPath *)indexPath;


/*
 *  dataSoure中indexPath位置的dataModel值
 *
 *  @param indexPath    tableView的indexPath
 */
- (id)dataModelAtIndexPath:(NSIndexPath *)indexPath;


///删除第几张图片
- (BOOL)deletePhotoAtIndexPath:(NSIndexPath *)indexPath;


@end
