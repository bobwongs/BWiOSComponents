//
//  BMTextArrowView.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMTextArrowView.h"

@interface BMTextArrowView ()

@property (nonatomic, strong) dispatch_block_t tapBlock;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowRightConstraint;

@end

@implementation BMTextArrowView 

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        BMTextArrowView *view = (BMTextArrowView *)[[[NSBundle mainBundle] loadNibNamed:@"BMTextArrowView" owner:nil options:0] firstObject];;
        view.frame = frame;
        self = view;

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /* ---------- B2B style ---------- */
    self.titleLabel.textColor = BMb2b_text_color2;
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    self.lineView.backgroundColor = BMb2b_line_color;
    /* ---------- B2B style ---------- */
    
    self.selectionEnabled = YES;  // 默认允许输入，调一次setter设置样式
    
    self.contentLabel.textColor = BMb2b_text_color1;
    self.contentLabel.text = @"";  // 做一次空赋值，初始显示“请选择”placeHolderLabel
}

#pragma mark - Public Method

- (void)setTap:(dispatch_block_t)block {
    self.tapBlock = block;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:recognizer];
}

- (void)setSelectionEnabled:(BOOL)selectionEnabled animation:(BOOL)animation {
    _selectionEnabled = selectionEnabled;
    
    self.userInteractionEnabled = selectionEnabled;
    self.contentLabel.placeholderLabel.textAlignment = NSTextAlignmentRight;
    self.contentLabel.placeholderLabel.text = selectionEnabled ? @"请选择" : @"未填写";
    self.contentLabel.placeholderLabel.textColor = selectionEnabled ? BMb2b_text_color3 : BMb2b_text_color1;
    
    // 隐藏or显示右边箭头，以右边箭头的右约束来修改
    CGFloat right_space = selectionEnabled ? 8 : (-30 + 4);  // 不可编辑状态时的边距是12
    if (animation) {
        [UIView animateWithDuration:0.5 animations:^{
            self.arrowRightConstraint.constant = right_space;
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
    } else {
        self.arrowRightConstraint.constant = right_space;
    }
}


#pragma mark - Private Method

- (void)tap {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

#pragma mark - Setter and Getter

- (void)setSelectionEnabled:(BOOL)selectionEnabled {
    [self setSelectionEnabled:selectionEnabled animation:NO];
}

@end
