/********* HybridRtcPlugin.m Cordova Plugin Implementation *******/

#import "HybridRtcPlugin.h"
#import <RongIMLib/RongIMLib.h>
#import <RongCallLib/RongCallLib.h>
#import <RongCallKit/RongCallKit.h>
#import "RongYunMainVC.h"
#import "RCDRCIMDataSource.h"
#import "RCDHttpTool.h"
#import "RCDataBaseManager.h"
#import "AFHttpTool.h"
#import "RCDUtilities.h"
#import <MJExtension.h>
#import "ConversationViewController.h"
#import "RCDataBaseManager.h"

typedef void(^MessageReceivedBlock)(void);
typedef void(^MessageGlobalBlock)(void);

@interface HybridRtcPlugin()<RCCallSessionDelegate, RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate, RCIMUserInfoDataSource, RCIMGroupMemberDataSource>

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, copy) MessageReceivedBlock messageReceivedBlock;
@property(nonatomic, copy) MessageGlobalBlock messageGlobalBlock;

@end

@implementation HybridRtcPlugin

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];
    
    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)plus:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    NSArray *arguments = [command.arguments objectAtIndex: 0];
    int a = [arguments[0] intValue];
    int b = [arguments[1] intValue];
    int ret = a + b;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:ret];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void)minus:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    NSArray *arguments = [command.arguments objectAtIndex: 0];
    int a = [arguments[0] intValue];
    int b = [arguments[1] intValue];
    int ret = a - b;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:ret];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)initWithAppKey:(CDVInvokedUrlCommand*)command {
    CDVPluginResult *pluginResult = nil;
    NSString *appKey = [command.arguments objectAtIndex: 0];
    [[RCIM sharedRCIM] initWithAppKey:appKey];
    [self initialSetup];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"sdk初始化成功"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getRongYunToken:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult *pluginResult = nil;
    NSString *appKey = [command.arguments objectAtIndex: 0];
    NSString *appSecret = [command.arguments objectAtIndex: 1];
    NSString *userId = [command.arguments objectAtIndex: 2];
    NSString *userName = [command.arguments objectAtIndex: 3];
    NSString *rongYunToken = [[NSUserDefaults standardUserDefaults] valueForKey:userId];
    if (rongYunToken) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:rongYunToken];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [AFHttpTool getRongYunTokenWithAppKey:appKey appSecret:appSecret userId:userId userName:userName success:^(id response) {
        NSLog(@"%@", response);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:response[@"token"]];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        [[NSUserDefaults standardUserDefaults] setObject:response[@"token"] forKey:response[@"userId"]];
    } failure:^(NSString *errorMessage) {
        NSLog(@"%@", errorMessage);
    }];
}

- (void)connectWithToken:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    __weak __typeof(self) weakSelf = self;
//    NSString *appKey = [command.arguments objectAtIndex: 0];
//    if ([[RCIM sharedRCIM] getConnectionStatus] == ConnectionStatus_Unconnected) {
//        [[RCIM sharedRCIM] initWithAppKey:appKey];
//        [self initialSetup];
//    }
    NSString *rongYunToken = [command.arguments objectAtIndex: 0];
    NSString *token = [command.arguments objectAtIndex: 1];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[RCIM sharedRCIM] connectWithToken:rongYunToken success:^(NSString *userId) {
//        NSArray *chatList = [self conversationListAccept];
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray: chatList];
        [weakSelf dataSync:userId];
        NSInteger unreadCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsNSInteger:unreadCount];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
        // TODO: for test to add user to database
