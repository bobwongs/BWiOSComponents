//
//  BMWhiteIrregularGridViewCell.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/21.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMIrregularGridCellDataAdapter.h"

@class BMWhiteIrregularGridViewCell;

@protocol BMWhiteIrregularGridViewCellDelegate <NSObject>

@optional

- (void)whiteIrregularGridViewCell:(BMWhiteIrregularGridViewCell *)cell event:(id)event;

@end


@interface BMWhiteIrregularGridViewCell : UICollectionViewCell


@property (nonatomic, weak) id <BMWhiteIrregularGridViewCellDelegate> delegate;
@property (nonatomic, weak) id                                       data;
@property (nonatomic, weak) BMIrregularGridCellDataAdapter            *dataAdapter;
@property (nonatomic, weak) UICollectionView                        *collectionView;
@property (nonatomic, strong) NSIndexPath                             *indexPath;



+ (BMIrregularGridCellDataAdapter *)dataAdapterWithData:(id)data itemWidth:(CGFloat)itemWidth selected:(BOOL)selected font:(UIFont *)font;
+ (BMIrregularGridCellDataAdapter *)dataAdapterWithData:(id)data itemWidth:(CGFloat)itemWidth selected:(BOOL)selected ;
+ (BMIrregularGridCellDataAdapter *)dataAdapterWithData:(id)data itemWidth:(CGFloat)itemWidth;
- (void)setupCell;
- (void)loadContent;

@end
