//
//  BMTextField2View.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMTextField2View.h"

@implementation BMTextField2View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        BMTextField2View *view = (BMTextField2View *)[[NSBundle mainBundle] loadNibNamed:@"BMTextField2View" owner:nil options:0].firstObject;
        view.frame = frame;
        self = view;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /* ---------- B2B Style ---------- */
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    self.placeholderString = @"请输入";
    self.contentTextField.textColor = [UIColor blackColor];
    self.contentTextField.font = [UIFont systemFontOfSize:14.0];
    
    self.lineView.backgroundColor = [UIColor grayColor];
    /* ---------- B2B Style ---------- */
}

- (void)setPlaceholderString:(NSString *)placeholderString {
    _placeholderString = placeholderString;
    
    if (!placeholderString || placeholderString.length == 0) return;
    UIColor *color = [UIColor lightTextColor];
    NSString *text = placeholderString;
    NSDictionary *attr = @{NSFontAttributeName: self.contentTextField.font,
                           NSForegroundColorAttributeName: color};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attr];
    self.contentTextField.attributedPlaceholder = attrString;
}

@end