//        RCUserInfo *user1 = [[RCUserInfo alloc] initWithUserId:@"0814DD20DA71454186A514DD8B6F0460" name:@"肖伟" portrait:@""];
//        RCUserInfo *user2 = [[RCUserInfo alloc] initWithUserId:@"9531090493154c268c16eff48cbd8322" name:@"左海强" portrait:@""];
//        RCUserInfo *user3 = [[RCUserInfo alloc] initWithUserId:@"9DB6539C044A46EDB63029C29A36E379" name:@"宋康" portrait:@""];
//        RCUserInfo *user4 = [[RCUserInfo alloc] initWithUserId:@"A90D71E3DBE3494995ABB9729B23D1B6" name:@"胡佳妮" portrait:@""];
//        RCUserInfo *user5 = [[RCUserInfo alloc] initWithUserId:@"C0E6617484AE450988F8CB25D07783BD" name:@"潘丹凤" portrait:@""];
//        [[RCDataBaseManager shareInstance] insertUserToDB:user1];
//        [[RCDataBaseManager shareInstance] insertUserToDB:user2];
//        [[RCDataBaseManager shareInstance] insertUserToDB:user3];
//        [[RCDataBaseManager shareInstance] insertUserToDB:user4];
//        [[RCDataBaseManager shareInstance] insertUserToDB:user5];
//
//        NSArray *userList = [[RCDataBaseManager shareInstance] getAllUserInfo];
//        NSLog(@"%@", userList);
        
    } error:^(RCConnectErrorCode status) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } tokenIncorrect:^{
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"融云token不正确"];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)addGlobalListener:(CDVInvokedUrlCommand *)command {
    __weak __typeof(self) weakSelf = self;
    self.messageGlobalBlock = ^{
        CDVPluginResult *pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"接收到全局消息了"];
        [pluginResult setKeepCallbackAsBool:YES];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
}

- (void)addMessageReceivedListener:(CDVInvokedUrlCommand *)command {
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatList:) name:@"refreshChatList" object:nil];
    self.messageReceivedBlock = ^{
        CDVPluginResult *pluginResult = nil;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"接收到消息了"];
        [pluginResult setKeepCallbackAsBool:YES];
        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    };
}

- (void)refreshChatList: (NSNotification *)notification {
    if (self.messageReceivedBlock) {
        self.messageReceivedBlock();
    }
}

- (void)getConversationList:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    __weak __typeof(self) weakSelf = self;
    NSArray *chatList = [self conversationListAccept];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:chatList];
    [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)removeConversation:(CDVInvokedUrlCommand*)command {
    RCConversationType conversationType = [[command.arguments objectAtIndex: 0] intValue];
    NSString *targetId = [command.arguments objectAtIndex: 1];
    [[RCIMClient sharedRCIMClient] clearMessages:conversationType targetId:targetId];
    [[RCIMClient sharedRCIMClient] removeConversation:conversationType targetId:targetId];
    
    CDVPluginResult *pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"会话删除成功"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//- (void)connectWithToken:(CDVInvokedUrlCommand *)command {
//    //    NSString *appKey = [command.arguments objectAtIndex: 0];
//    NSLog(@"----------%ld", [[RCIM sharedRCIM] getConnectionStatus]);
//    if ([[RCIM sharedRCIM] getConnectionStatus] == ConnectionStatus_Unconnected) {
//        [[RCIM sharedRCIM] initWithAppKey:@"n19jmcy59f1q9"];
//        [self initialSetup];
//    }
//    [self loginToserve:command];
//}
- (void)startCall:(CDVInvokedUrlCommand*)command {
    RCConversationType conversationType = [[command.arguments objectAtIndex: 0] intValue];
    NSString *targetId = [command.arguments objectAtIndex: 1];
    NSArray *users = [command.arguments objectAtIndex: 2];
    [[RCCallClient sharedRCCallClient] startCall:conversationType targetId:targetId to:users mediaType: RCCallMediaVideo sessionDelegate:self extra:nil];
}

- (void)accept:(CDVInvokedUrlCommand*)command {
    int mediaType = [[command.arguments objectAtIndex: 0] intValue];
    [[[RCCallClient sharedRCCallClient] currentCallSession] accept:mediaType];
}

- (void)hangup:(CDVInvokedUrlCommand*)command {
    [[[RCCallClient sharedRCCallClient] currentCallSession] hangup];
}

#pragma RCCallSessionDelegate

-(void)callDidConnect {
    NSLog(@"callDidConnect");
}
-(void)callDidDisconnect {
    NSLog(@"callDidDisconnect");
}
- (void)remoteUserDidRing:(NSString *)userId {
    NSLog(@"callDidDisconnect");
    NSLog(@"%@", userId);
}
- (void)remoteUserDidInvite:(NSString *)userId mediaType:(RCCallMediaType)mediaType {
    NSLog(@"remoteUserDidInvite");
}
- (void)remoteUserDidJoin:(NSString *)userId mediaType:(RCCallMediaType)mediaType {
    NSLog(@"remoteUserDidJoin");
}
- (void)remoteUserDidLeft:(NSString *)userId reason:(RCCallDisconnectReason)reason {
    NSLog(@"remoteUserDidLeft");
}
- (void)errorDidOccur:(RCCallErrorCode)error {
    NSLog(@"errorDidOccur");
    NSLog(@"%ld", error);
}

- (void)joinRoom:(CDVInvokedUrlCommand*)command {
//    __block CDVPluginResult *pluginResult = nil;
//    __weak __typeof(self) weakSelf = self;
//    NSString *appKey = [command.arguments objectAtIndex: 0];
//    [[RCIMClient sharedRCIMClient] initWithAppKey:appKey];
//    NSString *token = [command.arguments objectAtIndex: 1];
//    [[RCIMClient sharedRCIMClient] connectWithToken:token success:^(NSString *userId) {
//        [self connectSucces:command];
//    } error:^(RCConnectErrorCode status) {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
//        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    } tokenIncorrect:^{
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"token不正确"];
//        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    }];
    NSString *userId = [command.arguments objectAtIndex: 0];
    [[RCCall sharedRCCall] startSingleCall:userId mediaType:RCCallMediaVideo];
}
- (void)connectSucces:(NSString *)userId {
    NSLog(@"连接成功");
    [self dataSync: userId];
    dispatch_async(dispatch_get_main_queue(), ^{
//        UIStoryboard *rongyunSb = [UIStoryboard storyboardWithName:@"RongYunStoryboard" bundle:nil];
//        RongYunMainVC *mainVC = (RongYunMainVC *)[rongyunSb instantiateViewControllerWithIdentifier:@"RongYunMainVC"];
//        UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
//        NSLog(@"%@", rootVC);
//        [rootVC presentViewController:mainVC animated:false completion:nil];
    });
}
- (void)groupChat:(CDVInvokedUrlCommand*)command {
    NSArray *userIds = [command.arguments objectAtIndex: 0];
    NSString *targetId = [command.arguments objectAtIndex: 1];
    [[RCCall sharedRCCall] startMultiCallViewController:ConversationType_GROUP targetId:targetId mediaType:RCCallMediaVideo userIdList:userIds];
}

