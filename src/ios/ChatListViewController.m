//
//  ChatListViewController.m
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/13.
//

#import "ChatListViewController.h"
#import <RongCallLib/RongCallLib.h>
#import "ConversationViewController.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialSetup];
    //设置需要显示哪些类型的会话
    NSLog(@"viewDidLoad-----");
}

- (void)initialSetup {
    self.title = @"会话列表";
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {
    ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.targetId;
    [self.navigationController pushViewController:conversationVC animated:true];
}
@end
