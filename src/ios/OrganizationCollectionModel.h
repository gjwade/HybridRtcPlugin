//
//  OrganizationCollectionModel.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrganizationCollectionModel : NSObject

@property(nonatomic, strong)NSString *orgId;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, assign)Boolean linkShow;
@property(nonatomic, assign)Boolean lineShow;

+(instancetype)modelWithOrgId: (NSString *)orgId name: (NSString *)name linkShow: (Boolean)linkShow lineShow: (Boolean)lineShow;

@end

NS_ASSUME_NONNULL_END
