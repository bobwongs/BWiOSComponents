//
//  BMValidCodeTimeManager.h
//  B2BMall
//
//  Created by BobWong on 2016/10/24.
//  Copyright © 2016年 月亮小屋（中国）有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BMValidCodeTimeType) {
    BMValidCodeTimeTypeQuickLogin = 1,
    BMValidCodeTimeTypeRegister,
    BMValidCodeTimeTypeForgetPassword,
};

/** 描述:验证码管理类,多个地方用到验证码倒计时功能，所以封装此类以复用 */
@interface BMValidCodeTimeManager : NSObject

+ (instancetype)sharedInstance;

//开启按钮倒计时,注：按钮的类型必须设置为custom,否则会一闪一闪的效果
- (void)startCountDownAnimationInButton:(UIButton *)btn withType:(BMValidCodeTimeType)type;

//继续上一次倒计时,例如：上一次倒计时还没有完成，用户返回或者退出
- (void)continuteLastCountDownAnimation:(UIButton *)btn withType:(BMValidCodeTimeType)type;

@end
