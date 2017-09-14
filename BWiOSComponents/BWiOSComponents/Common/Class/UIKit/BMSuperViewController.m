//
//  BMSuperViewController.m
//  BWiOSComponents
//
//  Created by BobWong on 2017/8/17.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMSuperViewController.h"

@interface BMSuperViewController ()

@end

@implementation BMSuperViewController

#pragma mark - Life Cycle

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;  // 默认隐藏，需要显示的地方再设成NO
//        _preloadingViewType = BMPreloadingViewTypeDefault;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.view.backgroundColor = BMb2b_page_color;  // 页面通用背景色
    
    [self bmB2B_setDefaultNavigationBackItem];  // 默认有返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;  // 从第二个VC开始，支持手势右滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"-viewDidAppear: %@ ,title:%@",NSStringFromClass([self class]),self.title);
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;  // 第一个VC禁用，兼容右滑第一个页面三下会页面卡死的问题
    }
//    if (_preloadingViewType == BMPreloadingViewTypeColorView) {
//        [self.view addSubview:self.preloadingView];
//        [self.preloadingView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(self.view);
//        }];
//    }
}

- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

#pragma mark - Public Method

- (void)bmB2B_setDefaultNavigationBackItem {
    [self bmB2B_setNavigationBackItemWithImage:[UIImage imageNamed:@"back"]];
}

- (void)bmB2B_setNavigationBackItemWithImage:(UIImage *)image {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 24, 24);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(bmB2B_backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    CGFloat spaceWidth = -20 + 12;  // 直接在这里进行设置，不用在上面调整水平位置
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];  // 创建UIBarButtonSystemItemFixedSpace
    spaceItem.width = spaceWidth;  // 创建UIBarButtonSystemItemFixedSpace的Item，让BarButtonItem紧靠屏幕边缘
    
    self.navigationItem.leftBarButtonItems = @[spaceItem, leftItem];
}

- (void)bmB2B_hideBackButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    self.navigationItem.leftBarButtonItems = @[item];
}

- (void)bmB2B_enablePopGestureRecognizer {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)bmB2B_disenablePopGestureRecognizer {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - Action

- (void)bmB2B_backAction {
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Setter and Getter

//- (UIView *)preloadingView {
//    if (!_preloadingView) {
//        _preloadingView = [UIView new];
//        _preloadingView.backgroundColor = BMb2b_page_color;
//    }
//    return _preloadingView;
//}

@end
