//
//  BMTextFieldView.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMTextFieldView.h"

@interface BMTextFieldView ()<UITextFieldDelegate>

@end


@implementation BMTextFieldView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        BMTextFieldView *view = (BMTextFieldView *)[[[NSBundle mainBundle] loadNibNamed:@"BMTextFieldView" owner:nil options:0] firstObject];;
        view.contentTextField.delegate = self;
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
    
    self.contentTextField.textColor = [UIColor blackColor];
    
    self.lineView.backgroundColor = [UIColor grayColor];
    /* ---------- B2B Style ---------- */
    
    [self addNotification];
    self.inputEnabled = YES;  // 默认开启，调用一次重写的setter方法，对placeHolder做初始化
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)textFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (textField != self.contentTextField) {
        return;
    }
    NSString *toBeString = textField.text;
    if (self.maxCharacterCount >0 && toBeString.length > self.maxCharacterCount) {
        textField.text = [toBeString substringToIndex:self.maxCharacterCount];
    }
}

- (void)setInputEnabled:(BOOL)inputEnabled {
    _inputEnabled = inputEnabled;
    self.contentTextField.userInteractionEnabled = inputEnabled;
    
    UIColor *color = inputEnabled ? [UIColor lightTextColor] : [UIColor blackColor];
    NSString *text = inputEnabled ? @"请输入" : @"未填写";
    NSDictionary *attr = @{NSFontAttributeName: self.contentTextField.font,
                           NSForegroundColorAttributeName: color};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attr];
    
    self.contentTextField.attributedPlaceholder = attrString;
}

@end
