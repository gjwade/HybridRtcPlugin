//
//  OrgnizationSelectTableViewCell.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/13.
//

#import "OrgnizationSelectTableViewCell.h"

@interface OrgnizationSelectTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation OrgnizationSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(OrganizationModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
}

@end
