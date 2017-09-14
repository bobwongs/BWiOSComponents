//
//  BMAddToCartView.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/5.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMAddToCartView.h"
//#import "UIImageView+BMExtension.h"
#import "UIButton+BMExtension.h"
#import "BMSetNumberAlert.h"
//#import "NSString+BMExtension.h"

CGFloat const BMAddToCartViewAnimationDuration = 0.25;

@interface BMAddToCartView()

/* UI */
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *singletonPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet BMCartProductInputView *countSettingView;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

/* Data */
@property (assign, nonatomic) NSInteger count;  ///< 数量
@property (strong, nonatomic) BMProductItemModel *itemModel;

@property (strong, nonatomic) BMSetNumberAlert *setNumberAlert;  ///< 设置数量的弹框

@end

@implementation BMAddToCartView

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.alpha = 0;  // 动画
    self.frame = [UIScreen mainScreen].bounds;
    
    self.showImageView.layer.cornerRadius = 4.0;
    self.showImageView.layer.borderWidth = 0.5;
    self.showImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.showImageView.clipsToBounds = YES;
    
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0];
    
    NSArray<UILabel *> *labelArray = @[self.countLabel, self.singletonPriceLabel, self.totalPriceLabel];
    for (UILabel *label in labelArray) {
        label.textColor = [UIColor darkTextColor];
        label.font = [UIFont systemFontOfSize:14.0];
    }
    
    [self.bottomButton bmB2B_setButtonWithType:BMb2bButtonType_btn2_2];
    self.bottomButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
    self.bottomButton.titleEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0);
    
    
    // custom count setting
    self.countSettingView.subBlock = ^{
        if (_count <= 1) return;
        self.count -= 1;
    };
    self.countSettingView.addBlock = ^{
        self.count += 1;
    };
    __weak typeof(self) weakSelf = self;
    self.countSettingView.inputBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.setNumberAlert showWithCount:strongSelf.count];
        [strongSelf dismiss];  // 设置数量面板出来，消失
    };
}

+ (instancetype)instanceView
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return [arr firstObject];
}

#pragma mark - Public Method

- (void)showWithModel:(BMProductItemModel *)addressModel {
    _itemModel = addressModel;
    if (!addressModel) return;
    
//    [self.showImageView bm_setImageWithURL:[NSURL URLWithString:addressModel.itemImage.picUrl]];
    self.nameLabel.text = addressModel.name;
//    self.singletonPriceLabel.text = [NSString stringWithFormat:@"单价：%@", [NSString bm_moneyStringWithFen:addressModel.buyingPrice]];
    
    // 初始数量为1
    self.count = 1;
    
    [self show];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:BMAddToCartViewAnimationDuration animations:^{ self.alpha = 1; }];
}

- (void)dismiss {
    [UIView animateWithDuration:BMAddToCartViewAnimationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.cancelBlock) self.cancelBlock();
        [self removeFromSuperview];
    }];
}

#pragma mark - Action

- (IBAction)bgViewTap:(id)sender {
    [self dismiss];
}

- (IBAction)bottomButtonAction:(id)sender {
    if (self.doneBlock) self.doneBlock(self.itemModel.itemId, self.countSettingView.countLabel.text.integerValue);
    [self dismiss];  // Dismiss after confirm.
}

#pragma mark - Private Method

- (void)setCount:(NSInteger)count {
    _count = count;
    
    self.countLabel.text = [NSString stringWithFormat:@"数量：%ld", (long)count];
//    self.totalPriceLabel.text = [NSString stringWithFormat:@"总价：%@", [NSString bm_moneyStringWithFen:self.itemModel.buyingPrice * count]];
    self.countSettingView.num = count;
    
    self.countSettingView.subButton.enabled = (count <= 1) ? NO : YES;
    self.countSettingView.addButton.enabled = (count >= 999) ? NO : YES;
}

#pragma mark - Setter and Getter

- (BMSetNumberAlert *)setNumberAlert {
    if (!_setNumberAlert) {
        _setNumberAlert = [BMSetNumberAlert new];
        __weak typeof(self) weakSelf = self;
        _setNumberAlert.confirmBlock = ^(NSInteger count) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.count = count;
        };
        _setNumberAlert.dismissBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf show];
        };
    }
    return _setNumberAlert;
}

@end
