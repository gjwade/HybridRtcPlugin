//
//  UserSelectViewController.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/12.
//

#import <UIKit/UIKit.h>
@class UserSelectViewController;

@protocol UserSelectViewControllerDelegate <NSObject>

- (void)userSelectViewController: (UserSelectViewController *)viewController confirmButtonDidClick: (NSArray *)selectedUsers;

@end

NS_ASSUME_NONNULL_BEGIN

@interface UserSelectViewController : UIViewController

@property(nonatomic, strong)NSArray *disabledUserList;
@property(nonatomic, weak)id<UserSelectViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
