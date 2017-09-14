//
//  BMCartProductInputView.m
//  B2BMall
//
//  Created by ___liangdahong on 2017/9/1.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BMCartProductInputView.h"
#import "UIAlertController+BMExtension.h"

@implementation BMCartProductInputView

- (void)awakeFromNib {
    [super awakeFromNib];
    _countLabel.textColor = BMb2b_text_color1;
    _countLabel.font = BMb2b_t2_b;
    _countLabel.userInteractionEnabled = YES;
    [_countLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toInputAction)]];
    
    self.layer.cornerRadius = 4.0f;
    self.clipsToBounds = YES;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = BMb2b_line_color.CGColor;
    [_subButton setBackgroundImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
    [_subButton setBackgroundImage:[UIImage imageNamed:@"minus_disable"] forState:UIControlStateDisabled];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"plus_disable"] forState:UIControlStateDisabled];
}

- (void)setNum:(NSInteger)num {
    _countLabel.text = [NSString stringWithFormat:@"%ld", num];
}

- (void)toInputAction {
    if (self.inputBlock) self.inputBlock();
}

- (IBAction)subButtonClick {
    if (_subBlock) _subBlock();
}

- (IBAction)addButtonClick {
    if (_addBlock) _addBlock();
}

@end
