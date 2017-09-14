//
//  BMTextFieldCell.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMTextFieldView.h"

@interface BMTextFieldCell : UITableViewCell

@property (copy, nonatomic) NSString *title;  ///< Title
@property (copy, nonatomic) NSString *content;  ///< Content
@property (assign, nonatomic) BOOL lineHidden;  ///< 是否隐藏底部线条，默认显示

@property (weak, nonatomic) IBOutlet BMTextFieldView *containerView;  ///< 容器视图

@end