- (void)initialSetup {
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    //设置用户信息源和群组信息源
    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    //群成员数据源
    [RCIM sharedRCIM].groupMemberDataSource = RCDDataSource;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    //选择媒体资源时，包含视频文件
    [RCIM sharedRCIM].isMediaSelectorContainVideo = YES;
    [[RCIMClient sharedRCIMClient] setReconnectKickEnable:YES];
}

- (void)loginToserve:(CDVInvokedUrlCommand*)command {
    __block CDVPluginResult *pluginResult = nil;
    __weak __typeof(self) weakSelf = self;
    NSString *userName = [command.arguments objectAtIndex: 0];
    NSString *password = [command.arguments objectAtIndex: 1];
//    [AFHttpTool loginWithPhone:userName password:password region:@"86" success:^(id response) {
//        NSLog(@"%@", response);
//        NSString *token = response[@"result"][@"token"];
//        NSString *userId = response[@"result"][@"id"];
//        weakSelf.userId = userId;
//        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
////            [self connectSucces:command userId:userId];
//            NSArray *chatList = [self conversationListAccept];
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:chatList];
//            [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        } error:^(RCConnectErrorCode status) {
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
//            [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        } tokenIncorrect:^{
//            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"token不正确"];
//            [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//        }];
//    } failure:^(NSError *err) {
//        NSLog(@"%@", err);
//    }];
}

