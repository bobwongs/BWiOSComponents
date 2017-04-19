//
//  BMSidesMenuCell.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/4/19.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMSidesMenuCell.h"

@implementation BMSidesMenuCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

#pragma mark - Action

#pragma mark - Public Method

#pragma mark - Private Method

- (void)setUI
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BM_SIDES_MENU_WIDTH, 50)];
    self.titleLabel = titleLabel;
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.textColor = BM_SIDES_MENU_UIColorFromRGB(0x0057f0);
    [self.contentView addSubview:titleLabel];
    
    UIImageView *<#imageView#> = [[UIImageView alloc] initWithFrame:<#CGRect#>];
    <#imageView#>.image = UIImage;
    <#imageView#>.contentMode = UIViewContentMode;
    [<#superview#> addSubview:<#imageView#>];
}

#pragma mark - Getter and Setter

@end
