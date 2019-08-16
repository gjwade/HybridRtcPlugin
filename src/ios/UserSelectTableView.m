//
//  UserSelectTableView.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import "UserSelectTableView.h"
#import "UserModel.h"
#import "OrganizationModel.h"
#import "UserSelectTableViewCell.h"
#import "OrgnizationSelectTableViewCell.h"

#define kUserSelectCellIdentifier @"UserSelectCellIdentifier"
#define kOrganizationSelectCellIdentifier @"OrganizationSelectCellIdentifier"

@interface UserSelectTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation UserSelectTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialSetup];
    }
    return self;
}

- (void)initialSetup {
    self.delegate = self;
    self.dataSource = self;
    self.rowHeight = 55.0f;
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([UserSelectTableViewCell class]) bundle:nil] forCellReuseIdentifier:kUserSelectCellIdentifier];
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([OrgnizationSelectTableViewCell class]) bundle:nil] forCellReuseIdentifier:kOrganizationSelectCellIdentifier];
}

-(void)setUserList:(NSArray *)userList {
    _userList = userList;
    [self reloadData];
}

-(void)setOrganizationList:(NSArray *)organizationList {
    _organizationList = organizationList;
    [self reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userList.count + _organizationList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.userList.count) {
        UserSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserSelectCellIdentifier forIndexPath:indexPath];
        cell.model = self.userList[indexPath.row];
        return cell;
    }
    NSInteger userCount = self.userList.count;
    OrgnizationSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrganizationSelectCellIdentifier forIndexPath:indexPath];
    cell.model = self.organizationList[indexPath.row - userCount];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.row < self.userList.count) {
        UserModel *model = (UserModel *)self.userList[indexPath.row];
        if (model.disabled) {
            return;
        }
        if ([self.customDelegate respondsToSelector:@selector(userSelectTableView:userDidSelect:)]) {
            [self.customDelegate userSelectTableView:self userDidSelect:indexPath.row];
        }
        return;
    }
    if ([self.customDelegate respondsToSelector:@selector(userSelectTableView:organizationDidSelect:)]) {
        [self.customDelegate userSelectTableView:self organizationDidSelect:indexPath.row - self.userList.count];
    }
}

@end
