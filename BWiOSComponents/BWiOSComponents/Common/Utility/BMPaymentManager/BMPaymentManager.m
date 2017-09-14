//
//  BMPaymentManager.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 16/11/14.
//  Copyright © 2016年 elvin. All rights reserved.
//

#import "BMPaymentManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPaymentControl.h"
#import "WXApi.h"

NSString *const BMNOTIFICATION_PAY_SUCCESS = @"BMNOTIFICATION_PAY_SUCCESS";
NSString *const BMNOTIFICATION_PAY_FAILURE = @"BMNOTIFICATION_PAY_FAILURE";

// 支付宝
#define kAlipayAppScheme @"bundleId.AliPay"
#define kAlipayURLHostSafePay @"safepay"  // 从支付宝App跳转回来的支付URL Host

// 微信
#define kWeiXinDescription @"BWiOSComponents"
#define kWeiXinPackage @"Sign=WXPay"
//#define kWeiXinMchid @""  // 微信商户号，不用前端传
#define kWeChatPaySign @"sign"
#define kWeChatPayPartnerId @"_Mch_id"
#define kWeChatPayPrepayId @"prepay_id"
#define kWeChatPayNonceStr @"nonceStr"
#define kWeChatPayTimeStamp @"timeStamp"

// 银联
NSString *const BMUnionPayAppScheme = @"bundleId.UPPay";  // 跳转回来的App Scheme
NSString *const BMUnionPayModeProduction = @"00";  // 生产环境（正式），当前后端银联支付的测试环境和生产环境都为生产Mode
//NSString *const BMUnionPayModeDevelopment = @"01";  // 开发环境（测试）

@interface BMPaymentManager () <WXApiDelegate>

@end

@implementation BMPaymentManager

#pragma mark - 单例

+ (instancetype)sharedInstance
{
    static BMPaymentManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BMPaymentManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 支付宝

- (void)alipayWithOrder:(NSString *)orderString {
    __weak typeof(self) weakSelf = self;
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:kAlipayAppScheme callback:^(NSDictionary *resultDic) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        // 没有安装支付宝客户端，网页支付的回调
        NSLog(@"reslut = %@",resultDic);
        [strongSelf alipayProcessResult:resultDic];
    }];
}

- (void)alipayFinishPaymentFromAppWithOpenURL:(NSURL *)url {
    if (![url.host isEqualToString:kAlipayURLHostSafePay]) {
        return ;
    }
    
    //跳转支付宝钱包进行支付，处理支付结果
    __weak typeof(self) weakSelf = self;
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        // 从支付宝App回到月亮天使
        NSLog(@"reslut = %@",resultDic);
        [strongSelf alipayProcessResult:resultDic];
    }];
}

- (void)alipayProcessResult:(NSDictionary *)resultDict {
    /*
     通过通知来传递支付结果，参数值说明
     9000: 支付成功
     8000: 支付处理中
     4000: 支付失败
     6001: 用户取消
     6002: 支付网络错误
     */
    NSInteger errorCode = [resultDict[@"resultStatus"] integerValue];
    
    switch (errorCode) {
        case 9000:
            // 支付成功
            [self paySuccessfully];
            break;
            //        case 6001:
            //            // 用户取消，什么都不做处理
            //            break;
            
        default:
            // 支付失败
            [self payUnsuccessfully];
            break;
    }
}

#pragma mark - 微信

- (BOOL)isWXAppInstalled {
    if (![WXApi isWXAppInstalled]) {
//        [BMShowHUD showInfoToView:[[UIApplication bm_topViewController] view] withText:@"找不到微信客户端"];
        return NO;
    }
    return YES;
}

- (void)wxApiPayWithPartnerId:(NSString *)partnerId
                     prepayId:(NSString *)prepayId
                     nonceStr:(NSString *)nonceStr
                    timeStamp:(UInt32)timeStamp
                         sign:(NSString *)sign {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = partnerId;
    request.prepayId = prepayId;
    request.package = kWeiXinPackage;
    request.nonceStr = nonceStr;
    request.timeStamp = timeStamp;
    request.sign = sign;
    [WXApi sendReq:request];
}

- (void)wxApiPayWithPayInfoString:(NSDictionary *)payInfo {
    [[BMPaymentManager sharedInstance] wxApiPayWithPartnerId:payInfo[kWeChatPayPartnerId] prepayId:payInfo[kWeChatPayPrepayId] nonceStr:payInfo[kWeChatPayNonceStr] timeStamp:[payInfo[kWeChatPayTimeStamp] unsignedIntValue] sign:payInfo[kWeChatPaySign]];
}

- (void)wxApiHandleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp *)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [self paySuccessfully];
                break;
                //            case WXErrCodeUserCancel:
                //                // 用户点击取消并返回，App什么都不做
                //                NSLog(@"用户点击取消并返回");
                //                break;
                
            default:
                NSLog(@"支付失败，retcode=%d", resp.errCode);
                [self payUnsuccessfully];
                break;
        }
    }
}

#pragma mark - 银联

- (void)unionPayWithTn:(NSString *)tn viewController:(UIViewController *)viewController {
//    NSString *mode = kBMIsTestEnvironment ? BMUnionPayModeDevelopment : BMUnionPayModeProduction;
    [[UPPaymentControl defaultControl] startPay:tn fromScheme:BMUnionPayAppScheme mode:BMUnionPayModeProduction viewController:viewController];
}

- (void)unionPayFinishPaymentWithOpenURL:(NSURL *)url {
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        if (!code) return;  // 当前这样判断如果没有code，则代表不是银联这一种支付方式，银联再这方面没做好，没对url进行判断，如果不是自家url打开的App，应该不要去做回调的
        
        if ([code isEqualToString:@"success"]) {
            // 支付成功
            [self paySuccessfully];
        } else {
            // 其他，支付失败、交易取消
            [self payUnsuccessfully];
        }
    }];
}

#pragma mark - 公共

- (void)paySuccessfully {
    [[NSNotificationCenter defaultCenter] postNotificationName:BMNOTIFICATION_PAY_SUCCESS object:nil userInfo:nil];
}

- (void)payUnsuccessfully {
    [[NSNotificationCenter defaultCenter] postNotificationName:BMNOTIFICATION_PAY_FAILURE object:nil userInfo:nil];
}

- (void)payFinishHandleOpenURL:(NSURL *)url {
    [[BMPaymentManager sharedInstance] alipayFinishPaymentFromAppWithOpenURL:url];
    [[BMPaymentManager sharedInstance] wxApiHandleOpenURL:url];
    [[BMPaymentManager sharedInstance] unionPayFinishPaymentWithOpenURL:url];
}

@end
