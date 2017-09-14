//
//  BMFieldBtn1View.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/16.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge.h>

@interface BMFieldBtn1View : UIView <XXNibBridge>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *verticalLine;

@end
