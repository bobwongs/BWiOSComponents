//
//  BMTextFieldView.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge.h>

@interface BMTextFieldView : UIView<XXNibBridge>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, assign) NSUInteger maxCharacterCount;     //最大字数

@property (assign, nonatomic) BOOL inputEnabled;  ///< 是否允许输入

@end
