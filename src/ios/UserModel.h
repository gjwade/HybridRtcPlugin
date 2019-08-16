//
//  UserModel.h
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property(nonatomic, strong)NSString *userId;
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *position;
@property(nonatomic, assign)BOOL selected;
@property(nonatomic, assign)BOOL disabled;

+(instancetype)modelWithId: (NSString *)userId name: (NSString *)name selected: (Boolean)selected;

@end

NS_ASSUME_NONNULL_END
