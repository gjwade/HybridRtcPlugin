//
//  ConversationViewController.h
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/13.
//

#import <RongIMKit/RongIMKit.h>

typedef void(^DismissBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ConversationViewController : RCConversationViewController

@property (nonatomic,copy)DismissBlock block;

@end

NS_ASSUME_NONNULL_END
