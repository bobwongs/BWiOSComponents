//
//  BMSelectorView.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/21.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMSelectorView.h"
#import "BMIrregularGirCollectionView.h"
#import <YYCategories.h>
#import "BMWhiteIrregularGridViewCell.h"

@interface BMSelectorView ()<BMIrregularGridCollectionViewDelegate>
@property (nonatomic, strong) BMIrregularGirCollectionView *irregularGridView;
@end
@implementation BMSelectorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}


- (void)setupSubviews {
    //创建格子视图
    BMIrregularGirCollectionView *irregularGridView;
    irregularGridView = [BMIrregularGirCollectionView irregularGridCollectionViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0)
                                                                                  delegate:self
                                                                             registerCells:@[gridViewCellClassType([BMWhiteIrregularGridViewCell class], nil)]
                                                                           scrollDirection:UICollectionViewScrollDirectionVertical
                                                                         contentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                               lineSpacing:8.f
                                                                          interitemSpacing:8.f
                                                                                gridHeight:30.f];
    
    irregularGridView.backgroundColor       = [UIColor whiteColor];
    [irregularGridView resetSize];
    [self addSubview:irregularGridView];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(irregularGridView.mas_bottom);
    }];
    self.irregularGridView = irregularGridView;
}

- (void)irregularGridCollectionView:(BMIrregularGirCollectionView *)irregularGridCollectionView didSelectedCell:(BMWhiteIrregularGridViewCell *)cell event:(id)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectorView:didSelectedIndex:)]) {
        [self.delegate selectorView:self didSelectedIndex:cell.indexPath.row];
    }
}

- (void)setContentList:(NSArray<id<BMSelectorObjectDelegate>> *)contentList {
    _contentList = contentList;
    NSMutableArray *array  = [NSMutableArray array];
    for (int i = 0; i < self.contentList.count; i++) {
        
        id<BMSelectorObjectDelegate> object = self.contentList[i];
        NSString *string    = object.content;
        BOOL selected = object.selected;
        UIFont *font        = [UIFont systemFontOfSize:12];
        CGFloat   value     = [string widthForFont:font] + 16.f;
        [array addObject:[BMWhiteIrregularGridViewCell dataAdapterWithData:string itemWidth:value selected:selected font:font]];
    }
    self.irregularGridView.adapters = array;
    [self.irregularGridView.collectionView reloadData];
    [self.irregularGridView resetSize];
}

@end
