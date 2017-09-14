//
//  BMIrregularGirCollectionView.m
//  BMBlueMoonAngel
//
//  Created by BobWong on 2017/6/21.
//  Copyright © 2017年 BobWongStudio. All rights reserved.
//

#import "BMIrregularGirCollectionView.h"
#import "BMMaximumSpacingFlowLayout.h"
#import "BMWhiteIrregularGridViewCell.h"

@interface BMIrregularGirCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource,BMWhiteIrregularGridViewCellDelegate>

@property (nonatomic, strong) UICollectionView            *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout  *flowLayout;

@end

@implementation BMIrregularGirCollectionView

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.lineSpacing       = 8.f;
        self.interitemSpacing  = 8.f;
        self.gridHeight        = 30.f;
        self.scrollDirection   = UICollectionViewScrollDirectionVertical;
        
        // Init UICollectionViewFlowLayout.
        self.flowLayout = [[BMMaximumSpacingFlowLayout alloc] init];
        
        // Init UICollectionView.
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator   = NO;
        self.collectionView.backgroundColor                = [UIColor clearColor];
        self.collectionView.delegate                       = self;
        self.collectionView.dataSource                     = self;
        [self addSubview:self.collectionView];
    }
    
    return self;
}

- (void)makeTheConfigEffective {
    
    self.collectionView.contentInset        = self.contentEdgeInsets;
    self.flowLayout.minimumLineSpacing      = self.lineSpacing;
    self.flowLayout.minimumInteritemSpacing = self.interitemSpacing;
    self.flowLayout.scrollDirection         = self.scrollDirection;
}

#pragma mark - UICollectionView's delegate & data source.

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.adapters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BMIrregularGridCellDataAdapter *adapter = _adapters[indexPath.row];
    adapter.indexPath                     = indexPath;
    BMWhiteIrregularGridViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:adapter.cellReuseIdentifier forIndexPath:indexPath];
    
    cell.indexPath      = indexPath;
    cell.dataAdapter    = adapter;
    cell.collectionView = collectionView;
    cell.delegate       = self;
    cell.data           = adapter.data;
    [cell loadContent];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BMIrregularGridCellDataAdapter *adapter = _adapters[indexPath.row];
    return CGSizeMake(adapter.itemWidth, self.gridHeight);
}

#pragma mark - 公有方法

+ (instancetype)irregularGridCollectionViewWithFrame:(CGRect)frame
                                            delegate:(id <BMIrregularGridCollectionViewDelegate>)delegate
                                       registerCells:(NSArray <BMIrregularGridViewCellClassType *> *)registerCells
                                     scrollDirection:(UICollectionViewScrollDirection)scrollDirection
                                   contentEdgeInsets:(UIEdgeInsets)edgeInsets
                                         lineSpacing:(CGFloat)lineSpacing
                                    interitemSpacing:(CGFloat)interitemSpacing
                                          gridHeight:(CGFloat)gridHeight {
    
    BMIrregularGirCollectionView *irregularGridView = [[[self class] alloc] initWithFrame:frame];
    irregularGridView.delegate                     = delegate;
    irregularGridView.contentEdgeInsets            = edgeInsets;
    irregularGridView.scrollDirection              = scrollDirection;
    irregularGridView.lineSpacing                  = lineSpacing;
    irregularGridView.interitemSpacing             = interitemSpacing;
    irregularGridView.gridHeight                   = gridHeight;
    irregularGridView.registerCells                = registerCells;
    [irregularGridView makeTheConfigEffective];
    
    return irregularGridView;
}

- (void)setRegisterCells:(NSArray <BMIrregularGridViewCellClassType *> *)registerCells {
    
    _registerCells = registerCells;
    
    for (BMIrregularGridViewCellClassType *type in registerCells) {
        
        [self.collectionView registerClass:type.className forCellWithReuseIdentifier:type.reuseIdentifier];
    }
}

- (CGSize)contentSize {
    
    CGSize size = [_flowLayout collectionViewContentSize];
    
    size.width  += self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    size.height += self.contentEdgeInsets.top  + self.contentEdgeInsets.bottom;
    
    return size;
}

- (void)resetSize {
    
    CGRect newFrame = self.frame;
    newFrame.size   = [self contentSize];
    self.frame      = newFrame;
}

#pragma mark - WhiteIrregularGridViewCellDelegate

- (void)whiteIrregularGridViewCell:(BMWhiteIrregularGridViewCell *)cell event:(id)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(irregularGridCollectionView:didSelectedCell:event:)]) {
        [self.delegate irregularGridCollectionView:self didSelectedCell:cell event:event];
    }
}




@end

#pragma mark - IrregularGridViewCellClassType Class

@implementation BMIrregularGridViewCellClassType

@end