-(NSArray *)conversationListAccept {
    RCUserInfo *currentUser = [[RCIMClient sharedRCIMClient] currentUserInfo];
    NSLog(@"%@", currentUser);
    if (!currentUser) {
        return @[];
    }
    NSArray *conversationList = [[RCIMClient sharedRCIMClient]
                                 getConversationList:@[@(ConversationType_PRIVATE),
                                                       @(ConversationType_DISCUSSION),
                                                       @(ConversationType_GROUP),
                                                       @(ConversationType_SYSTEM),
                                                       @(ConversationType_APPSERVICE),
                                                       @(ConversationType_PUBLICSERVICE)]];
    NSLog(@"%@", conversationList);
    NSMutableArray *resultList = [NSMutableArray array];
    for (RCConversation *conversation in conversationList) {
        NSDictionary *result = [self toNSDictionary:conversation];
        [resultList addObject:result];
    }
//
//    NSMutableArray *latestMessageList = [NSMutableArray array];
//    for (RCConversation *conversation in conversationList) {
//        NSDictionary *result = [conversation.lastestMessage mj_keyValues];
//        [latestMessageList addObject:result];
//        NSLog(@"会话类型：%lu，目标会话ID：%@", (unsigned long)conversation.conversationType, conversation.targetId);
//        NSLog(@"%@", conversation.lastestMessage);
//    }
//    NSLog(@"%@", latestMessageList);
//
//    NSArray *otherInfoList = [RCConversation mj_keyValuesArrayWithObjectArray:conversationList ignoredKeys:@[@"lastestMessage"]];
//    NSLog(@"%@", otherInfoList);
//    NSMutableArray *resultList = [NSMutableArray array];
//    for (int i = 0; i < otherInfoList.count; i++) {
//        RCConversation *conversation = conversationList[i];
//        RCMessageContent *message = conversation.lastestMessage;
//        NSDictionary *messageJson = [message mj_keyValuesWithIgnoredKeys: @[@"superclass", @"originalImageData",@"thumbnailImage", @"location"]];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:otherInfoList[i]];
//        if (messageJson) {
//            [dict setObject:messageJson forKey:@"lastestMessage"];
//        }
//        [resultList addObject:dict];
//    }
    
    NSLog(@"%@", resultList);
    return resultList;
}

- (NSMutableDictionary *)toNSDictionary: (RCConversation *)conversation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue: [NSNumber numberWithInteger:conversation.conversationType] forKey:@"conversationType"];
    [dictionary setValue:conversation.targetId forKey:@"targetId"];
    NSString *targetName = [self targetNameSetup:conversation];
    [dictionary setValue:targetName forKey:@"targetName"];
    [dictionary setValue:conversation.conversationTitle forKey:@"conversationTitle"];
    [dictionary setValue: [NSNumber numberWithInteger:conversation.unreadMessageCount] forKey:@"unreadMessageCount"];
    [dictionary setValue: [NSNumber numberWithInteger:conversation.isTop] forKey:@"isTop"];
    [dictionary setValue: [NSNumber numberWithInteger:conversation.receivedStatus] forKey:@"receivedStatus"];
    [dictionary setValue: [NSNumber numberWithInteger:conversation.sentStatus] forKey:@"sentStatus"];
    [dictionary setValue: [NSNumber numberWithInteger:conversation.receivedTime] forKey:@"receivedTime"];
    [dictionary setValue: [NSNumber numberWithInteger:conversation.sentTime] forKey:@"sentTime"];
    [dictionary setValue:conversation.draft forKey:@"draft"];
    [dictionary setValue:conversation.objectName forKey:@"objectName"];
    [dictionary setValue:conversation.senderUserId forKey:@"senderUserId"];
    [dictionary setValue: [NSNumber numberWithInteger:conversation.lastestMessageId] forKey:@"lastestMessageId"];
    [dictionary setValue:[NSNumber numberWithInteger:conversation.lastestMessageDirection] forKey:@"lastestMessageDirection"];
//    [dictionary setValue:conversation.jsonDict forKey:@"jsonDict"];
    [dictionary setValue:conversation.lastestMessageUId forKey:@"lastestMessageUId"];
    [dictionary setValue:[NSNumber numberWithInteger:conversation.hasUnreadMentioned] forKey:@"hasUnreadMentioned"];
    NSString *messageContent = [self messageContentSetup:conversation.lastestMessage objectName:conversation.objectName];
    [dictionary setValue:messageContent  forKey:@"messageContent"];
    return dictionary;
}

