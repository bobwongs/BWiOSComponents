//
//  BMPaymentManager.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 16/11/14.
//  Copyright © 2016年 elvin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const BMNOTIFICATION_PAY_SUCCESS;
extern NSString *const BMNOTIFICATION_PAY_FAILURE;

@interface BMPaymentManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  支付宝支付
 *  @param orderString 订单号
 */
- (void)alipayWithOrder:(NSString *)orderString;


/** 是否安装了微信 */
- (BOOL)isWXAppInstalled;
/** 微信支付 从外部逐个传递必要的参数 */
- (void)wxApiPayWithPartnerId:(NSString *)partnerId
                     prepayId:(NSString *)prepayId
                     nonceStr:(NSString *)nonceStr
                    timeStamp:(UInt32)timeStamp
                         sign:(NSString *)sign;

/** 微信支付 传入生成的payInfo */
- (void)wxApiPayWithPayInfoString:(NSDictionary *)payInfo;


/**
 *  银联支付
 *  @param tn 订单信息
 *  @param viewController 支付所在的VC
 */
- (void)unionPayWithTn:(NSString *)tn viewController:(UIViewController *)viewController;


/**
 *  从支付App完成支付回跳回来的处理
 *  @param url 打开本应用的URL
 */
- (void)payFinishHandleOpenURL:(NSURL *)url;

@end
