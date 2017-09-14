//
//  BMWhiteIrregularGridViewCell.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/21.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMWhiteIrregularGridViewCell.h"
#import <YYCategories.h>

@interface BMWhiteIrregularGridViewCell ()
@property (nonatomic, strong) UIButton     *button;

@end
@implementation BMWhiteIrregularGridViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupCell];
    }
    
    return self;
}

+ (BMIrregularGridCellDataAdapter *)collectionGridCellDataAdapterWithCellReuseIdentifier:(NSString *)cellReuseIdentifier data:(id)data
                                                            cellType:(NSInteger)cellType itemWidth:(CGFloat)itemWidth {
    
    BMIrregularGridCellDataAdapter *adapter = [[self class] new];
    adapter.cellReuseIdentifier           = cellReuseIdentifier;
    adapter.data                          = data;
    adapter.cellType                      = cellType;
    adapter.itemWidth                     = itemWidth;
    
    return adapter;
}

- (void)setupCell {
    self.button                     = [[UIButton alloc] initWithFrame:self.bounds];
    self.button.layer.cornerRadius  = 4.f;
    self.button.layer.masksToBounds = YES;
    self.button.layer.borderWidth   = 1.f;
//    self.button.layer.borderColor   = [[UIColor grayColor] colorWithAlphaComponent:0.25f].CGColor;

    //设置边框颜色
    self.button.layer.borderColor = [UIColor colorWithHexString:@"d7d7d7"].CGColor;
    //设置4中状态的背景颜色
    [self.button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]      forState:UIControlStateNormal];
    [self.button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ff6c47"]] forState:UIControlStateSelected];
        [self.button setBackgroundImage:[UIImage imageWithColor:[[UIColor colorWithHexString:@"ff6c47"] colorWithAlphaComponent:0.75]] forState:UIControlStateHighlighted];
    [self.button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f8f8f8"]] forState:UIControlStateDisabled];
    //设置4种状态的字体颜色
    [self.button setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateSelected];
    [self.button setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateHighlighted];
    [self.button setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    
    [self addSubview:self.button];
    
    [self.button addTarget:self action:@selector(selectedEvent) forControlEvents:UIControlEventTouchUpInside];
}



- (void)loadContent {
    //设置按钮字体
    self.button.titleLabel.font = self.dataAdapter.font;
    self.button.width = self.dataAdapter.itemWidth;
    [self.button setTitle:self.data forState:UIControlStateNormal];
    self.button.selected = self.dataAdapter.selected;
    if (self.button.selected) {
        self.button.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.button.layer.borderColor = [UIColor colorWithHexString:@"d7d7d7"].CGColor;
    }
    
}
- (void)selectedEvent {
    self.dataAdapter.selected   =  !self.dataAdapter.selected;
    //刷新itm（去掉动画）
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadItemsAtIndexPaths:@[self.indexPath]];
    }];
    
    //刷新当前 Item
    if (self.delegate && [self.delegate respondsToSelector:@selector(whiteIrregularGridViewCell:event:)]) {
        [self.delegate whiteIrregularGridViewCell:self event:self.dataAdapter];
    }
}



+ (BMIrregularGridCellDataAdapter *)dataAdapterWithData:(id)data itemWidth:(CGFloat)itemWidth selected:(BOOL)selected font:(UIFont *)font
{
    return [BMIrregularGridCellDataAdapter collectionGridCellDataAdapterWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellType:0 itemWidth:itemWidth selected:selected font:font ];
}

+ (BMIrregularGridCellDataAdapter *)dataAdapterWithData:(id)data itemWidth:(CGFloat)itemWidth selected:(BOOL)selected
{
    return [BMIrregularGridCellDataAdapter collectionGridCellDataAdapterWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellType:0 itemWidth:itemWidth selected:selected font:[UIFont systemFontOfSize:12]];
}

+ (BMIrregularGridCellDataAdapter *)dataAdapterWithData:(id)data itemWidth:(CGFloat)itemWidth
{
    return [BMIrregularGridCellDataAdapter collectionGridCellDataAdapterWithCellReuseIdentifier:NSStringFromClass([self class]) data:data cellType:0 itemWidth:itemWidth selected:NO font:[UIFont systemFontOfSize:12]];
}

@end