- (NSString *)messageContentSetup: (RCMessageContent *)latestMessage objectName: (NSString *)objectName {
    NSString *content = @"";
    if ([objectName isEqualToString:@"RC:TxtMsg"]) {
        content = ((RCTextMessage *)latestMessage).content;
    } else if ([objectName isEqualToString:@"RC:VcMsg"]) {
        content = @"[语音消息]";
    } else if ([objectName isEqualToString:@"RC:LBSMsg"]) {
        content = @"[位置]";
    } else if ([objectName isEqualToString:@"RC:ImgMsg"]) {
        content = @"[图片]";
    } else if ([objectName isEqualToString:@"RC:ImgTextMsg"]) {
        content = @"[图文消息]";
    } else if ([objectName isEqualToString:@"RC:InfoNtf"]) {
        content = ((RCInformationNotificationMessage *)latestMessage).message;
    } else if ([objectName isEqualToString:@"RC:VCSummary"]) {
        RCCallSummaryMessage *callMessage = (RCCallSummaryMessage *)latestMessage;
        RCCallMediaType mediaType = callMessage.mediaType;
        if (mediaType == RCCallMediaAudio) {
            content = @"[音频通话]";
        } else {
            content = @"[视频通话]";
        }
    }
    return content;
}

- (NSString *)targetNameSetup: (RCConversation *)conversation {
    NSString *targetName = @"";
    NSDictionary *userInfo = [self readLocalFileWithName:@"userInfo"];
    switch (conversation.conversationType) {
        case ConversationType_PRIVATE:
            targetName = userInfo[conversation.targetId];
            break;
        case ConversationType_GROUP:
            targetName = @"群聊";
            break;
        case ConversationType_SYSTEM:
            targetName = @"系统消息助手";
            break;
        default:
            break;
    }
    return targetName;
}

- (void)pushToConversationPage:(CDVInvokedUrlCommand *)command {
    RCConversationType conversationType = [[command.arguments objectAtIndex: 0] intValue];
    NSString *targetId = [command.arguments objectAtIndex: 1];
    NSString *conversationTitle = [command.arguments objectAtIndex: 2];
    ConversationViewController *conversationVC = [[ConversationViewController alloc] init];
    conversationVC.conversationType = conversationType;
    conversationVC.targetId = targetId;
    conversationVC.title = conversationTitle;
    
    if (command.arguments.count == 4) {
//        NSInteger latestMessageId = [[command.arguments objectAtIndex: 3] intValue];
//        [[RCIMClient sharedRCIMClient] setMessageReceivedStatus:latestMessageId receivedStatus:ReceivedStatus_READ];
        conversationVC.block = ^{
            CDVPluginResult *pluginResult = nil;
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"会话界面消失"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        };
    }
    if (conversationType == ConversationType_GROUP) {
        RCGroup *groupInfo = [RCGroup new];
        groupInfo.portraitUri = @"";
        groupInfo.groupId = targetId;
        groupInfo.groupName = conversationTitle;
        [[RCIM sharedRCIM] refreshGroupInfoCache:groupInfo withGroupId:targetId];
    }
    
    UINavigationController *mainVC = [[UINavigationController alloc] initWithRootViewController:conversationVC];
    UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [rootVC presentViewController:mainVC animated:false completion:nil];
    
//    CDVPluginResult *pluginResult = nil;
//    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"跳转会话界面成功"];
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)dataSync: (NSString *)userId {
    [AFHttpTool getUserInfo:userId success:^(id response) {
        NSLog(@"%@", response);
        NSDictionary *result = response[@"content"][@"info"];
        NSString *nickname = result[@"userName"];
        NSString *portraitUri = @"";
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:nickname portrait:portraitUri];
//        if (!user.portraitUri || user.portraitUri.length <= 0) {
//            user.portraitUri = [RCDUtilities defaultUserPortrait:user];
//        }
        [[RCDataBaseManager shareInstance] insertUserToDB:user];
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
        [RCIM sharedRCIM].currentUserInfo = user;
    } failure:^(NSString *err) {
        NSLog(@"%@", err);
    }];
//    [RCDDataSource syncGroups];
//    [RCDDataSource syncFriendList:userId complete:^(NSMutableArray *friends) {
//        NSLog(@"%@", friends);
//    }];
    
