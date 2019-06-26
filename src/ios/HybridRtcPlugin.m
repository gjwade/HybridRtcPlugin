/********* HybridRtcPlugin.m Cordova Plugin Implementation *******/

#import "HybridRtcPlugin.h"
#import <RongIMLib/RongIMLib.h>
#import <RongCallLib/RongCallLib.h>
#import <RongCallKit/RongCallKit.h>
#import "RongYunMainVC.h"
#import "RCDRCIMDataSource.h"
#import "RCDHTTPTOOL.h"
#import "RCDataBaseManager.h"
#import "AFHttpTool.h"
#import "RCDUtilities.h"

@interface HybridRtcPlugin()<RCCallSessionDelegate, RCIMConnectionStatusDelegate, RCIMReceiveMessageDelegate, RCIMUserInfoDataSource, RCIMGroupMemberDataSource>

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
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"连接成功"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
//- (void)connectWithToken:(CDVInvokedUrlCommand *)command {
//    __block CDVPluginResult *pluginResult = nil;
//    __weak __typeof(self) weakSelf = self;
////    NSString *appKey = [command.arguments objectAtIndex: 0];
//    NSString *appKey = @"n19jmcy59f1q9";
//    [[RCIM sharedRCIM] initWithAppKey:appKey];
//    [self initialSetup];
//    NSString *token = [command.arguments objectAtIndex: 1];
//    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
//        [self connectSucces:command];
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:userId];
//        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    } error:^(RCConnectErrorCode status) {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
//        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    } tokenIncorrect:^{
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"token不正确"];
//        [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    }];
//}

- (void)connectWithToken:(CDVInvokedUrlCommand *)command {
    //    NSString *appKey = [command.arguments objectAtIndex: 0];
    NSString *appKey = @"n19jmcy59f1q9";
    [[RCIM sharedRCIM] initWithAppKey:appKey];
    [self initialSetup];
    [self loginToserve:command];
}
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
- (void)connectSucces: (CDVInvokedUrlCommand*)command userId: (NSString *)userId {
    NSLog(@"连接成功");
    [self dataSync: userId];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *rongyunSb = [UIStoryboard storyboardWithName:@"RongYunStoryboard" bundle:nil];
        RongYunMainVC *mainVC = (RongYunMainVC *)[rongyunSb instantiateViewControllerWithIdentifier:@"RongYunMainVC"];
        UIViewController *rootVC = [[UIApplication sharedApplication] keyWindow].rootViewController;
        [rootVC presentViewController:mainVC animated:false completion:nil];
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
    [AFHttpTool loginWithPhone:userName password:password region:@"86" success:^(id response) {
        NSLog(@"%@", response);
        NSString *token = response[@"result"][@"token"];
        NSString *userId = response[@"result"][@"id"];
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            [self connectSucces:command userId:userId];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:userId];
            [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } error:^(RCConnectErrorCode status) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
            [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } tokenIncorrect:^{
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"token不正确"];
            [weakSelf.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    } failure:^(NSError *err) {
        NSLog(@"%@", err);
    }];
}

- (void)dataSync: (NSString *)userId {
    [AFHttpTool getUserInfo:userId success:^(id response) {
        NSLog(@"%@", response);
        NSDictionary *result = response[@"result"];
        NSString *nickname = result[@"nickname"];
        NSString *portraitUri = result[@"portraitUri"];
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:nickname portrait:portraitUri];
        if (!user.portraitUri || user.portraitUri.length <= 0) {
            user.portraitUri = [RCDUtilities defaultUserPortrait:user];
        }
        [[RCDataBaseManager shareInstance] insertUserToDB:user];
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
        [RCIM sharedRCIM].currentUserInfo = user;
    } failure:^(NSError *err) {
        NSLog(@"%@", err);
    }];
    [RCDDataSource syncGroups];
    [RCDDataSource syncFriendList:userId complete:^(NSMutableArray *friends) {
        NSLog(@"%@", friends);
    }];
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
    NSLog(@"%ld", status);
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

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msg = (RCInformationNotificationMessage *)message.content;
        // NSString *str = [NSString stringWithFormat:@"%@",msg.message];
        if ([msg.message rangeOfString:@"你已添加了"].location != NSNotFound) {
            [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
                                 complete:^(NSMutableArray *friends){
                                 }];
        }
    } else if ([message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        RCContactNotificationMessage *msg = (RCContactNotificationMessage *)message.content;
        if ([msg.operation isEqualToString:ContactNotificationMessage_ContactOperationAcceptResponse]) {
            [RCDDataSource syncFriendList:[RCIM sharedRCIM].currentUserInfo.userId
                                 complete:^(NSMutableArray *friends){
                                 }];
        }
    } else if ([message.content isMemberOfClass:[RCGroupNotificationMessage class]]) {
        RCGroupNotificationMessage *msg = (RCGroupNotificationMessage *)message.content;
        if ([msg.operation isEqualToString:@"Dismiss"] &&
            [msg.operatorUserId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
            [[RCIMClient sharedRCIMClient]clearRemoteHistoryMessages:ConversationType_GROUP
                                                            targetId:message.targetId
                                                          recordTime:message.sentTime
                                                             success:^{
                                                                 [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:message.targetId];
                                                             }
                                                               error:nil
             ];
            [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:message.targetId];
        } else if ([msg.operation isEqualToString:@"Quit"] || [msg.operation isEqualToString:@"Add"] ||
                   [msg.operation isEqualToString:@"Kicked"] || [msg.operation isEqualToString:@"Rename"]) {
            if (![msg.operation isEqualToString:@"Rename"]) {
                [RCDHTTPTOOL getGroupMembersWithGroupId:message.targetId
                                                  Block:^(NSMutableArray *result) {
                                                      [[RCDataBaseManager shareInstance]
                                                       insertGroupMemberToDB:result
                                                       groupId:message.targetId
                                                       complete:^(BOOL results){
                                                           
                                                       }];
                                                  }];
            }
            [RCDHTTPTOOL getGroupByID:message.targetId
                    successCompletion:^(RCDGroupInfo *group) {
                        [[RCDataBaseManager shareInstance] insertGroupToDB:group];
                        [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:group.groupId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdeteGroupInfo"
                                                                            object:message.targetId];
                    }];
        }
    }
}
@end
