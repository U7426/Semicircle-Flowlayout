//
//  AdsorbFollowLayout.m
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/21.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import "AdsorbFollowLayout.h"

@implementation AdsorbFollowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    // 设置内边距
    CGFloat inset = (self.collectionView.frame.size.height - self.itemSize.height) * 0.5;
    // 可以自己通过布局设置内边距
    self.sectionInset = UIEdgeInsetsMake(inset, 0, inset, 0);
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获得super已经计算好的布局属性,返回的素组包括所有cell的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerY = self.collectionView.contentOffset.y + self.collectionView.frame.size.height * 0.5;
    
    // 遍历所有cell的属性,在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x 和 collectionView最中心点的y值 的间距
        CGFloat delta = ABS(attrs.center.y - centerY);
        
        // 根据间距值 计算 cell的缩放比例
        CGFloat scale = 1 - delta / self.collectionView.frame.size.height ;
        
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        
        //浮点型不是精确类型，所以没写 == 1.0
        CGFloat alpha = (1 - delta / self.collectionView.frame.size.height) > 0.999 ? 1.0 : 0.6;
        attrs.alpha = alpha;
    }
    
    return array;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = proposedContentOffset.y;
    rect.origin.x = 0;
    rect.size = self.collectionView.frame.size;

    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];

    // 计算collectionView最中心点的x值
    CGFloat centerY = proposedContentOffset.y + self.collectionView.frame.size.height * 0.5;

    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    NSIndexPath *indexpath = nil;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.y - centerY)) {
            minDelta = attrs.center.y - centerY;
            indexpath = attrs.indexPath;
        }
    }
    if (self.scrollEndCenterIndex) {
        self.scrollEndCenterIndex(indexpath);
    }
    // 修改原有的偏移量
    proposedContentOffset.y += minDelta;
    return proposedContentOffset;
}
@end
