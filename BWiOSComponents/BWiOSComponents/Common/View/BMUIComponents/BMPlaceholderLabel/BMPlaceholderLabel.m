//
//  BMPlaceholderLabel.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/21.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMPlaceholderLabel.h"

@implementation BMPlaceholderLabel

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:self.frame];
        _placeholderLabel.textColor = self.textColor;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.opaque = NO;
        _placeholderLabel.hidden = YES;
//        [self addSubview:_placeholderLabel];
//        [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self);
//        }];
        
        UIView *superView = self.superview;
        if (superView) {
            [superView addSubview:_placeholderLabel];
            [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self);
            }];
        }
    }
    return _placeholderLabel;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    BOOL hide = self.text && ![self.text isEqualToString:@""];
    self.placeholderLabel.hidden = hide;
    
}

@end
