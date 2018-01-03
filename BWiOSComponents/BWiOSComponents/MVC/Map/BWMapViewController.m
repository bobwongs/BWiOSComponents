//
//  BWMapViewController.m
//  BWiOSComponents
//
//  Created by BobWong on 2018/1/3.
//  Copyright © 2018年 BobWongStudio. All rights reserved.
//

#import "BWMapViewController.h"
#import "BMAmapViewController.h"

@interface BWMapViewController ()

@end

@implementation BWMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)amapAction:(id)sender {
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(23.0374, 113.39723);
    annotation.title = @"广东工业大学";
    annotation.subtitle = @"大学城校区";
    
    BMAmapViewController *amapViewController = [BMAmapViewController new];
    amapViewController.amapAnnotationArray = @[annotation];
    [self.navigationController pushViewController:amapViewController animated:YES];
}

@end
