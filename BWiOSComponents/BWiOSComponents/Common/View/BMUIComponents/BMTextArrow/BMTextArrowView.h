//
//  BMTextArrowView.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge.h>
#import "BMPlaceholderLabel.h"

@interface BMTextArrowView : UIView <XXNibBridge>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet BMPlaceholderLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (assign, nonatomic) BOOL selectionEnabled;  ///< 是否允许输入

- (void)setSelectionEnabled:(BOOL)selectionEnabled animation:(BOOL)animation;

/**
 添加手势，默认没有点击事件

 @param block 点击回调block
 */
- (void)setTap:(dispatch_block_t)block;
@end
