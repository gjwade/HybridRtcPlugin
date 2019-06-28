//
//  RYMainViewController.m
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/26.
//

#import "RYMainViewController.h"
#import <RongIMLib/RongIMLib.h>
#import "ChatListViewController.h"
#import "ContractViewController.h"

@interface RYMainViewController ()

@end

@implementation RYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup {
    self.title = @"聊天主界面";
    [self addRightBtn];
}
- (void)addRightBtn {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)closeButtonClick {
    NSLog(@"closeButtonClick");
    [[RCIMClient sharedRCIMClient] logout];
    [self dismissViewControllerAnimated:false completion:nil];
}

- (IBAction)conversationListButtonClick:(UIButton *)sender {
    ChatListViewController *chatVC = [[ChatListViewController alloc] init];
    [self.navigationController pushViewController:chatVC animated:true];
}
//- (IBAction)contractButtonClick:(UIButton *)sender {
//    ContractViewController *contractVC = [[ContractViewController alloc] init];
//    [self.navigationController pushViewController:contractVC animated:true];
//}

@end
