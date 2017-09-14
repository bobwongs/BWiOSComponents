//
//  BMTextLineView.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XXNibBridge.h>
#import "BMPlaceholderLabel.h"

@interface BMTextLineView : UIView <XXNibBridge>

@property (weak, nonatomic) IBOutlet BMPlaceholderLabel *titleLabel;
@property (weak, nonatomic) IBOutlet BMPlaceholderLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
