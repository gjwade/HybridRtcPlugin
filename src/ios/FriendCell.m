//
//  FriendCell.m
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/26.
//

#import "FriendCell.h"

@interface FriendCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(RCUserInfo *)model {
    self.avatarImageView.image = [UIImage imageNamed:@"user_male"];
    self.nameLabel.text = model.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
