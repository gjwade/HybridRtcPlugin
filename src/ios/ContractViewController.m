//
//  ContractViewController.m
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/26.
//

#import "ContractViewController.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDataBaseManager.h"
#import "RCDUserInfoManager.h"
#import "FriendCell.h"
#import "ConversationViewController.h"

@interface ContractViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSArray *dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dataSource = [self getAllFriendList];
    NSLog(@"%@", self.dataSource);
}

#pragma mark - 获取好友并且排序

- (NSArray *)getAllFriendList {
    NSMutableArray *friendList = [[NSMutableArray alloc] init];
    NSMutableArray *userInfoList = [NSMutableArray arrayWithArray:[[RCDataBaseManager shareInstance] getAllFriends]];
    for (RCDUserInfo *user in userInfoList) {
        if ([user.status isEqualToString:@"20"]) {
            [friendList addObject:user];
        }
    }
    //如有好友备注，则显示备注
    NSArray *resultList = [[RCDUserInfoManager shareInstance] getFriendInfoList:friendList];
    return resultList;
}

#pragma mark- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    RCUserInfo *userInfo = self.dataSource[indexPath.row];
    ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
    conversationVC.conversationType = ConversationType_PRIVATE;
    conversationVC.targetId = userInfo.userId;
    conversationVC.title = userInfo.name;
    [self.navigationController pushViewController:conversationVC animated:true];
}

@end
