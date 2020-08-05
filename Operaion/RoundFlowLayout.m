//
//  RoundFlowLayout.m
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/19.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import "RoundFlowLayout.h"
@interface RoundFlowLayout()
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGFloat angle;
@property (nonatomic,assign) CGSize cellSize;
@property (nonatomic,assign) CGFloat offset;
@property (nonatomic,assign) NSInteger cellCount;
@property (nonatomic,assign) CGFloat offsetAngle;
@property (nonatomic,assign) CGFloat oldHeight;
@end
@implementation RoundFlowLayout
- (instancetype)initWithRadius:(CGFloat)radius origin:(CGPoint)origin cellSize:(CGSize)cellSize angle:(CGFloat)angle offsetAngle:(CGFloat)offsetAngle{
    self = [super init];
    if (self) {
        self.radius = radius;
        self.cellSize = cellSize;
        self.angle = angle;
        self.cellSize = cellSize;
        self.origin = origin;
        self.offsetAngle = offsetAngle;
    }
    return self;
}
- (void)prepareLayout{
    [super prepareLayout];
    self.cellCount = (self.collectionView.numberOfSections > 0)? (int)[self.collectionView numberOfItemsInSection:0] : 0;
    self.offset = -self.collectionView.contentOffset.y / self.cellSize.height;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *theLayoutAttributes = [[NSMutableArray alloc] init];
    int maxVisiblesHalf = M_PI / self.angle;
    for( int i = 0; i < self.cellCount; i++ ){
        CGRect itemFrame = [self getRectForItem:i];
        if(CGRectIntersectsRect(rect, itemFrame) && i > (-1*self.offset - maxVisiblesHalf) && i < (-1*self.offset + maxVisiblesHalf)){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            theAttributes.frame = itemFrame;
            [theLayoutAttributes addObject:theAttributes];
        }
    }
    return theLayoutAttributes;
}
-(CGRect)getRectForItem:(int)item{
    double newIndex = (item + self.offset);
    CGFloat originAngle = acosf((self.origin.x - self.collectionView.bounds.size.width)/self.radius);
    originAngle = originAngle -  self.offsetAngle;
    float distanceX = cosf(self.angle * newIndex - originAngle) * self.radius;
    float distanceY = sinf(self.angle * newIndex - originAngle) * self.radius;
    float oX = self.origin.x;//滑动后圆心X
    float oY = self.origin.y + self.collectionView.contentOffset.y;//滑动圆心y
    CGRect itemFrame = CGRectMake(oX - distanceX - self.cellSize.width / 2, oY + distanceY - self.cellSize.height / 2.0, self.cellSize.width, self.cellSize.height);
    return itemFrame;
}
- (CGSize)collectionViewContentSize
{
    CGFloat maxVisiblesAngle = acosf((self.origin.x - self.collectionView.bounds.size.width)/self.radius) / M_PI * 180 * 2;//最大可见角度
    CGFloat maxVisiblesCount = maxVisiblesAngle / (self.angle / M_PI * 180);//最大可见item数量
    CGFloat a = maxVisiblesAngle / 180 * M_PI / 2;//最大角度一半 弧度表示
    CGFloat y = self.radius * sin(a) - self.radius * sin(a - self.offsetAngle);
    CGFloat height = (self.cellCount  - maxVisiblesCount) * self.cellSize.height + self.collectionView.bounds.size.height + y ;
    const CGSize theSize = {
        .width = self.collectionView.bounds.size.width,
        .height = height,
    };
    self.collectionView.contentSize = CGSizeMake(self.collectionView.bounds.size.width, height);
    return(theSize);
}

@end
