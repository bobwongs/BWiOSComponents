//
//  BWAddressPickerViewController.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWAddressPickerViewController.h"
#import "BMNewAddressPickerManager.h"

@interface BWAddressPickerViewController ()

@property (strong, nonatomic) BMNewAddressPickerManager *addressPickerManager;  ///< Address picker manager

@end

@implementation BWAddressPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pickAddressAction:(id)sender {
    [self.addressPickerManager show];
}

- (BMNewAddressPickerManager *)addressPickerManager {
    if (!_addressPickerManager) {
        _addressPickerManager = [BMNewAddressPickerManager new];
    }
    return _addressPickerManager;
}

@end
