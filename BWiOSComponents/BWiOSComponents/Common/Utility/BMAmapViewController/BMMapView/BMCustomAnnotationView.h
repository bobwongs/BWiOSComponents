//
//  BMCustomAnnotationView.h
//  BWiOSComponents
//
//  Created by BobWong on 2017/11/30.
//  Copyright © 2017年 BobWong. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface BMNaviButton : UIButton

@property (nonatomic, strong) UIImageView *carImageView;
@property (nonatomic, strong) UILabel *naviLabel;

@end

@interface BMCustomAnnotationView : MAPinAnnotationView

@property (nonatomic, copy) dispatch_block_t navigationBlock;

- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
