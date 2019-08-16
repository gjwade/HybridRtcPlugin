//
//  OrganizationModel.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrganizationModel : NSObject

@property(nonatomic, strong)NSString *orgId;
@property(nonatomic, strong)NSString *name;

+(instancetype)modelWithId: (NSString *)orgId name: (NSString *)name;

@end

NS_ASSUME_NONNULL_END
