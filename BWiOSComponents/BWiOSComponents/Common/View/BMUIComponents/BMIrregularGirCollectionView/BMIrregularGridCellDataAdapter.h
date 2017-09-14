//
//  BMIrregularGridCellDataAdapter.h
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/21.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 适配器模型
 */
@interface BMIrregularGridCellDataAdapter : NSObject

/**
 *  数据
 */
@property (nonatomic, strong) id             data;

/**
 *  重用标识符
 */
@property (nonatomic, strong) NSString      *cellReuseIdentifier;

/**
 *  cell 的 indexPath
 */
@property (nonatomic, strong)   NSIndexPath   *indexPath;

/**
 *  cell 的类型
 */
@property (nonatomic)         NSInteger      cellType;

/**
 *  Item 宽
 */
@property (nonatomic)         CGFloat        itemWidth;


/**
 是否被选中
 */
@property (nonatomic)         BOOL           selected;

/**
 字体
 */
@property (nonatomic)         UIFont        *font;

+ (instancetype)collectionGridCellDataAdapterWithCellReuseIdentifier:(NSString *)cellReuseIdentifier data:(id)data
                                                            cellType:(NSInteger)cellType itemWidth:(CGFloat)itemWidth selected:(BOOL)selected font:(UIFont *)font;
@end
