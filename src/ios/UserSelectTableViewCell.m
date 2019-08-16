//
//  UserSelectTableViewCell.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import "UserSelectTableViewCell.h"

@interface UserSelectTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation UserSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(UserModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    if (model.selected) {
        self.checkImageView.image = [UIImage imageNamed:@"radio_checked"];
    } else {
        self.checkImageView.image = [UIImage imageNamed:@"radio_off"];
    }
    if (model.disabled) {
        self.backView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    } else {
        self.backView.backgroundColor = [UIColor whiteColor];
    }
}

@end
