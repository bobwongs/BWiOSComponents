//
//  BMNewAddressPickerCell.h
//  BMWash
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BM_NEW_ADDRESS_PICKER_UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define BM_NEW_ADDRESS_PICKER_333333 BM_NEW_ADDRESS_PICKER_UIColorFromRGB(0x333333)

@interface BMNewAddressPickerCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;  ///< Text

@end
