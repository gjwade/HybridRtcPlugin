//
//  UserSelectedCollectionView.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UserSelectedCollectionView;
@class UserModel;

@protocol UserSelectedCollectionViewDelegate <NSObject>

- (void)userSelectedCollectionView: (UserSelectedCollectionView *)collectionView deleteButtonDidClick: (UserModel *)model;

@end

@interface UserSelectedCollectionView : UICollectionView

@property(nonatomic, strong)NSArray *dataSourceArray;
@property(nonatomic, weak)id<UserSelectedCollectionViewDelegate> customDelegate;

@end

NS_ASSUME_NONNULL_END
