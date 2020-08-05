//
//  CommonCell.m
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/15.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import "CommonCell.h"

@implementation CommonCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconV = [[UIImageView alloc]initWithFrame:self.bounds];
        self.iconV.layer.cornerRadius = 20.0;
        self.iconV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.iconV];
    }
    return self;
}
- (void)setupImageName:(NSString *)imageName{
    self.iconV.image = [UIImage imageNamed:imageName];
}
@end
