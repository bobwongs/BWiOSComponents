//
//  BMSidesMenuCell.h
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/4/19.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BM_SIDES_MENU_WIDTH 100.0  // Menu width
#define BM_SIDES_MENU_CELL_HEIGHT 50.0  // Menu cell height

#define BM_SIDES_MENU_UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

typedef NS_ENUM(NSInteger, BMSidesMenuShowType) {
    BMSidesMenuShowTypeNone,
    BMSidesMenuShowTypeNotSelected,
    BMSidesMenuShowTypeSelected,
};

@interface BMSidesMenuCell : UITableViewCell

/*
 UI
 */
@property (strong, nonatomic) UIView *selectedTagView;  ///< Selected tag view
@property (strong, nonatomic) UILabel *titleLabel;  ///< Title label
@property (strong, nonatomic) UIImageView *lineImageView;  ///< Line image view

/*
 Data
 */
@property (assign, nonatomic) BMSidesMenuShowType showType;  ///< Show type

@end
