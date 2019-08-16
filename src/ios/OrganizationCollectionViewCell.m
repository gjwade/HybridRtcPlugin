//
//  OrganizationCollectionViewCell.m
//  智慧环保政府端
//
//  Created by iOS Dev1 on 2019/8/12.
//

#import "OrganizationCollectionViewCell.h"

@interface OrganizationCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *linkImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation OrganizationCollectionViewCell

-(void)setModel:(OrganizationCollectionModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.linkImageView.hidden = !model.linkShow;
    self.lineView.hidden = !model.lineShow;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    CGRect rect = [self.nameLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    rect.size.width += 18;
    rect.size.height = 40;
    attributes.frame = rect;
    return attributes;
}

@end
