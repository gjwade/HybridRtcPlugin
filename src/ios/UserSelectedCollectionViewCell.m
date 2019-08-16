//
//  UserSelectedCollectionViewCell.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/14.
//

#import "UserSelectedCollectionViewCell.h"

@interface UserSelectedCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation UserSelectedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(UserModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
}

- (IBAction)deleteButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(userSelectedCollectionViewCell:deleteButtonDidClick:)]) {
        [self.delegate userSelectedCollectionViewCell:self deleteButtonDidClick:sender];
    }
}

@end
