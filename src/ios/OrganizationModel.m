//
//  OrganizationModel.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import "OrganizationModel.h"

@implementation OrganizationModel

+(instancetype)modelWithId: (NSString *)orgId name: (NSString *)name {
    OrganizationModel *model = [[OrganizationModel alloc] init];
    model.orgId = orgId;
    model.name = name;
    return model;
}

@end
