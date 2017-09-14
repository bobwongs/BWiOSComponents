//
//  BMFieldBtn2View.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge.h>

@interface BMFieldBtn2View : UIView <XXNibBridge>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) NSString *placeholderString;  ///< 提示语

@end
