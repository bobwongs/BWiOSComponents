//
//  BMNewAddressPickerManager.h
//  BMWash
//
//  Created by BobWong on 2017/5/26.
//  Copyright © 2017年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMNewAddressPickerManager : NSObject

- (void)show;
- (void)dismiss;

@end


@interface BMNewAddressModel : NSObject

@property (strong, nonatomic) NSString *dcode;  ///< 区域编码
@property (strong, nonatomic) NSString *dname;  ///< 区域名称
@property (strong, nonatomic) NSString *pcode;  ///< 上级区域编码
@property (strong, nonatomic) NSString *type;  ///< 区域类型

@end
