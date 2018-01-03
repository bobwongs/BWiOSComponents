//
//  BMAmapViewController.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/12/4.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAPointAnnotation.h>

@interface BMAmapViewController : UIViewController

@property (nonatomic, strong) NSArray<MAPointAnnotation *> *baiduAnnotationArray;  ///< 标注点坐标，百度坐标系
@property (nonatomic, strong) NSArray<MAPointAnnotation *> *amapAnnotationArray;  ///< 标注点坐标，高德坐标系

@end
