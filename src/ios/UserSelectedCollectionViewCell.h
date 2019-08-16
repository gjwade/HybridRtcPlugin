//
//  UserSelectedCollectionViewCell.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/14.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@class UserSelectedCollectionViewCell;

@protocol UserSelectedCollectionViewCellDelegate <NSObject>

- (void)userSelectedCollectionViewCell: (UserSelectedCollectionViewCell *)cell deleteButtonDidClick: (UIButton *)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface UserSelectedCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UserModel *model;
@property(nonatomic, weak)id<UserSelectedCollectionViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
