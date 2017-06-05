//
//  BWAddressPickerViewController.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWAddressPickerViewController.h"
#import "BWAddressPickerManager.h"
#import "BWAddressModel.h"

@interface BWAddressPickerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (strong, nonatomic) BWAddressPickerManager *addressPickerManager;  ///< Address picker manager
@property (strong, nonatomic) BWAddressPickerManager *selectedAddressPickerManager;

@end

@implementation BWAddressPickerViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.button.layer.cornerRadius = 10.0;
    self.secondButton.layer.cornerRadius = 10.0;
}

- (void)dealloc {
    NSLog(@"Dealloc %@", NSStringFromClass([self class]));
}

#pragma mark - Action

- (IBAction)pickAddressAction:(id)sender {
    [self.addressPickerManager show];
}

- (IBAction)pickSelectedAddressAction:(id)sender {
    [self.selectedAddressPickerManager show];
}

#pragma mark - Setter and Getter

- (BWAddressPickerManager *)addressPickerManager {
    if (!_addressPickerManager) {
        _addressPickerManager = [BWAddressPickerManager new];
        
        __weak typeof(self) weakSelf = self;
        _addressPickerManager.didSelectBlock = ^(NSArray<BWAddressModel *> *selectedArray) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSMutableString *addressStr = [NSMutableString new];
            [selectedArray enumerateObjectsUsingBlock:^(BWAddressModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                [addressStr appendString:model.name];
            }];
            
            [strongSelf.button setTitle:addressStr forState:UIControlStateNormal];
        };
    }
    return _addressPickerManager;
}

- (BWAddressPickerManager *)selectedAddressPickerManager {
    if (!_selectedAddressPickerManager) {
        _selectedAddressPickerManager = [BWAddressPickerManager new];
        
        __weak typeof(self) weakSelf = self;
        _selectedAddressPickerManager.didSelectBlock = ^(NSArray<BWAddressModel *> *selectedArray) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSMutableString *addressStr = [NSMutableString new];
            [selectedArray enumerateObjectsUsingBlock:^(BWAddressModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                [addressStr appendString:model.name];
            }];
            
            [strongSelf.secondButton setTitle:addressStr forState:UIControlStateNormal];
        };
        
        BWAddressModel *provinceModel = [BWAddressModel new];
        provinceModel.code = 44;
        provinceModel.type = @"province";
        provinceModel.name = @"广东";
        
        BWAddressModel *cityModel = [BWAddressModel new];
        cityModel.code = 4401;
        cityModel.type = @"city";
        cityModel.name = @"广州";
        
        BWAddressModel *countyModel = [BWAddressModel new];
        countyModel.code = 440106;
        countyModel.type = @"county";
        countyModel.name = @"天河区";
        
        [_selectedAddressPickerManager setAddressWithSelectedAddressArray:@[provinceModel, cityModel, countyModel]];
    }
    return _selectedAddressPickerManager;
}

@end
