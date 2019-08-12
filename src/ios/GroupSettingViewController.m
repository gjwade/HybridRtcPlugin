//
//  GroupSettingViewController.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/10.
//

#import "GroupSettingViewController.h"
#import "UpdateNameViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface GroupSettingViewController ()<UpdateNameViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *groupNameTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;

@end

@implementation GroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup {
    self.title = @"群聊信息";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.groupNameTitleLabel.text = self.groupName;
    self.groupNameLabel.text = self.groupName;
}

- (void)actionSheetShowWithTitle: (NSString *)title message: (NSString *)message handler:(void(^)(UIAlertAction *))action {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler: action]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)alertVcShowWithTitle: (NSString *)title message: (NSString *)message handler:(void(^)(UIAlertAction *))action {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler: action]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)clearConversationMessages {
    NSArray *latestMessages = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_GROUP targetId:self.groupId count:1];
    if (latestMessages.count == 0) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    
//    RCMessage *message = (RCMessage *)[latestMessages firstObject];
//    [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:ConversationType_GROUP targetId:self.groupId recordTime:message.sentTime success:^{
//        [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_GROUP targetId:self.groupId success:^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf alertVcShowWithTitle:@"提示" message:@"清除聊天记录成功" handler:nil];
//            });
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"clearHistoryMsg" object:nil];
//        } error:^(RCErrorCode status) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf alertVcShowWithTitle:@"提示" message:@"清除远程聊天记录失败" handler:nil];
//            });
//        }];
//    } error:^(RCErrorCode status) {
//        NSLog(@"%ld", status);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf alertVcShowWithTitle:@"提示" message:@"清除远程聊天记录失败" handler:nil];
//        });
//    }];
    
    [[RCIMClient sharedRCIMClient] deleteMessages:ConversationType_GROUP targetId:self.groupId success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf alertVcShowWithTitle:@"提示" message:@"清除聊天记录成功!" handler:nil];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:@"clearHistoryMsg" object:nil];
    } error:^(RCErrorCode status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf alertVcShowWithTitle:@"提示" message:@"清除聊天记录失败!" handler:nil];
        });
    }];
}

- (void)dismissGroup {
    NSArray *latestMessages = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_GROUP targetId:self.groupId count:1];
    if (latestMessages.count > 0) {
        [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:self.groupId];
    }
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:self.groupId];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshChatList" object:nil];
    NSArray *viewControllers = self.navigationController.viewControllers;
    UIViewController *rootVC = viewControllers.firstObject;
    [rootVC dismissViewControllerAnimated:false completion:nil];
}

- (IBAction)changeGroupNameBtnClick:(UIButton *)sender {
    UIStoryboard *rongyunSb = [UIStoryboard storyboardWithName:@"RongYunStoryboard" bundle:nil];
    UpdateNameViewController *updateNameVC = (UpdateNameViewController *)[rongyunSb instantiateViewControllerWithIdentifier:@"UpdateNameViewController"];
    updateNameVC.delegate = self;
    [self.navigationController pushViewController:updateNameVC animated:true];
}

#pragma mark -UpdateNameViewControllerDelegate

- (void)updateNameViewController:(UpdateNameViewController *)viewController saveButtonDidClick:(NSString *)groupName {
    self.groupName = groupName;
    self.groupNameTitleLabel.text = groupName;
    self.groupNameLabel.text = groupName;
}

#pragma mark -IBAction methods

- (IBAction)notificationSetup:(UISwitch *)sender {
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.groupId isBlocked:sender.isOn success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"%ld", nStatus);
        NSLog(@"设置免打扰模式成功");
    } error:^(RCErrorCode status) {
        NSLog(@"%ld", status);
        NSLog(@"设置免打扰模式失败");
    }];
}

- (IBAction)stickyConversationSetup:(UISwitch *)sender {
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_GROUP targetId:self.groupId isTop:sender.isOn];
}

- (IBAction)clearMessageRecordBtnClick:(UIButton *)sender {
    [self actionSheetShowWithTitle:@"确定清除聊天记录？" message:nil handler:^(UIAlertAction *action) {
        [self clearConversationMessages];
    }];
}

- (IBAction)dismissGroupBtnClick:(UIButton *)sender {
    [self actionSheetShowWithTitle:@"确定解散群组？" message:nil handler:^(UIAlertAction *action) {
        [self dismissGroup];
    }];
}

@end
