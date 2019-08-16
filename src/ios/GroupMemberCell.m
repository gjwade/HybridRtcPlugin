//
//  GroupMemberCell.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import "GroupMemberCell.h"

@interface GroupMemberCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *operateImageView;
@property (weak, nonatomic) IBOutlet UIView *cellView;

@end

@implementation GroupMemberCell

-(void)setModel:(GroupMemberModel *)model {
    _model = model;
    if (model.type == GroupMemberUser) {
        self.nameLabel.text = [self nameSetup:model.user.name];
        self.operateImageView.hidden = YES;
        self.cellView.backgroundColor = [UIColor colorWithRed:71/255.0 green:136/255.0 blue:218/255.0 alpha:1.0];
    } else if (model.type == GroupMemberAdd) {
        self.nameLabel.text = @"";
        self.operateImageView.hidden = NO;
        self.operateImageView.image = [UIImage imageNamed:@"x_plus_icon@3x.png"];
        self.cellView.backgroundColor = [UIColor clearColor];
    } else {
        self.nameLabel.text = @"";
        self.operateImageView.hidden = NO;
        self.operateImageView.image = [UIImage imageNamed:@"x_group avatar_icon@3x.png"];
        self.cellView.backgroundColor = [UIColor clearColor];
    }
}

- (NSString *)nameSetup: (NSString *)name {
    NSString *result = @"";
    if (name.length > 2) {
        result = [name substringFromIndex:name.length - 2];
    } else {
        result = name;
    }
    return result;
}

@end
