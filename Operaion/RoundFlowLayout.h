//
//  RoundFlowLayout.h
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/19.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoundFlowLayout : UICollectionViewFlowLayout

/**
 布局

 @param radius 半径
 @param origin 圆心位置
 @param cellSize cellsize
 @param angle 两个item之间的夹角
 */
- (instancetype)initWithRadius:(CGFloat)radius
                origin:(CGPoint)origin
              cellSize:(CGSize)cellSize
                 angle:(CGFloat)angle
            offsetAngle:(CGFloat)offsetAngle;
@end

NS_ASSUME_NONNULL_END
