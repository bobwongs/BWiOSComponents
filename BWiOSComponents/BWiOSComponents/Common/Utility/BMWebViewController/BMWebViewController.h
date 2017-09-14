//
//  BMWebViewController.h
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/4.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMSuperViewController.h"

@interface BMWebViewController : BMSuperViewController

@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) UIImage *backButtonImage;  ///< 默认为白色返回

@end
