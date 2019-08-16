//
//  UserModel.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import "UserModel.h"

@implementation UserModel

+(instancetype)modelWithId: (NSString *)userId name: (NSString *)name selected: (Boolean)selected {
    UserModel *model = [[UserModel alloc] init];
    model.userId = userId;
    model.name = name;
    model.selected = selected;
    model.disabled = NO;
    return model;
}

@end
