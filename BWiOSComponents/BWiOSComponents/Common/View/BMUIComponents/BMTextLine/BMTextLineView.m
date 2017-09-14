//
//  BMTextLineView.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMTextLineView.h"

@implementation BMTextLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        BMTextLineView *view = (BMTextLineView *)[[[NSBundle mainBundle] loadNibNamed:@"BMTextLineView" owner:nil options:0] firstObject];
        view.frame = frame;
        self = view;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentLabel.placeholderLabel.text = @"未填写";
    self.contentLabel.placeholderLabel.textAlignment = NSTextAlignmentRight;
}

@end
