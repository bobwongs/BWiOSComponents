//
//  BMWebViewController.m
//  BWPhysicsLab
//
//  Created by BobWong on 2017/9/4.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMWebViewController.h"
#import <Masonry.h>
//#import "BMFunctionHtmlBottomView.h"

@interface BMWebViewController () <UIWebViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic, strong) BMFunctionHtmlBottomView *bottomView;

@end

@implementation BMWebViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backButtonImage = self.backButtonImage ? self.backButtonImage : [UIImage imageNamed:@"back"];
    [self bmB2B_setNavigationBackItemWithImage:backButtonImage];
    
    [self loadData];
    [self setUI];
}

- (void)dealloc {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - Private Method

- (void)setUI {
    [self.view addSubview:self.webView];
//    [self.view addSubview:self.bottomView];
}

- (void)bmB2B_backAction {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        if ([self canVcPodViewController]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self loadData];
        }
    }
}

- (void)loadData {
    [BMGifLoadingHUD show];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
    NSLog(@"web页地址：%@",self.urlString);
}

- (BOOL)canVcPodViewController {
    if([self.navigationController.viewControllers firstObject] == self) {
        return NO;
    }
    return YES;
}

#pragma mark - UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    [BMGifLoadingHUD dismiss];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.title == nil || [self.title isEqualToString:@""]) {
        self.title=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    // 如果还是没有，暂用AppName
    if (self.title == nil || [self.title isEqualToString:@""]) {
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        self.title = appName;
    }
    
    [BMGifLoadingHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] != NSURLErrorCancelled) {
        self.navigationItem.leftBarButtonItem.customView.hidden = NO;
        [BMGifLoadingHUD dismiss];
        NSLog(@"%@",error);
    }
}

#pragma mark - Setter and Getter

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.bounces = NO;
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _webView;
}

//- (BMFunctionHtmlBottomView *)bottomView
//{
//    if (_bottomView == nil) {
//        _bottomView = [BMFunctionHtmlBottomView functionHtmlBottomView];
//        __weak BMWebViewController *weakSelf = self;
//        _bottomView.blockLeave = ^{
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        };
//        _bottomView.blockFresh = ^{
//            [weakSelf.webView reload];
//        };
//    }
//    return _bottomView;
//}

@end
