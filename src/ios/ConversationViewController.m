//
//  ConversationViewController.m
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/13.
//

#import "ConversationViewController.h"

@interface ConversationViewController ()

@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"viewDidLoad---");
    [self initialSetup];
}
- (void)initialSetup {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:58.0/255 green:114.0/255 blue:209.0/255 alpha:1.0];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes: attributes];
    [self addLeftBtn];
    if (self.conversationType == ConversationType_PRIVATE) {
//        [self addSingleChatRightBtn];
    } else if (self.conversationType == ConversationType_GROUP) {
//        [self addGroupChatRightBtn];
    }
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
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [rightButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(groupSettingButtonClick) forControlEvents:UIControlEventTouchDown];
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
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
}

-(void)notifyUpdateUnreadMessageCount {
    return;
}
@end
