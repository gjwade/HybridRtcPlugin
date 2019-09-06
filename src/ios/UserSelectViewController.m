//
//  UserSelectViewController.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/12.
//

#import "UserSelectViewController.h"
#import "OrganizationCollectionViewCell.h"
#import "OrganizationCollectionModel.h"
#import "UserSelectTableView.h"
#import "UserModel.h"
#import "OrganizationModel.h"
#import "UserSelectedCollectionView.h"
#import "AFHttpTool.h"

@interface UserSelectViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UserSelectTableViewDelegate, UserSelectedCollectionViewDelegate, UISearchBarDelegate>

@property(nonatomic, strong)NSArray *navList;
@property(nonatomic, strong)NSArray *userList;
@property(nonatomic, strong)NSMutableArray *selectedUserList;
@property(nonatomic, strong)NSArray *organizationList;
@property(nonatomic, strong)NSString *token;
@property(nonatomic, strong)OrganizationModel *topOrgModel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UserSelectTableView *userSelectTableView;
@property (weak, nonatomic) IBOutlet UserSelectedCollectionView *userSelectedCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navListHeightConstraint;

@end

@implementation UserSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    OrganizationCollectionModel *orgCollectionModel = [OrganizationCollectionModel modelWithOrgId:self.topOrgModel.orgId name:self.topOrgModel.name linkShow:NO lineShow:YES];
    [self navListInfoAdd:orgCollectionModel];
    [self userListInfoLoad:self.topOrgModel.orgId];
    [self organizationListInfoLoad:self.topOrgModel.orgId];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initialSetup {
    self.title = @"人员选择";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.topOrgModel = [OrganizationModel modelWithId:@"CA56385926584520ADB29D76887F406B" name:@"奉贤区环境保护局"];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    flowLayout.estimatedItemSize = CGSizeMake(30, 30);
    self.userSelectTableView.customDelegate = self;
    self.userSelectedCollectionView.customDelegate = self;
    self.selectedUserList = [NSMutableArray array];
    self.token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
}

- (void)navListInfoAdd: (OrganizationCollectionModel *)model {
    NSMutableArray *tempDataSource = [NSMutableArray arrayWithArray:self.navList];
    if (tempDataSource.count > 0) {
        OrganizationCollectionModel *lastModel = (OrganizationCollectionModel *)tempDataSource.lastObject;
        lastModel.linkShow = YES;
        lastModel.lineShow = NO;
    }
    [tempDataSource addObject:model];
    self.navList = [tempDataSource copy];
    [self.collectionView reloadData];
}

- (void)navListInfoDelete: (NSInteger)row {
    NSMutableArray *tempDataSource = [NSMutableArray arrayWithArray:self.navList];
    OrganizationCollectionModel *model = (OrganizationCollectionModel *)tempDataSource[row];
    model.linkShow = NO;
    model.lineShow = YES;
    NSRange range = NSMakeRange(row + 1, tempDataSource.count - row - 1);
    [tempDataSource removeObjectsInRange:range];
    self.navList = [tempDataSource copy];
    [self.collectionView reloadData];
    [self userListInfoLoad:model.orgId];
    [self organizationListInfoLoad:model.orgId];
}

- (void)userListInfoLoad: (NSString *)orgId {
    NSString *urlString = @"identify/users";
    NSDictionary *params = @{@"organization.orgId": orgId, @"token": self.token};
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:urlString params:params success:^(id response) {
        NSLog(@"%@", response);
        NSInteger code = [response[@"code"] integerValue];
        if (code) {
            [self alertVcShowWithTitle:@"提示" message:response[@"message"] handler:nil];
            return;
        }
        [self userListLoadSuccess:response[@"content"][@"dataList"]];
    } failure:^(NSString *errMessage) {
        [self alertVcShowWithTitle:@"提示" message:errMessage handler:nil];
    }];
}

- (void)userListLoadSuccess: (NSArray *)dataList {
    NSMutableArray *tempDataSource = [NSMutableArray array];
    for (NSDictionary *dict in dataList) {
        NSString *userId = dict[@"userId"];
        NSPredicate *predicateSelected = [NSPredicate predicateWithFormat:@"userId = %@", userId];
        NSArray *filtedArray = [self.selectedUserList filteredArrayUsingPredicate:predicateSelected];
        BOOL selected = filtedArray.count == 0;
        UserModel *user = [UserModel modelWithId:dict[@"userId"] name:dict[@"userName"] selected:!selected];
        NSPredicate *predicateDisabled = [NSPredicate predicateWithFormat:@"userId = %@", userId];
        NSArray *filtedDisabled = [self.disabledUserList filteredArrayUsingPredicate:predicateDisabled];
        if (filtedDisabled.count != 0) {
            user.disabled = YES;
            user.selected = YES;
        }
        [tempDataSource addObject:user];
    }
    self.userList = [tempDataSource copy];
    self.userSelectTableView.userList = self.userList;
}

