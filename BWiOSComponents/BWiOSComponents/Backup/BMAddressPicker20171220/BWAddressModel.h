//
//  BWAddressModel.h
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWAddressModel : NSObject

@property (assign, nonatomic) NSInteger code;  ///< 区域编码
@property (strong, nonatomic) NSString *name;  ///< 区域名称
@property (assign, nonatomic) NSInteger parentCode;  ///< 上级区域编码
@property (strong, nonatomic) NSString *type;  ///< 区域类型

@end
