//
//  BMSelectorObjectDelegate.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/22.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 contentList 元素对象协议，这里使delagate代替model，方便扩展
 */
@protocol BMSelectorObjectDelegate <NSObject>
@required
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL selected;
@end
