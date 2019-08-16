//
//  UserRemoveViewController.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/16.
//

#import "UserRemoveViewController.h"
#import "UserSelectTableViewCell.h"
#import "UserModel.h"

#define kUserSelectCellIdentifier @"UserSelectCellIdentifier"

@interface UserRemoveViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *selectedUserList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserRemoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    [self userListSetup];
}

- (void)initialSetup {
    self.title = @"移除人员";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserSelectTableViewCell class]) bundle:nil] forCellReuseIdentifier:kUserSelectCellIdentifier];
    self.selectedUserList = [NSMutableArray array];
    [self addRightBtn];
}

- (void)addRightBtn {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)userListSetup {
    for (UserModel *user in self.userList) {
        user.selected = NO;
    }
}

- (void)confirmButtonClick {
    if (self.selectedUserList.count == 0) {
        [self alertVcShowWithTitle:@"提示" message:@"请选择要移除的人员！" handler:nil];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(userRemoveViewController:confirmButtonDidClick:)]) {
        [self.delegate userRemoveViewController:self confirmButtonDidClick:self.selectedUserList];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertVcShowWithTitle: (NSString *)title message: (NSString *)message handler:(void(^)(UIAlertAction *))action {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler: action]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserSelectCellIdentifier forIndexPath:indexPath];
    cell.model = self.userList[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    UserModel *model = self.userList[indexPath.row];
    model.selected = !model.selected;
    if (model.selected) {
        [self.selectedUserList addObject:model];
    } else {
        [self.selectedUserList removeObject:model];
    }
    [tableView reloadData];
}

@end