- (void)organizationListInfoLoad: (NSString *)orgId {
    NSString *urlString = @"identify/organizations/id/sonOrg";
    NSDictionary *params = @{@"orgId": orgId, @"token": self.token};
    [AFHttpTool requestWihtMethod:RequestMethodTypeGet url:urlString params:params success:^(id response) {
        NSLog(@"%@", response);
        NSInteger code = [response[@"code"] integerValue];
        if (code) {
            [self alertVcShowWithTitle:@"提示" message:response[@"message"] handler:nil];
            return;
        }
        [self organizationListLoadSuccess:response[@"content"][@"dataList"]];
    } failure:^(NSString *errMessage) {
        [self alertVcShowWithTitle:@"提示" message:errMessage handler:nil];
    }];
}

- (void)organizationListLoadSuccess: (NSArray *)dataList {
    NSMutableArray *tempDataSource = [NSMutableArray array];
    for (NSDictionary *dict in dataList) {
        OrganizationModel *organization = [OrganizationModel modelWithId:dict[@"orgId"] name:dict[@"orgName"]];
        [tempDataSource addObject:organization];
    }
    self.organizationList = [tempDataSource copy];
    self.userSelectTableView.organizationList = self.organizationList;
}

- (void)confirmButtonActiveSetup {
    if (self.selectedUserList.count == 0) {
        self.confirmView.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        self.confirmButton.enabled = NO;
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        return;
    }
    self.confirmView.backgroundColor = [UIColor colorWithRed:57/255.0 green:114/255.0 blue:209/255.0 alpha:1.0];
    self.confirmButton.enabled = YES;
    NSString *confirmButtonString = [NSString stringWithFormat:@"确定(%ld)", self.selectedUserList.count];
    [self.confirmButton setTitle:confirmButtonString forState:UIControlStateNormal];
}

- (void)alertVcShowWithTitle: (NSString *)title message: (NSString *)message handler:(void(^)(UIAlertAction *))action {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler: action]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)keyboardWillShow: (NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect endFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = endFrame.size.height;
    //动画执行时长
    CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //运行轨迹属性
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //这样就可以与键盘动画无缝衔接了
    [UIView animateWithDuration:animationDuration delay:0 options:(animationCurve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:^{
        
    } completion:nil];
}

- (void)keyboardWillHide: (NSNotification *)notification {
    
}

- (IBAction)confirmButtonClick:(UIButton *)sender {
    NSLog(@"confirmButtonClick");
    if ([self.delegate respondsToSelector:@selector(userSelectViewController:confirmButtonDidClick:)]) {
        [self.delegate userSelectViewController:self confirmButtonDidClick:self.selectedUserList];
    }
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.navList.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    OrganizationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"organizationCellIdentifier" forIndexPath:indexPath];
    cell.model = self.navList[indexPath.row];
    return cell;
}

#pragma mark -UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.row == self.navList.count - 1) {
        return;
    }
    [self navListInfoDelete:indexPath.row];
}

#pragma mark -UserSelectTableViewDelegate

-(void)userSelectTableView:(UserSelectTableView *)tableView userDidSelect:(NSInteger)row {
    UserModel *model = self.userList[row];
    model.selected = !model.selected;
    if (model.selected) {
        [self.selectedUserList addObject:model];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", model.userId];
        NSArray *filtedArray = [self.selectedUserList filteredArrayUsingPredicate:predicate];
        [self.selectedUserList removeObject:filtedArray.firstObject];
    }
    [self confirmButtonActiveSetup];
    self.userSelectTableView.userList = self.userList;
    self.userSelectedCollectionView.dataSourceArray = self.selectedUserList;
}

-(void)userSelectTableView:(UserSelectTableView *)tableView organizationDidSelect:(NSInteger)row {
    OrganizationModel *model = self.organizationList[row];
    NSLog(@"%@", model);
    OrganizationCollectionModel *orgCollectionModel = [OrganizationCollectionModel modelWithOrgId:model.orgId name:model.name linkShow:NO lineShow:YES];
    [self navListInfoAdd:orgCollectionModel];
    [self userListInfoLoad:model.orgId];
    [self organizationListInfoLoad:model.orgId];
}

#pragma mark -UserSelectedCollectionViewDelegate

- (void)userSelectedCollectionView:(UserSelectedCollectionView *)collectionView deleteButtonDidClick:(UserModel *)model {
    [self.selectedUserList removeObject:model];
    self.userSelectedCollectionView.dataSourceArray = self.selectedUserList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId = %@", model.userId];
    NSArray *filtedArray = [self.userList filteredArrayUsingPredicate:predicate];
    if (filtedArray.count > 0) {
        UserModel *deleteModel = (UserModel *)filtedArray.firstObject;
        deleteModel.selected = !deleteModel.selected;
        self.userSelectTableView.userList = self.userList;
    }
    [self confirmButtonActiveSetup];
}

#pragma mark -UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarSearchButtonClicked%@", searchBar.text);
    [self.view endEditing:true];
    self.navListHeightConstraint.constant = 0;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarCancelButtonClicked%@", searchBar.text);
    [self.view endEditing:true];
    self.navListHeightConstraint.constant = 44;
}

@end
