//
//  BMFieldBtn2View.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMFieldBtn2View.h"

@implementation BMFieldBtn2View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        BMFieldBtn2View *view = (BMFieldBtn2View *)[[NSBundle mainBundle] loadNibNamed:@"BMFieldBtn2View" owner:nil options:0].firstObject;
        view.frame = frame;
        self = view;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.backgroundColor = BMb2b_line_color;
    self.placeholderString = @"请输入";
}

- (void)setPlaceholderString:(NSString *)placeholderString {
    _placeholderString = placeholderString;
    
    if (!placeholderString || placeholderString.length == 0) return;
    UIColor *color = BMb2b_text_color3;
    NSString *text = placeholderString;
    NSDictionary *attr = @{NSFontAttributeName: self.contentTextField.font,
                           NSForegroundColorAttributeName: color};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attr];
    self.contentTextField.attributedPlaceholder = attrString;
}

@end
