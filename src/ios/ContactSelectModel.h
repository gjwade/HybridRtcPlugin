//
//  ContactSelectModel.h
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/27.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactSelectModel : NSObject

@property(nonatomic, assign) BOOL selected;
@property(nonatomic, strong) RCUserInfo *user;

+(ContactSelectModel *)initialWithUser: (RCUserInfo *)user;

@end

NS_ASSUME_NONNULL_END
