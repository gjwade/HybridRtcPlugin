//
//  UpdateNameViewController.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UpdateNameViewController;

@protocol UpdateNameViewControllerDelegate<NSObject>

/** 保存按钮点击事件代理方法 */
- (void)updateNameViewController: (UpdateNameViewController *)viewController saveButtonDidClick: (NSString *)groupName;

@end

@interface UpdateNameViewController : UIViewController

/** 代理 */
@property(nonatomic, weak) id<UpdateNameViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
