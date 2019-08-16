//
//  UserSelectTableView.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class UserSelectTableView;

@protocol UserSelectTableViewDelegate <NSObject>

-(void)userSelectTableView: (UserSelectTableView *)tableView userDidSelect: (NSInteger)row;
-(void)userSelectTableView: (UserSelectTableView *)tableView organizationDidSelect: (NSInteger)row;

@end

@interface UserSelectTableView : UITableView

@property(nonatomic, strong) NSArray *userList;
@property(nonatomic, strong) NSArray *organizationList;
@property(nonatomic, weak)id<UserSelectTableViewDelegate> customDelegate;

@end

NS_ASSUME_NONNULL_END
