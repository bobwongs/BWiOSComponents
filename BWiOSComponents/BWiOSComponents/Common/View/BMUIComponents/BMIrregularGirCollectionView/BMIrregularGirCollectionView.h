//
//  BMIrregularGirCollectionView.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/21.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMIrregularGridCellDataAdapter.h"

@class BMIrregularGridViewCellClassType;
@class BMIrregularGirCollectionView;
@class BMWhiteIrregularGridViewCell;

@protocol BMIrregularGridCollectionViewDelegate <NSObject>

@optional

/**
 不规则格子CollectionView 点击选择事件

 @param irregularGridCollectionView collectionGridView CollectionGridView 对象
 @param cell 类型
 @param event 事件
 */
- (void)irregularGridCollectionView:(BMIrregularGirCollectionView *)irregularGridCollectionView didSelectedCell:(BMWhiteIrregularGridViewCell *)cell event:(id)event;

@end

/**
 不规则格子collection View
 */
@interface BMIrregularGirCollectionView : UIView

@property (nonatomic, weak) id <BMIrregularGridCollectionViewDelegate> delegate;


@property (nonatomic, strong, readonly) UICollectionView *collectionView;

/**
 *  滚动方向, 默认 UICollectionViewScrollDirectionVertical.
 */
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

/**
 *  内容内边距, 默认是 UIEdgeInsetsMake(5, 5, 5, 5).
 */
@property (nonatomic) UIEdgeInsets contentEdgeInsets;

/**
 *  Item之间的间隔, 默认是 8.f.
 */
@property (nonatomic) CGFloat interitemSpacing;

/**
 *  Item之间的行距, 默认是 8.f.
 */
@property (nonatomic) CGFloat lineSpacing;

/**
 *  Item的高，默认 30.f.
 */
@property (nonatomic) CGFloat gridHeight;


/**
 注册的cells
 */
@property (nonatomic, strong) NSArray <BMIrregularGridViewCellClassType *> *registerCells;

/**
 *  The cells data adapter.
 */
@property (nonatomic, strong) NSMutableArray <BMIrregularGridCellDataAdapter *> *adapters;

//重置view的大小
- (void)resetSize;

// 实例化对象方法
+ (instancetype)irregularGridCollectionViewWithFrame:(CGRect)frame
                                            delegate:(id <BMIrregularGridCollectionViewDelegate>)delegate
                                       registerCells:(NSArray <BMIrregularGridViewCellClassType *> *)registerCells
                                     scrollDirection:(UICollectionViewScrollDirection)scrollDirection
                                   contentEdgeInsets:(UIEdgeInsets)edgeInsets
                                         lineSpacing:(CGFloat)lineSpacing
                                    interitemSpacing:(CGFloat)interitemSpacing
                                          gridHeight:(CGFloat)gridHeigh;

@end

#pragma mark - CollectionGridViewCellClassType Class

@interface BMIrregularGridViewCellClassType : NSObject

@property (nonatomic)         Class      className;
@property (nonatomic, strong) NSString  *reuseIdentifier;

@end


NS_INLINE BMIrregularGridViewCellClassType *gridViewCellClassType(Class className, NSString  *reuseIdentifier) {
    
    BMIrregularGridViewCellClassType *type = [BMIrregularGridViewCellClassType new];
    type.className                        = className;
    type.reuseIdentifier                  = reuseIdentifier.length ? reuseIdentifier : NSStringFromClass(className);
    
    return type;
}
