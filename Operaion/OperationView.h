//
//  OperationView.h
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/15.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionView.h"
#import "RoundFlowLayout.h"
#import "AdsorbFollowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface OperationView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *leftCollectionView;
@property (nonatomic,strong) CustomCollectionView *bigCollecitonView;
@property (nonatomic,strong) CustomCollectionView *smallCollectionView;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,strong) RoundFlowLayout *bigLayout;
@end

NS_ASSUME_NONNULL_END
