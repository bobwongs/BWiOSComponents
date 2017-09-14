//
//  BMPlaceholderLabel.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/21.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 placeholder Label，当text = nil 或 text = @""时，显示placeholder
 */
@interface BMPlaceholderLabel : UILabel
@property (strong, nonatomic) UILabel *placeholderLabel;

@end
