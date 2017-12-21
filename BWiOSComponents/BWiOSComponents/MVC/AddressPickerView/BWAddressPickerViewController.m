//
//  BWAddressPickerViewController.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWAddressPickerViewController.h"
#import "BWAddressPicker.h"
#import "BWRegionModel.h"

@interface BWAddressPickerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (strong, nonatomic) BWAddressPicker *addressPicker;  ///< Address picker manager
@property (strong, nonatomic) BWAddressPicker *selectedAddressPicker;

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
    [self.addressPicker show];
}

- (IBAction)pickSelectedAddressAction:(id)sender {
    [self.selectedAddressPicker show];
}

#pragma mark - Setter and Getter

- (BWAddressPicker *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [BWAddressPicker new];
        
        __weak typeof(self) weakSelf = self;
        _addressPicker.didSelectBlock = ^(NSArray<BWRegionModel *> *selectedArray) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSMutableString *addressStr = [NSMutableString new];
            [selectedArray enumerateObjectsUsingBlock:^(BWRegionModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                [addressStr appendString:model.dname];
            }];
            
            [strongSelf.button setTitle:addressStr forState:UIControlStateNormal];
        };
    }
    return _addressPicker;
}

- (BWAddressPicker *)selectedAddressPicker {
    if (!_selectedAddressPicker) {
        _selectedAddressPicker = [BWAddressPicker new];
        
        __weak typeof(self) weakSelf = self;
        _selectedAddressPicker.didSelectBlock = ^(NSArray<BWRegionModel *> *selectedArray) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSMutableString *addressStr = [NSMutableString new];
            [selectedArray enumerateObjectsUsingBlock:^(BWRegionModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                [addressStr appendString:model.dname];
            }];
            
            [strongSelf.secondButton setTitle:addressStr forState:UIControlStateNormal];
        };
        
        BWRegionModel *provinceModel = [BWRegionModel new];
        provinceModel.dcode = @(44).stringValue;
        provinceModel.type = @"province";
        provinceModel.dname = @"广东";
        
        BWRegionModel *cityModel = [BWRegionModel new];
        cityModel.dcode = @(4401).stringValue;
        cityModel.type = @"city";
        cityModel.dname = @"广州";
        
        BWRegionModel *countyModel = [BWRegionModel new];
        countyModel.dcode = @(440106).stringValue;
        countyModel.type = @"county";
        countyModel.dname = @"天河区";
        
        [_selectedAddressPicker setAddressWithSelectedAddressArray:@[provinceModel, cityModel, countyModel]];
        
        NSString *secondTitle = [NSString stringWithFormat:@"%@%@%@", provinceModel.dname, cityModel.dname, countyModel.dname];
        [_secondButton setTitle:secondTitle forState:UIControlStateNormal];
    }
    return _selectedAddressPicker;
}

@end
