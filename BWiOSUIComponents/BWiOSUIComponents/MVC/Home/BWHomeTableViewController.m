//
//  BWHomeTableViewController.m
//  BWiOSUIComponents
//
//  Created by BobWong on 2017/6/1.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BWHomeTableViewController.h"

NSString *const BWKeyTitle = @"BWKeyTitle";
NSString *const BWKeySegueId = @"BWKeySegueId";

NSString *const BWCellId = @"BWCellId";

@interface BWHomeTableViewController ()

@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation BWHomeTableViewController

- (instancetype)init {
    if (self = [super init]) {
        NSDictionary *addressPickerDict = @{
                                            BWKeyTitle: @"AddressPicker",
                                            BWKeySegueId: @"home_to_address_picker"
                                            };
        
        _dataSource = @[addressPickerDict];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BWCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BWCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = _dataSource[indexPath.row][BWKeyTitle];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:_dataSource[indexPath.row][BWKeySegueId] sender:nil];
}

@end
