//
//  BWAddressPickerViewController.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWAddressPickerViewController.h"
#import "BMNewAddressPickerManager.h"
#import "BMAddressModel.h"

@interface BWAddressPickerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;

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
        
        __weak typeof(self) weakSelf = self;
        _addressPickerManager.didSelectBlock = ^(NSArray<BMAddressModel *> *selectedArray) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSMutableString *addressStr = [NSMutableString new];
            [selectedArray enumerateObjectsUsingBlock:^(BMAddressModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                [addressStr appendString:model.name];
            }];
            
            [strongSelf.button setTitle:addressStr forState:UIControlStateNormal];
        };
    }
    return _addressPickerManager;
}

@end
