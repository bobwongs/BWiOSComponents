//
//  BMNoDataView.h
//  BWiOSComponents
//
//  Created by BobWong on 2016/12/6.
//  Copyright © 2016年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 空白页View
 */
@interface BMNoDataView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *eventButton;
@property (nonatomic, copy) dispatch_block_t tapActionBlock;

/**
 创建空白页

 @param tapActionBlock 点击回调
 */
+ (instancetype)emptyDataViewWithTapActionBlock:(dispatch_block_t)tapActionBlock;

/**
  创建空白页

 @param iconImagedName 图片
 @param title          title
 @param buttonTitle    按钮文字
 @param tapActionBlock 点击回调
 */
+ (instancetype)emptyDataViewWithIconImagedName:(NSString *)iconImagedName
                                          title:(NSString *)title
                                    buttonTitle:(NSString *)buttonTitle
                                 tapActionBlock:(dispatch_block_t)tapActionBlock;

@end
