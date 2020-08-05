//
//  AdsorbFollowLayout.h
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/21.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdsorbFollowLayout : UICollectionViewFlowLayout
@property (nonatomic,copy) void(^scrollEndCenterIndex)(NSIndexPath *indexpath);//滚动结束中心显示的index
@end

NS_ASSUME_NONNULL_END
