//
//  BMParagraphFieldView.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/6.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMParagraphFieldView.h"
#import "UITextView+BWAdd.h"

@implementation BMParagraphFieldView

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    self.rightLabel.textColor = [UIColor darkTextColor];
    self.rightLabel.font = [UIFont systemFontOfSize:12.0];
    
    self.contentTextView.textColor = [UIColor blackColor];
    self.contentTextView.font = [UIFont systemFontOfSize:14.0];
    self.contentTextView.placeholderLabel.textColor = [UIColor lightTextColor];
    self.contentTextView.placeholder = @"请输入";
    
    self.lineView.backgroundColor = [UIColor grayColor];
    
    [self setData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Method

- (void)refreshCountAndLimitTextLength {
    NSString *inputedText = self.contentTextView.text;
    NSInteger count = inputedText.length;
    self.rightLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)count, (long)self.maxCount];
    
    if (count > 50) self.contentTextView.text = [inputedText substringToIndex:self.maxCount];
}

#pragma mark - Private Method

- (void)setData {
    self.maxCount = 50;
    [self refreshCountAndLimitTextLength];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCountAndLimitTextLength) name:UITextViewTextDidChangeNotification object:nil];  // 监听Inputing text变化
}

#pragma mark - Setter and Getter

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.contentTextView.placeholder = placeholder;
}

@end
