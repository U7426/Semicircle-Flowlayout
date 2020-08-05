//
//  CustomCollectionView.m
//  Operaion
//
//  Created by 冯龙飞 on 2019/4/15.
//  Copyright © 2019 冯龙飞. All rights reserved.
//

#import "CustomCollectionView.h"
@interface CustomCollectionView(){
    UILongPressGestureRecognizer *_longPressGesture;
    UIView *_tempMoveCell;
    NSIndexPath *_originalIndexPath;
    CGPoint _lastPoint;
    NSIndexPath *_moveIndexPath;
}
@property (nonatomic,assign) CGPoint roundOrigin;
@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,assign) CGSize cellSize;
@property (nonatomic,assign) CGRect likeFrame;
@property (nonatomic,assign) CGRect unlikeFrame;
@end
@implementation CustomCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout origin:(CGPoint )origin radius:(CGFloat)radius cellSize:(CGSize)cellsize{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.roundOrigin = origin;
        self.radius = radius;
        self.cellSize = cellsize;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}
- (void)needDragWithLikeFrame:(CGRect)likeFrame unlikeFrame:(CGRect)unlikeFrame{
    self.likeFrame = likeFrame;
    self.unlikeFrame = unlikeFrame;
    [self xwp_addGesture];
}
- (void)xwp_addGesture{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(xwp_longPressed:)];
    _longPressGesture = longPress;
    //设置长按时间
    longPress.minimumPressDuration = 0.2;
    [self addGestureRecognizer:longPress];
}

- (void)xwp_longPressed:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self indexPathForItemAtPoint:[longGesture locationInView:self]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self xwp_gestureBegan:longGesture];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self xwp_gestureChange:longGesture];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self xwp_gestureEndOrCancle:longGesture];
            break;
        default:
//            [self.bigCollecitonView cancelInteractiveMovement];
            break;
    }
}

- (void)xwp_gestureBegan:(UILongPressGestureRecognizer *)longPressGesture{
    //获取手指所在的cell
    _originalIndexPath = [self indexPathForItemAtPoint:[longPressGesture locationOfTouch:0 inView:longPressGesture.view]];
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:_originalIndexPath];
    //截图大法，得到cell的截图视图
    UIView *tempMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
    _tempMoveCell = tempMoveCell;
    _tempMoveCell.frame = cell.frame;
    [self addSubview:_tempMoveCell];
    //隐藏cell
    cell.hidden = YES;
    //记录当前手指位置
    _lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
}
- (void)xwp_gestureChange:(UILongPressGestureRecognizer *)longPressGesture{
    //计算移动距离
    CGFloat tranX = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].x - _lastPoint.x;
    CGFloat tranY = [longPressGesture locationOfTouch:0 inView:longPressGesture.view].y - _lastPoint.y;
    //设置截图视图位置
    _tempMoveCell.center = CGPointApplyAffineTransform(_tempMoveCell.center, CGAffineTransformMakeTranslation(tranX, tranY));
    _lastPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
}
- (void)xwp_gestureEndOrCancle:(UILongPressGestureRecognizer *)longPressGesture{
    CGPoint point = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
    point.y = point.y - self.contentOffset.y;
    BOOL islike = CGRectContainsPoint(self.likeFrame, point);
    BOOL isunlike = CGRectContainsPoint(self.unlikeFrame, point);
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:_originalIndexPath];
    if (islike || isunlike) {
        if (self.dragResult) {
            self.dragResult(islike ? YES : NO, _originalIndexPath);
        }
        cell.hidden = NO;
        [_tempMoveCell removeFromSuperview];
        return;
    }
    //结束动画过程中停止交互，防止出问题
    self.userInteractionEnabled = NO;
    //给截图视图一个动画移动到隐藏cell的新位置
    [UIView animateWithDuration:0.25 animations:^{
        self->_tempMoveCell.center = cell.center;
    } completion:^(BOOL finished) {
        //移除截图视图、显示隐藏cell并开启交互
        [self->_tempMoveCell removeFromSuperview];
        cell.hidden = NO;
        self.userInteractionEnabled = YES;
    }];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    id __tmpView = [super hitTest:point withEvent:event];
    CGFloat distance = hypotf(self.roundOrigin.x - point.x,self.roundOrigin.y - (point.y - self.contentOffset.y));
    if (distance >= self.radius - self.cellSize.width / 2.0 && distance <= self.radius + self.cellSize.width / 2.0) {
        return __tmpView;
    }
    return nil;
}

@end
