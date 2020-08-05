//
//  CustomCollectionView.h
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/15.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCollectionView : UICollectionView
@property (nonatomic,copy) void(^dragResult)(BOOL isLike,NSIndexPath *indexpath);
/**
 初始化

 @param frame frame
 @param layout RoundFolowLayout
 @param origin 圆心
 @param radius 半径
 @param cellsize cell大小
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout origin:(CGPoint )origin radius:(CGFloat)radius cellSize:(CGSize)cellsize;

/**
 添加手势

 @param likeFrame 喜欢视图的frame
 @param unlikeFrame 不喜欢视图的frame
 */
- (void)needDragWithLikeFrame:(CGRect)likeFrame unlikeFrame:(CGRect)unlikeFrame;
@end

NS_ASSUME_NONNULL_END