//    NSString *nickname = @"";
//    if ([userId isEqualToString:@"0814DD20DA71454186A514DD8B6F0460"]) {
//        nickname = @"肖伟";
//    } else if ([userId isEqualToString:@"9531090493154c268c16eff48cbd8322"]) {
//        nickname = @"左海强";
//    } else if ([userId isEqualToString:@"9DB6539C044A46EDB63029C29A36E379"]) {
//        nickname = @"宋康";
//    } else if ([userId isEqualToString:@"A90D71E3DBE3494995ABB9729B23D1B6"]) {
//        nickname = @"胡佳妮";
//    } else if ([userId isEqualToString:@"C0E6617484AE450988F8CB25D07783BD"]) {
//        nickname = @"潘丹凤";
//    }
//    RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:nickname portrait:@""];
//    [[RCDataBaseManager shareInstance] insertUserToDB:user];
//    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
//    [RCIM sharedRCIM].currentUserInfo = user;
}

- (void)disconnect:(CDVInvokedUrlCommand*)command {
    [[RCDataBaseManager shareInstance] closeDBForDisconnect];
    [[RCIM sharedRCIM] disconnect:false];
    CDVPluginResult *pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"断开连接成功"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
#pragma mark RCIMUserInfoDataSource

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    NSLog(@"Rong cloud userID: %@", userId);
    RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:nil portrait:nil];
    return completion(user);
}


#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    NSLog(@"onRCIMConnectionStatusChanged+++++++%ld", status);
    if (status == ConnectionStatus_Connected) {
//        [self connectSucces:self.userId];
    }
}

#pragma mark - RCIMReceiveMessageDelegate

- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName {
    //群组通知不弹本地通知
    if ([message.content isKindOfClass:[RCGroupNotificationMessage class]]) {
        return YES;
    }
    if ([[message.content.class getObjectName] isEqualToString:@"RCJrmf:RpOpendMsg"]) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    return [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:nil];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    NSLog(@"onRCIMReceiveMessage---------");
    NSLog(@"%@", message);
    NSLog(@"%d", left);
    
    if (self.messageReceivedBlock) {
        self.messageReceivedBlock();
    } else if (self.messageGlobalBlock){
        self.messageGlobalBlock();
    }
//    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
//        RCInformationNotificationMessage *msg = (RCInformationNotificationMessage *)message.content;
//        // NSString *str = [NSString stringWithFormat:@"%@",msg.message];
//        if ([msg.message rangeOfString:@"你已添加了"].location != NSNotFound) {
//            [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
//                                 complete:^(NSMutableArray *friends){
//                                 }];
//        }
//    } else if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
//        RCContactNotificationMessage *msg = (RCContactNotificationMessage *)message.content;
//        if ([msg.operation isEqualToString:ContactNotificationMessage_ContactOperationAcceptResponse]) {
//            [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
//                                 complete:^(NSMutableArray *friends){
//                                 }];
//        }
//    } else if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
//        RCGroupNotificationMessage *msg = (RCGroupNotificationMessage *)message.content;
//        if ([msg.operation isEqualToString:@"Dismiss"] &&
//            [msg.operatorUserId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
//            [[RCIMClient sharedRCIMClient]clearRemoteHistoryMessages:ConversationType_GROUP
//                                                            targetId:message.targetId
//                                                          recordTime:message.sentTime
//                                                             success:^{
//                                                                 [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:message.targetId];
//                                                             }
//                                                               error:nil
//             ];
//            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:message.targetId];
//        } else if ([msg.operation isEqualToString:@"Quit"] || [msg.operation isEqualToString:@"Add"] ||
//                   [msg.operation isEqualToString:@"Kicked"] || [msg.operation isEqualToString:@"Rename"]) {
//            if (![msg.operation isEqualToString:@"Rename"]) {
//                [RCDHTTPTOOL getGroupMembersWithGroupId:message.targetId
//                                                  Block:^(NSMutableArray *result) {
//                                                      [[RCDataBaseManager shareInstance]
//                                                       insertGroupMemberToDB:result
//                                                       groupId:message.targetId
//                                                       complete:^(BOOL results){
//
//                                                       }];
//                                                  }];
//            }
//            [RCDHTTPTOOL getGroupByID:message.targetId
//                    successCompletion:^(RCDGroupInfo *group) {
//                        [[RCDataBaseManager shareInstance] insertGroupToDB:group];
//                        [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:group.groupId];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdeteGroupInfo"
//                                                                            object:message.targetId];
//                    }];
//        }
//    }
}
@end
