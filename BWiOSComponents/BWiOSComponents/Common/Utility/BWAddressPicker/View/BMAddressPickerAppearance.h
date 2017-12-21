//
//  BMAddressPickerAppearance.h
//  AFNetworking
//
//  Created by BobWong on 2017/12/19.
//

#import <UIKit/UIKit.h>

/** 选择器外观配置类 */
@interface BMAddressPickerAppearance : NSObject

@property (nonatomic, strong) UIColor *textNormalColor;  ///< 文本的常规颜色
@property (nonatomic, strong) UIColor *textSelectedColor;  ///< 文本的选中颜色
@property (nonatomic, strong) UIColor *textPromptColor;  ///< 文本的提示颜色
@property (nonatomic, strong) UIColor *lineColor;  ///< 线条颜色

@property (nonatomic, copy) dispatch_block_t showHudBlock;  ///< 显示Hud的Block
@property (nonatomic, copy) dispatch_block_t dismissHudBlock;  ///< 隐藏Hud的Block

+ (instancetype)appearance;

@end
