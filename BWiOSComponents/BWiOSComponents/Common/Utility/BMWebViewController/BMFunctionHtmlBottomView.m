//
//  BMFunctionHtmlBottomView.m
//  BWiOSComponents
//
//  Created by BobWong on 17/4/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMFunctionHtmlBottomView.h"
#import <Masonry.h>

@interface BMFunctionHtmlBottomView()
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (assign, nonatomic) BOOL isExpand;
@property (assign, nonatomic) NSInteger reduceHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
@implementation BMFunctionHtmlBottomView
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupBasic];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview) {
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.superview.mas_left);
            make.right.equalTo(self.superview.mas_right);
            make.height.equalTo(@(64));
            make.top.equalTo(self.superview.mas_bottom).offset(-20);
        }];
    }
}

-(void)dealloc
{
    NSLog(@"===");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 当前坐标系上的点转换到按钮上的点
    CGPoint btnP = [self convertPoint:point toView:self.expandBtn];
    CGPoint topVP = [self convertPoint:point toView:self.topView];
    // 判断点在不在按钮上
    if ([self.expandBtn pointInside:btnP withEvent:event]) {
        // 点在按钮上
        return self.expandBtn;
    }else if ([self.topView pointInside:topVP withEvent:event]) {
        // 点在topview上时，交给上层处理
        return nil;
    }else{
        return [super hitTest:point withEvent:event];
    }
}

#pragma mark - 私有方法
- (void)setupBasic
{
    //设置上边圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.expandBtn.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.expandBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.expandBtn.layer.mask = maskLayer;
}

#pragma mark - 事件响应
+(instancetype)functionHtmlBottomView
{
    BMFunctionHtmlBottomView *bottomV = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    return bottomV;
}


- (IBAction)expandBtn:(id)sender {
    if (self.blockExpand) {
        self.blockExpand();
    }
    //
    if (self.isExpand == NO) {
        //收紧的
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.superview.mas_bottom).offset(-64);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self.superview layoutIfNeeded];
            self.expandBtn.alpha = 0;
        } completion:^(BOOL finished) {
            self.isExpand = YES;
        }
        ];
    }
}


- (IBAction)leaveBtn:(id)sender {
    if (self.blockLeave) {
        self.blockLeave();
    }
}

- (IBAction)refreshBtn:(id)sender {
    if (self.blockFresh) {
        self.blockFresh();
    }
}


- (IBAction)urgentBtn:(id)sender {
    if (self.blockUrgent) {
        self.blockUrgent();
    }
    if (self.isExpand == YES) {
        //展开的
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.superview.mas_bottom).offset(-20);
        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.superview layoutIfNeeded];
            self.expandBtn.alpha = 1;
        } completion:^(BOOL finished) {
            self.isExpand = NO;
        }];
    }
}

#pragma mark -
#pragma mark - init
#pragma mark - 系统delegate
#pragma mark - 自定义delegate
#pragma mark - 公有方法
#pragma mark - getters setters

@end
