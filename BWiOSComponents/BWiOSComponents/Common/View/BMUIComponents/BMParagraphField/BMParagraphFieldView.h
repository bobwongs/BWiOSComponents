//
//  BMParagraphFieldView.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/6.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge.h>

@interface BMParagraphFieldView : UIView <XXNibBridge>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign) NSUInteger maxCount;     // 最大字数，默认为50
@property (strong, nonatomic) NSString *placeholder;  // Input textview placeholder

- (void)refreshCountAndLimitTextLength;

@end
