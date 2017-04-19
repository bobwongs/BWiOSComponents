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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, BM_SIDES_MENU_WIDTH - 15 * 2, BM_SIDES_MENU_CELL_HEIGHT)];
    self.titleLabel = titleLabel;
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:titleLabel];
    
    UIView *selectedTagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3.0, 20)];
    self.selectedTagView = selectedTagView;
    selectedTagView.center = CGPointMake(CGRectGetMidX(selectedTagView.frame), CGRectGetMidY(titleLabel.frame));  // Center with the title label
    selectedTagView.backgroundColor = BM_SIDES_MENU_UIColorFromRGB(0x0057f0);
    [self.contentView addSubview:selectedTagView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), BM_SIDES_MENU_CELL_HEIGHT - 1, CGRectGetWidth(titleLabel.frame), 1)];
    self.lineImageView = lineImageView;
    lineImageView.image = [UIImage imageNamed:@"bm_sides_menu_separated_line"];
    [self.contentView addSubview:lineImageView];
}

#pragma mark - Getter and Setter

- (void)setShowType:(BMSidesMenuShowType)showType {
    _showType = showType;
    
    switch (showType) {
        case BMSidesMenuShowTypeNone:
        {
            self.selectedTagView.hidden = YES;
            self.titleLabel.textColor = BM_SIDES_MENU_UIColorFromRGB(0x333333);
            break;
        }
        case BMSidesMenuShowTypeNotSelected:
        {
            self.selectedTagView.hidden = YES;
            self.titleLabel.textColor = BM_SIDES_MENU_UIColorFromRGB(0x999999);
            break;
        }
        case BMSidesMenuShowTypeSelected:
        {
            self.selectedTagView.hidden = NO;
            self.titleLabel.textColor = BM_SIDES_MENU_UIColorFromRGB(0x0057f0);
            break;
        }
    }
}

@end
