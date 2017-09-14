//
//  BMCartProductInputView.h
//  BWiOSComponents
//
//  Created by ___liangdahong on 2017/9/1.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge/XXNibBridge.h>

/**
 购物车产品Cell中的产品数量View
 */
@interface BMCartProductInputView : UIView <XXNibBridge>

@property (weak, nonatomic) IBOutlet UIButton *addButton; ///< 加按钮
@property (weak, nonatomic) IBOutlet UIButton *subButton; ///<  减按钮
@property (weak, nonatomic) IBOutlet UILabel *countLabel; ///< 数量label
@property (copy, nonatomic) dispatch_block_t inputBlock;  ///< 输入点击
@property (copy, nonatomic) dispatch_block_t addBlock;    ///< 加按钮点击
@property (copy, nonatomic) dispatch_block_t subBlock;    ///< 减按钮点击

@property (assign, nonatomic) NSInteger num; ///< num

@end
