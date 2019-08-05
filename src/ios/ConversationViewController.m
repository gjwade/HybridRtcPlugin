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
    [self initialSetup];
}
- (void)initialSetup {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:58.0/255 green:114.0/255 blue:209.0/255 alpha:1.0];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes: attributes];
    [self addRightBtn];
}
- (void)addRightBtn {
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"关闭" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)closeButtonClick {
    NSLog(@"closeButtonClick");
    [self dismissViewControllerAnimated:false completion:nil];
}
@end
