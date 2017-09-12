//
//  BMValidCodeTimeModel.m
//  BMWash
//
//  Created by fenglh on 2016/10/24.
//  Copyright © 2016年 月亮小屋（中国）有限公司. All rights reserved.
//

#import "BMValidCodeTimeModel.h"

@implementation BMValidCodeTimeModel


//编码
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.lastFetchValidCodeDate forKey:@"lastFetchValidCodeDate"];
    [aCoder encodeObject:@(self.intervalSeconds) forKey:@"intervalSeconds"];
}

//解码
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.lastFetchValidCodeDate = [aDecoder decodeObjectForKey:@"lastFetchValidCodeDate"];
        self.intervalSeconds = [[aDecoder decodeObjectForKey:@"intervalSeconds"] unsignedIntegerValue];
    }
    return self;
}


@end
