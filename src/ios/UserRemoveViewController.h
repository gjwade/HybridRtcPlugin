//
//  UserRemoveViewController.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/16.
//

#import <UIKit/UIKit.h>
@class UserRemoveViewController;

@protocol UserRemoveViewControllerDelegate <NSObject>

- (void)userRemoveViewController: (UserRemoveViewController *)viewController confirmButtonDidClick: (NSArray *)removedUserList;

@end


NS_ASSUME_NONNULL_BEGIN

@interface UserRemoveViewController : UIViewController

@property(nonatomic, strong)NSArray *userList;

@property(nonatomic, weak)id<UserRemoveViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
