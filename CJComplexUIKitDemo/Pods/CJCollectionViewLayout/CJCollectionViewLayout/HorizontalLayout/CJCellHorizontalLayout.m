//
//  CJCellHorizontalLayout.m
//  CJUIKitDemo
//
//  Created by ciyouzen on 16-5-30.
//  Copyright (c) 2016年 dvlproad. All rights reserved.
//

#import "CJCellHorizontalLayout.h"

@interface CJCellHorizontalLayout() {
    
}
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableDictionary *heigthDic;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributes;
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;

@end



@implementation CJCellHorizontalLayout
{
    NSInteger _maxRowPerPage;     /**< 根据给collectionView的高,得出每页最多有多少行 */
    NSInteger _maxColumnPerPage;  /**< 根据给collectionView的宽,得出每页最多有多少列 */
    CGFloat _actualInteritemSpacing;/**< item之间的实际间隔 */
    CGFloat _actualLineSpacing;     /**< line之间的实际间隔 */
}

/// 水平列间距
- (CGFloat)columnSpacing {
    CGFloat columnSpacing = self.minimumInteritemSpacing;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        columnSpacing = self.minimumLineSpacing;
    }
    return columnSpacing;
}

/// 竖直行间距
- (CGFloat)rowSpacing {
    CGFloat rowSpacing = self.minimumLineSpacing;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        rowSpacing = self.minimumInteritemSpacing;
    }
    return rowSpacing;;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.leftArray = [NSMutableArray new];
        self.heigthDic = [NSMutableDictionary new];
        self.attributes = [NSMutableArray new];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout]; //需调用父类方法
    
    // 获取更多信息(每页最大列数及列之间的真正间距；每页最大行数及行之间的真正间距)
    [self __getMoreInfo];
}

- (void)__getMoreInfo {
    CGFloat itemWidth = self.itemSize.width;
    CGFloat itemHeight = self.itemSize.height;
    
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    
    /* 计算最多列数column和item实际间隔actualInteritemSpacing */
    CGFloat contentWidth = (width - self.sectionInset.left - self.sectionInset.right);
    //x*(itemWidth+columnSpacing) + itemWidth = contentWidth; //x间隙个数
    NSInteger gapCountPerRow = (contentWidth-itemWidth)/(itemWidth+self.columnSpacing);
    NSInteger maxColumnPerPage = gapCountPerRow+1;
    
    
//    maxColumnPerPage = (contentWidth+self.columnSpacing)/(itemWidth+self.columnSpacing);
    
    CGFloat totalResidualIntervalPerRow = contentWidth - maxColumnPerPage*itemWidth;//每行剩余的总间隔
    CGFloat actualInteritemSpacing = 0;
    if (maxColumnPerPage > 1) { // 确保除数非0
        actualInteritemSpacing = totalResidualIntervalPerRow/(maxColumnPerPage-1);
    }
    _maxColumnPerPage = maxColumnPerPage;
    _actualInteritemSpacing = actualInteritemSpacing;

    /* 计算最多行数和line实际间隔actualLineSpacing */
    CGFloat contentHeight = (height - self.sectionInset.top - self.sectionInset.bottom);
    //x*(itemHeight+rowSpacing) + itemHeight = contentHeight; //x间隙个数
    NSInteger gapCountPerColumn = (contentHeight-itemHeight)/(itemHeight+self.rowSpacing);
    NSInteger maxRowPerPage = gapCountPerColumn+1;
    CGFloat totalResidualIntervalPerColumn = contentHeight - maxRowPerPage*itemHeight;//每列剩余的总间隔
    CGFloat actualLineSpacing = 0;
    if (maxRowPerPage > 1) { // 确保除数非0
        actualLineSpacing = totalResidualIntervalPerColumn/(maxRowPerPage-1);
    }
    
    _maxRowPerPage = maxRowPerPage;
    _actualLineSpacing = actualLineSpacing;
    
    int itemNumber = 0;
    itemNumber = itemNumber + (int)[self.collectionView numberOfItemsInSection:0];
    if (itemNumber >= 1) {
        pageNumber = (itemNumber - 1)/(_maxRowPerPage*_maxColumnPerPage) + 1; //每页6个，则6个时候也只有一页(6-1)/6+1
    } else {
        pageNumber = 1;
    }
}

//- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems
//{
//    [super prepareForCollectionViewUpdates:updateItems];
//    NSMutableArray *indexPaths = [NSMutableArray array];
//    for (UICollectionViewUpdateItem *updateItem in updateItems) {
//        switch (updateItem.updateAction) {
//            case UICollectionUpdateActionInsert:
//                [indexPaths addObject:updateItem.indexPathAfterUpdate];
//                break;
//            case UICollectionUpdateActionDelete:
//                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
//                break;
//            
//            case UICollectionUpdateActionMove:
//                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
//                [indexPaths addObject:updateItem.indexPathAfterUpdate];
//                break;
//        
//
//            default:
//                break;
//        }
//    }
//    self.indexPathsToAnimate = indexPaths;
//}

//- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    
//    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
//        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
//        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//        [_indexPathsToAnimate removeObject:itemIndexPath];
//    }
//    
//    return attr;
//}

