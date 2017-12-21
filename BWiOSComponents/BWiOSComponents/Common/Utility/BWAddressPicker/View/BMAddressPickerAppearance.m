//
//  BMAddressPickerAppearance.m
//  AFNetworking
//
//  Created by BobWong on 2017/12/19.
//

#import "BMAddressPickerAppearance.h"
#import "SVProgressHUD.h"

#define BM_ADDRESS_PICKER_UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define BM_ADDRESS_PICKER_333333 BM_ADDRESS_PICKER_UIColorFromRGB(0x333333)
#define BM_ADDRESS_PICKER_999999 BM_ADDRESS_PICKER_UIColorFromRGB(0x999999)
#define BM_ADDRESS_PICKER_1fb8ff BM_ADDRESS_PICKER_UIColorFromRGB(0x1fb8ff)
#define BM_ADDRESS_PICKER_e5e5e5 BM_ADDRESS_PICKER_UIColorFromRGB(0xe5e5e5)

@implementation BMAddressPickerAppearance

+ (instancetype)appearance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (UIColor *)textNormalColor {
    return _textNormalColor ? _textNormalColor : BM_ADDRESS_PICKER_333333;
}

- (UIColor *)textSelectedColor {
    return _textSelectedColor ? _textSelectedColor : BM_ADDRESS_PICKER_1fb8ff;
}

- (UIColor *)textPromptColor {
    return _textPromptColor ? _textPromptColor : BM_ADDRESS_PICKER_999999;
}

- (UIColor *)lineColor {
    return _lineColor ? _lineColor : BM_ADDRESS_PICKER_e5e5e5;
}

- (dispatch_block_t)showHudBlock {
    return _showHudBlock ? _showHudBlock : ^{[SVProgressHUD show];};
}

- (dispatch_block_t)dismissHudBlock {
    return _dismissHudBlock ? _dismissHudBlock : ^{[SVProgressHUD dismiss];};
}

@end
