//
//  GroupMemberModel.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import "GroupMemberModel.h"

@implementation GroupMemberModel

+(instancetype)groupMemberModelWithUser: (nullable UserModel *)user type: (GroupMemberType)type {
    GroupMemberModel *model = [[GroupMemberModel alloc] init];
    model.user = user;
    model.type = type;
    return model;
}

@end
