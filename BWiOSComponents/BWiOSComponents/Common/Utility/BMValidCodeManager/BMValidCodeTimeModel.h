//
//  BMValidCodeTimeModel.h
//  BMWash
//
//  Created by fenglh on 2016/10/24.
//  Copyright © 2016年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 * 描述:验证时间model
 *
 */

@interface BMValidCodeTimeModel : NSObject<NSCoding>
@property (nonatomic, strong) NSDate *lastFetchValidCodeDate;//最后一次获取验证码时间
@property (nonatomic, assign) NSUInteger intervalSeconds;//获取验证码时间间隔

@end
