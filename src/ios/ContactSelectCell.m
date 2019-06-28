//
//  ContactSelectCell.m
//  VueCommonComponents
//
//  Created by iOS Dev1 on 2019/6/27.
//

#import "ContactSelectCell.h"

@interface ContactSelectCell()

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ContactSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(ContactSelectModel *)model {
    self.nameLabel.text = model.user.name;
    if (model.selected) {
        self.selectImageView.image = [UIImage imageNamed:@"select"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"unselect"];
    }
}

@end
