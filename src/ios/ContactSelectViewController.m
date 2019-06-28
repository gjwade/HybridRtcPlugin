//
//  ContactSelectViewController.m
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/27.
//

#import "ContactSelectViewController.h"
#import <RongIMLib/RongIMLib.h>
#import "RCDataBaseManager.h"
#import "RCDUserInfoManager.h"
#import "ContactSelectModel.h"
#import "ContactSelectCell.h"
#import "RCDHttpTool.h"
#import "ConversationViewController.h"

@interface ContactSelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSArray *dataSource;
@property(nonatomic, strong)NSArray *friendList;
@property(nonatomic, strong)NSMutableArray *groupMemberList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialSetup];
}
- (void)initialSetup {
    self.title = @"选择联系人";
    self.groupMemberList = [NSMutableArray array];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addRightBtn];
    self.friendList = [self getAllFriendList];
    self.dataSource = [self dataSourceSetup];
}
- (void)addRightBtn {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)confirmButtonClick {
    NSLog(@"confirmButtonClick");
    int randomNumber = arc4random() % 10000;
    NSString *groupName = [NSString stringWithFormat:@"群组%d", randomNumber];
    NSMutableArray *memberIds = [NSMutableArray array];
    [memberIds addObject:[[RCIM sharedRCIM] currentUserInfo].userId];
    [memberIds addObjectsFromArray:[self.groupMemberList valueForKey:@"userId"]];
    [[RCDHttpTool shareInstance] createGroupWithGroupName:groupName GroupMemberList:memberIds complete:^(NSString *groupId) {
        NSLog(@"%@", groupId);
        if (groupId) {
            [RCDHTTPTOOL getGroupMembersWithGroupId:groupId Block:^(NSMutableArray *result) {
                NSLog(@"%@", result);
            }];
            RCGroup *groupInfo = [[RCGroup alloc] init];
            groupInfo.groupId = groupId;
            groupInfo.groupName = groupName;
            [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:groupId];
            [RCDHTTPTOOL getGroupByID:groupInfo.groupId
                    successCompletion:^(RCDGroupInfo *group) {
                        [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                    }];
            [self gotoChatView:groupInfo.groupId groupName:groupInfo.groupName];
        } else {
            NSLog(@"群组创建失败");
        }
    }];
}

- (void)gotoChatView:(NSString *)groupId groupName:(NSString *)groupName {
    ConversationViewController *chatVC = [[ConversationViewController alloc] init];
    chatVC.targetId = groupId;
    chatVC.conversationType = ConversationType_GROUP;
    chatVC.title = groupName;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:chatVC animated:YES];
    });
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

-(NSArray *)dataSourceSetup {
    NSMutableArray *resultList = [NSMutableArray array];
    for (RCUserInfo* user in self.friendList) {
        ContactSelectModel *model = [ContactSelectModel initialWithUser:user];
        [resultList addObject:model];
    }
    return resultList;
}

#pragma mark- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactSelectCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    ContactSelectModel *userInfo = self.dataSource[indexPath.row];
    userInfo.selected = !userInfo.selected;
    if (userInfo.selected) {
        [self.groupMemberList addObject:self.friendList[indexPath.row]];
    } else {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"userId = %@", userInfo.user.userId];
        NSArray *filteredArray = [self.groupMemberList filteredArrayUsingPredicate:filterPredicate];
        NSUInteger index = [self.groupMemberList indexOfObject:filteredArray[0]];
        [self.groupMemberList removeObjectAtIndex:index];
    }
    NSLog(@"%@", self.groupMemberList);
    [tableView reloadData];
}
@end
