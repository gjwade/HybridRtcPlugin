//
//  ConversationViewController.m
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/13.
//

#import "ConversationViewController.h"
#import "GroupSettingViewController.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad---");
    [self initialSetup];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initialSetup {
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:58.0/255 green:114.0/255 blue:209.0/255 alpha:1.0];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes: attributes];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    [self addLeftBtn];
    if (self.conversationType == ConversationType_PRIVATE) {
//        [self addSingleChatRightBtn];
    } else if (self.conversationType == ConversationType_GROUP) {
        [self addGroupChatRightBtn];
    }
    
    //清除历史消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearHistoryMsg:)
                                                 name:@"clearHistoryMsg"
                                               object:nil];
}
- (void)addLeftBtn {
    NSLog(@"addLeftBtn---");
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)addSingleChatRightBtn {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"关闭" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)addGroupChatRightBtn {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(groupSettingButtonClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)clearHistoryMsg:(NSNotification *)notification {
    NSLog(@"clearHistoryMsg");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationDataRepository removeAllObjects];
        [self.conversationMessageCollectionView reloadData];
    });
}

- (void)closeButtonClick {
    NSLog(@"closeButtonClick");
    if (self.block) {
        self.block();
    }
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void)groupSettingButtonClick {
    NSLog(@"groupSettingButtonClick");
    UIStoryboard *rongyunSb = [UIStoryboard storyboardWithName:@"RongYunStoryboard" bundle:nil];
    GroupSettingViewController *settingVC = (GroupSettingViewController *)[rongyunSb instantiateViewControllerWithIdentifier:@"GroupSettingViewController"];
    settingVC.groupName = @"奉贤进度会议";
    settingVC.groupId = @"123456";
    [self.navigationController pushViewController:settingVC animated:true];
}

-(void)notifyUpdateUnreadMessageCount {
    return;
}
@end
