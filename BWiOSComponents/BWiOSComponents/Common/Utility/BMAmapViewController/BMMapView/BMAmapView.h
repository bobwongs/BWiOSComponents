//
//  BMAmapView.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/11/30.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAPointAnnotation.h>

@interface BMAmapView : UIView

@property (nonatomic, strong) NSArray<MAPointAnnotation *> *annotationArray;  ///< 标注点坐标

@end
