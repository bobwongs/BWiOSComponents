//
//  BMSetNumberAlert.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/5.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMSetNumberAlert.h"
//#import "UIApplication+BWAdd.h"
#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>

@interface BMSetNumberAlert ()

@end

@implementation BMSetNumberAlert

#pragma mark - Life Cycle

- (void)dealloc {
    [self removeAllObserver];
}

#pragma mark - Public Method

- (void)showWithCount:(NSInteger)count {
    [self addTextFieldObserver];  // 显示的时候添加监听
    
    NSInteger inputableCount = count;
    if (inputableCount <= 0) inputableCount = 1;
    else if (inputableCount > 999) inputableCount = 999;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入购买数量" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text = @(inputableCount).stringValue;
        textField.textAlignment = NSTextAlignmentCenter;
    
        [textField becomeFirstResponder];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            textField.selectedTextRange = [textField textRangeFromPosition:textField.beginningOfDocument toPosition:textField.endOfDocument];  // 初始全选
        });
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = alertController.textFields.firstObject.text;
        NSInteger count = (!text || text.length == 0) ? 1 : text.integerValue;  // 输入为空，使用数量1
        [self removeAllObserver];
        
        if (self.confirmBlock) self.confirmBlock(count);
        if (self.dismissBlock) self.dismissBlock();
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self removeAllObserver];
        
        if (self.dismissBlock) self.dismissBlock();
    }]];
//    [[UIApplication bm_topViewController] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private Method

- (void)addTextFieldObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

/** 移除所有通知，在点击完确认和或者取消的时候，防止有些地方会没有去释放 */
- (void)removeAllObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textfieldDidChangeNotification:(NSNotification *)notification {
    UITextField *textfield = notification.object;
    if ([textfield.text isEqualToString:@"0"]) textfield.text = @"1";  // 最小为0
    else if (textfield.text.length > 3) textfield.text = @"999";  // 最大为999
}

@end
