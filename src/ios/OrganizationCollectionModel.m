//
//  OrganizationCollectionModel.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import "OrganizationCollectionModel.h"

@implementation OrganizationCollectionModel

+(instancetype)modelWithOrgId: (NSString *)orgId name: (NSString *)name linkShow: (Boolean)linkShow lineShow: (Boolean)lineShow {
    OrganizationCollectionModel *model = [[OrganizationCollectionModel alloc] init];
    model.orgId = orgId;
    model.name = name;
    model.linkShow = linkShow;
    model.lineShow = lineShow;
    return model;
}

@end
