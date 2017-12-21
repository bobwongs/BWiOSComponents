//
//  BMAddressPickerCell.m
//  BMiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BMAddressPickerCell.h"
#import "BMAddressPickerAppearance.h"

@implementation BMAddressPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = [BMAddressPickerAppearance appearance].textNormalColor;
    self.iconImageView.image = [self.iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.iconImageView.tintColor = [BMAddressPickerAppearance appearance].textSelectedColor;
}

@end
