//
//  UserSelectedCollectionView.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/14.
//

#import "UserSelectedCollectionView.h"
#import "UserSelectedCollectionViewCell.h"
#import "UserModel.h"

#define kCellIdentifier @"UserSelectedCollectionCellIdentifier"

@interface UserSelectedCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UserSelectedCollectionViewCellDelegate>

@end

@implementation UserSelectedCollectionView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    self.bounces = NO;
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([UserSelectedCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
}

-(void)setDataSourceArray:(NSArray *)dataSourceArray {
    _dataSourceArray = dataSourceArray;
    [self reloadData];
    NSInteger position = dataSourceArray.count - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:position inSection:0];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:true];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = kCellIdentifier;
    UserModel *model = self.dataSourceArray[indexPath.row];
    UserSelectedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = model;
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UserSelectedCollectionViewDelegate

- (void)userSelectedCollectionViewCell:(UserSelectedCollectionViewCell *)cell deleteButtonDidClick:(UIButton *)sender {
    if ([self.customDelegate respondsToSelector:@selector(userSelectedCollectionView:deleteButtonDidClick:)]) {
        [self.customDelegate userSelectedCollectionView:self deleteButtonDidClick:cell.model];
    }
}

@end
