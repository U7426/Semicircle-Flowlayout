//
//  OperationView.m
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/15.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import "OperationView.h"
#import "CommonCell.h"

struct Round {
    CGPoint point;
    CGFloat radius;
};
typedef struct Round Round;
CAShapeLayer *leftCircleLayer = nil;
@implementation OperationView
@synthesize  items;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
        [self addDragGestures];//为大圆添加拖动手势
    }
    return self;
}
- (void)initUI{
    //left
    AdsorbFollowLayout *layout = [AdsorbFollowLayout new];
    layout.itemSize =  CGSizeMake(40,40);
    layout.minimumLineSpacing = 10.0;
    NSInteger itemCount = 5;//设置为奇数
    CGSize leftCellSize = layout.itemSize;
    CGFloat leftHeight = itemCount * layout.itemSize.width + (itemCount - 1) * layout.minimumLineSpacing;
    [layout setScrollEndCenterIndex:^(NSIndexPath *indexpath) {
        NSLog(@"中心index：%@",indexpath);
    }];
    self.leftCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, (self.bounds.size.height - leftHeight)/2, leftCellSize.width, leftHeight) collectionViewLayout:layout];
    [self.leftCollectionView registerClass:[CommonCell class] forCellWithReuseIdentifier:kidentifier_CommonCell];
    self.leftCollectionView.backgroundColor = [UIColor clearColor];
    self.leftCollectionView.showsVerticalScrollIndicator = NO;
    self.leftCollectionView.delegate = self;
    self.leftCollectionView.dataSource = self;
    [self insertSubview:self.leftCollectionView atIndex:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:self.leftCollectionView.center radius:leftCellSize.width / 2.0 + 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    leftCircleLayer = [CAShapeLayer new];
    leftCircleLayer.frame = self.leftCollectionView.bounds;
    leftCircleLayer.path = circlePath.CGPath;
    leftCircleLayer.strokeColor = [UIColor redColor].CGColor;
    leftCircleLayer.fillColor = [UIColor clearColor].CGColor;
    leftCircleLayer.lineWidth = 1.0;
    [self.layer insertSublayer:leftCircleLayer atIndex:0];
    //改变初始偏移量，使第一次显示效果居中
    [self.leftCollectionView setContentOffset:CGPointMake(0, (itemCount - 1) / 2 * (leftCellSize.height + layout.minimumLineSpacing)) animated:YES];
    //big
    Round round = [self radiusWithTopMargin:20.0 leftMargin:self.bounds.size.width / 2];
    CGSize cellSize = CGSizeMake(40, 40);
    CGFloat angle = asin((cellSize.width + 15)/round.radius);//两个 cell 中心 的间距
    CGFloat offSetAngle = asin((cellSize.width + 30) / round.radius);//第一个cell离 右屏幕边与弧线 的偏移量 （这里设置为30）
    RoundFlowLayout  *bigLayout = [[RoundFlowLayout alloc] initWithRadius:round.radius origin:round.point cellSize:CGSizeMake(40, 40) angle:angle offsetAngle:offSetAngle];
    self.bigLayout = bigLayout;
    self.bigCollecitonView = [[CustomCollectionView alloc]initWithFrame:self.bounds collectionViewLayout:bigLayout origin:round.point radius:round.radius cellSize:cellSize];
    self.bigCollecitonView.backgroundColor = [UIColor clearColor];
    [self.bigCollecitonView registerClass:[CommonCell class] forCellWithReuseIdentifier:kidentifier_CommonCell];
    self.bigCollecitonView.showsVerticalScrollIndicator = NO;
    self.bigCollecitonView.delegate = self;
    self.bigCollecitonView.dataSource = self;
    [self insertSubview:self.bigCollecitonView atIndex:0];
    //画线（大圆）
    UIBezierPath *bigPath = [UIBezierPath bezierPathWithArcCenter:round.point radius:round.radius - 30 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    CAShapeLayer *bigLayer = [CAShapeLayer new];
    bigLayer.frame = self.bounds;
    bigLayer.path = bigPath.CGPath;
    [self setLineDashPatternWithLayer:bigLayer];
    [self.layer insertSublayer:bigLayer atIndex:0];
    //small (round圆点不变，半径缩小，同心圆)
    RoundFlowLayout  *smallLayout = [[RoundFlowLayout alloc] initWithRadius:round.radius - 60 origin:round.point cellSize:CGSizeMake(40, 40) angle:angle offsetAngle:offSetAngle];
    self.smallCollectionView = [[CustomCollectionView alloc]initWithFrame:self.bounds collectionViewLayout:smallLayout origin:round.point radius:round.radius - 60 cellSize:cellSize];
    self.smallCollectionView.backgroundColor = [UIColor clearColor];
    [self.smallCollectionView registerClass:[CommonCell class] forCellWithReuseIdentifier:kidentifier_CommonCell];
    self.smallCollectionView.showsVerticalScrollIndicator = NO;
    self.smallCollectionView.delegate = self;
    self.smallCollectionView.dataSource = self;
    [self insertSubview:self.smallCollectionView atIndex:0];
    //画线（小圆）
    UIBezierPath *smallPath = [UIBezierPath bezierPathWithArcCenter:round.point radius:round.radius - 90 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    CAShapeLayer *smallLayer = [CAShapeLayer new];
    smallLayer.frame = self.bounds;
    smallLayer.path = smallPath.CGPath;
    [self setLineDashPatternWithLayer:smallLayer];
    [self.layer insertSublayer:smallLayer atIndex:0];
}
- (void)initData{
    NSError *error;
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"photos" ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:NULL];
    items = [[NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error] mutableCopy];
}
- (void)addDragGestures{
    UIImageView *likeView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 20 - 50, self.bounds.size.height / 2 - 20 - 50, 50, 50)];
    likeView.backgroundColor = [UIColor redColor];
    [self insertSubview:likeView atIndex:0];
    UIImageView *unLikeView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width - 20 - 50, self.bounds.size.height / 2 + 20 , 50, 50)];
    unLikeView.backgroundColor = [UIColor blackColor];
    [self insertSubview:unLikeView atIndex:0];
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(CGRectGetMaxX(likeView.frame) + 10, self.bounds.size.height / 2)];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(likeView.frame) - 10, self.bounds.size.height / 2)];
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    [self setLineDashPatternWithLayer:layer];
    [self.layer insertSublayer:layer above:0];

    [self.bigCollecitonView needDragWithLikeFrame:[self.bigCollecitonView convertRect:likeView.frame fromView:self] unlikeFrame:[self.bigCollecitonView convertRect:unLikeView.frame fromView:self]];
    __weak typeof(self) weakself = self;
    [self.bigCollecitonView setDragResult:^(BOOL isLike, NSIndexPath * _Nonnull indexpath) {
        if (isLike == NO) {
            [weakself.items removeObjectAtIndex:indexpath.row];
            [weakself.bigCollecitonView reloadData];
            [weakself.smallCollectionView reloadData];//共用一个数据源，实际开发只需要ralodad bigColleciton
            [weakself.leftCollectionView reloadData];
        }
    }];
}
#pragma mark - Collectionview
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CommonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kidentifier_CommonCell forIndexPath:indexPath];
    NSDictionary *item = [self.items objectAtIndex:indexPath.item];
    NSString *imgURL = [item valueForKey:@"picture"];
    [cell setupImageName:imgURL];
    return cell;
}
#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView != self.leftCollectionView) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        leftCircleLayer.opacity = 0.0;
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView != self.leftCollectionView) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        leftCircleLayer.opacity = 1.0;
    }];
}
#pragma mark - private
- (void)setLineDashPatternWithLayer:(CAShapeLayer*)layer{
    layer.strokeColor = [UIColor orangeColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1.5;
    [layer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:4],[NSNumber numberWithInt:2],nil]];
}
/**
 生成圆
 @param topMargin 弧度与屏幕顶端的距离
 @param leftMargin 弧度与屏幕左间距
 @return 圆
 */
- (Round)radiusWithTopMargin:(float)topMargin leftMargin:(float)leftMargin{
    CGFloat screen_width = self.bounds.size.width;
    CGFloat screen_height = self.bounds.size.height;
    if (screen_width - leftMargin > (screen_height / 2 - topMargin)) {
        NSAssert(NO, @"输入不合法，圆点在屏幕左侧");
    }
    CGFloat radius = 0.0;//半径
    CGFloat a = (screen_height - 2 * topMargin) / 2.0;//边长a
    radius = (powf(a, 2) +  powf(leftMargin - screen_width,2)) /  (2 * (screen_width - leftMargin));
    Round round = {
        .radius = radius,
        .point = CGPointMake(leftMargin + radius, screen_height / 2.0)
    };
    return round;
}
@end
