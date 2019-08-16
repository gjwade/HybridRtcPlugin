//
//  GroupMemberModel.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

typedef NS_ENUM(NSUInteger, GroupMemberType) {
    GroupMemberUser,
    GroupMemberAdd,
    GroupMemberDelete
};

NS_ASSUME_NONNULL_BEGIN

@interface GroupMemberModel : NSObject

@property(nonatomic, strong, nullable)UserModel *user;
@property(nonatomic, assign)GroupMemberType type;

+(instancetype)groupMemberModelWithUser: (nullable UserModel *)user type: (GroupMemberType)type;

@end

NS_ASSUME_NONNULL_END
