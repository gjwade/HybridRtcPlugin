//
//  ContactSelectModel.m
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/27.
//

#import "ContactSelectModel.h"

@implementation ContactSelectModel

+(ContactSelectModel *)initialWithUser: (RCUserInfo *)user {
    ContactSelectModel *model = [[ContactSelectModel alloc] init];
    model.user = user;
    model.selected = false;
    return model;
}

@end
