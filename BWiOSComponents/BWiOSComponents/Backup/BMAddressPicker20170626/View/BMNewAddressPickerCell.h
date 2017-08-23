//
//  BMNewAddressPickerCell.h
//  BMiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BM_ADDRESS_PICKER_UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#define BM_ADDRESS_PICKER_333333 BM_ADDRESS_PICKER_UIColorFromRGB(0x333333)
#define BM_ADDRESS_PICKER_999999 BM_ADDRESS_PICKER_UIColorFromRGB(0x999999)
#define BM_ADDRESS_PICKER_1fb8ff BM_ADDRESS_PICKER_UIColorFromRGB(0x1fb8ff)
#define BM_ADDRESS_PICKER_e5e5e5 BM_ADDRESS_PICKER_UIColorFromRGB(0xe5e5e5)

@interface BMNewAddressPickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
