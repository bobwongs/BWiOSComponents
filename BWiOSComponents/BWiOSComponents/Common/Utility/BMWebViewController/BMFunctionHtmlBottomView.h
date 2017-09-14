//
//  BMFunctionHtmlBottomView.h
//  BWiOSComponents
//
//  Created by BobWong on 17/4/13.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//
typedef void(^blockExpand)();//点击展开的操作
typedef void(^blockLeave)();//点击离开的操作
typedef void(^blockFresh)();//点击刷新的操作
typedef void(^blockUrgent)();//点击收紧的操作
#import <UIKit/UIKit.h>
@interface BMFunctionHtmlBottomView : UIView
@property(nonatomic, strong) blockExpand blockExpand;
@property(nonatomic, strong) blockLeave blockLeave;
@property(nonatomic, strong) blockFresh blockFresh;
@property(nonatomic, strong) blockUrgent blockUrgent;
+(instancetype)functionHtmlBottomView;
@end