- (CGPoint)targetContentOffsetForProposedContentOffset: (CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity //自动对齐到网格
{
    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGFloat offsetY = MAXFLOAT;
    CGFloat offsetX = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + self.itemSize.width/2;
    CGFloat verticalCenter = proposedContentOffset.y + self.itemSize.height/2;
    CGRect targetRect = CGRectMake(0, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    CGPoint offPoint = proposedContentOffset;
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        CGFloat itemVerticalCenter = layoutAttributes.center.y;
        if (ABS(itemHorizontalCenter - horizontalCenter) && (ABS(offsetX)>ABS(itemHorizontalCenter - horizontalCenter))) {
            offsetX = itemHorizontalCenter - horizontalCenter;
            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
        }
        if (ABS(itemVerticalCenter - verticalCenter) && (ABS(offsetY)>ABS(itemVerticalCenter - verticalCenter))) {
            offsetY = itemHorizontalCenter - horizontalCenter;
            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
        }
    }
    return offPoint;
}

- (CGSize)collectionViewContentSize
{
    CGFloat pageWidth = self.collectionView.bounds.size.width;
    CGFloat pageHeight = self.collectionView.bounds.size.height;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(pageWidth, pageHeight*pageNumber);
    }
    return CGSizeMake(pageWidth*pageNumber, pageHeight*1);
}


static long  pageNumber = 1;

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /* 计算每个cell的frame */
    NSInteger maxItemCountRowPerPage = _maxRowPerPage * _maxColumnPerPage; //每页最多item个数
    //先计算出item在第几页，及其在所在页中的行和列
    long pageIndexForItem = indexPath.item/maxItemCountRowPerPage; //①当前item在第几页
    
    NSInteger indexForItemInCurrentPage = 0;//②当前item在本页中属于第几个
    if (indexPath.item < maxItemCountRowPerPage) {
        indexForItemInCurrentPage = indexPath.item;
    } else {
        indexForItemInCurrentPage = indexPath.item%maxItemCountRowPerPage;
    }
    
    long columnIndexForItem = 0;    //item在其所在页中所在的列
    long rowIndexForItem = 0;       //③item在其所在页中所在的行
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        columnIndexForItem = indexForItemInCurrentPage/_maxRowPerPage;
        rowIndexForItem = indexPath.item%_maxRowPerPage;
    } else {
        rowIndexForItem = indexForItemInCurrentPage/_maxColumnPerPage;
        columnIndexForItem = indexPath.item%_maxColumnPerPage;
    }
    // item 在第一页的 x 和 y（其他页再额外加上页数偏移）
    CGFloat itemXInPage0 = columnIndexForItem*self.itemSize.width+(columnIndexForItem)*_actualInteritemSpacing+self.sectionInset.left;
    CGFloat itemYInPage0 = rowIndexForItem*self.itemSize.height + (rowIndexForItem)*_actualLineSpacing+self.sectionInset.top;
    
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat pageHeight = self.collectionView.bounds.size.height;
        itemX = itemXInPage0;
        itemY = itemYInPage0 + (indexPath.section+pageIndexForItem)*pageHeight;
    } else {
        CGFloat pageWidth = self.collectionView.bounds.size.width;
        itemX = itemXInPage0 + (indexPath.section+pageIndexForItem)*pageWidth;
        itemY = itemYInPage0;
    }
    
    //利用上面计算的所得值，得到frame
    CGRect frame;
    frame.size = self.itemSize;
    frame.origin = CGPointMake(itemX, itemY);
    
    attribute.frame = frame;
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{

    NSMutableArray *tmpAttributes = [NSMutableArray new];
    for (int j = 0; j < self.collectionView.numberOfSections; j ++)
    {
        NSInteger count = [self.collectionView numberOfItemsInSection:j];
        for (NSInteger i = 0; i < count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            [tmpAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    self.attributes = tmpAttributes;
    return self.attributes;
    
    
}

//- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForInsertedItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    attributes.alpha = 0.0;
////    attributes.center = CGPointMake(_center.x, _center.y);
//    return attributes;
//}

//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDeletedItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes* attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    attributes.alpha = 0.0;
////    attributes.center = CGPointMake(_center.x, _center.y);
//    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
//    return attributes;
//}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
    //return !CGRectEqualToRect(self.collectionView.bounds, newBounds);
}



//- (NSIndexPath *)targetIndexPathForInteractivelyMovingItem:(NSIndexPath *)previousIndexPath withPosition:(CGPoint)position{
//    NSIndexPath *indexpath = [self.collectionView indexPathForItemAtPoint:position];
//    return indexpath;
//}
//- (UICollectionViewLayoutAttributes *)layoutAttributesForInteractivelyMovingItemAtIndexPath:(NSIndexPath *)indexPath withTargetPosition:(CGPoint)position {
//    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForInteractivelyMovingItemAtIndexPath:indexPath withTargetPosition:position];
////    attributes.transform3D = CATransform3DMakeScale(1.2, 1.2, 1.0);
//    attributes.zIndex = 1;
//    NSLog(@"变大");
//    NSIndexPath *tmpPath = [self.collectionView indexPathForItemAtPoint:position];
//    if (tmpPath != indexPath) {
//        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:tmpPath];
//    }
//    
//    return attributes;
//}

//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition {
//    UICollectionViewLayoutInvalidationContext* context = [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
//   
//    return context;
//}
//- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled {
//    UICollectionViewLayoutInvalidationContext* context = [super invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:indexPaths previousIndexPaths:previousIndexPaths movementCancelled:movementCancelled];
////    [self.collectionView insertItemsAtIndexPaths:indexPaths];
//
//    return context;
//}


@end
