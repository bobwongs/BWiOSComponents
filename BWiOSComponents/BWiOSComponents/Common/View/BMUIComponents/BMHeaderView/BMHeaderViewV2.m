//
//  BMHeaderView.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/19.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMHeaderViewV2.h"

@implementation BMHeaderViewV2

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        BMHeaderViewV2 *view = (BMHeaderViewV2 *)[[[NSBundle mainBundle] loadNibNamed:@"BMHeaderViewV2" owner:nil options:0] firstObject];;
        
        self = view;
    }
    return self;
}
@end
