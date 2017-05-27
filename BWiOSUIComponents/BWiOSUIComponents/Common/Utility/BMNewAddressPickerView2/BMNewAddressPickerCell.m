//
//  BMNewAddressPickerCell.m
//  BMWash
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BMNewAddressPickerCell.h"

@interface BMNewAddressPickerCell ()

@property (strong, nonatomic) UIImageView *iconImageView;  ///< Icon

@end

@implementation BMNewAddressPickerCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
        [self setConstraints];
    }
    return self;
}

#pragma mark - Action

#pragma mark - Public Method

#pragma mark - Private Method

- (void)setUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.textColor = BM_NEW_ADDRESS_PICKER_333333;
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_iconImageView];
}

- (void)setConstraints
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(20);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(20);
        
        make.right.mas_lessThanOrEqualTo(-20);
    }];
}

#pragma mark - Getter and Setter

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    _iconImageView.hidden = !selected;
}

@end
