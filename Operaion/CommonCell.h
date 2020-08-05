//
//  CommonCell.h
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/15.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kidentifier_CommonCell @"CommonCell"
NS_ASSUME_NONNULL_BEGIN

@interface CommonCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *iconV;
- (void)setupImageName:(NSString *)imageName;
@end
NS_ASSUME_NONNULL_END
