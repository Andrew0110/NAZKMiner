//
//  PersonTableViewCell.m
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "PersonTableViewCell.h"
#import "Person.h"

@implementation PersonTableViewCell

static NSUInteger const kVertMargin = 5;
static NSUInteger const kLabelHeight = 15;
static NSUInteger const kHorMargin = 8;
static NSUInteger const kImageWidth = 30;
static NSUInteger const kImageHeight = 30;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _firstNamelabel = [UILabel new];
        _firstNamelabel.font = [UIFont systemFontOfSize:14];
        _firstNamelabel.textAlignment = NSTextAlignmentCenter;
//        _firstNamelabel.numberOfLines = 0;
        [self addSubview:_firstNamelabel];
        
        _lastNamelabel = [UILabel new];
        _lastNamelabel.textAlignment = NSTextAlignmentCenter;
        _lastNamelabel.font = [UIFont boldSystemFontOfSize:14];
//        _lastNamelabel.numberOfLines = 0;
        [self addSubview:_lastNamelabel];
        
        _placeOfWork = [UILabel new];
        _placeOfWork.font = [UIFont systemFontOfSize:10];
        _placeOfWork.lineBreakMode = NSLineBreakByWordWrapping;
        _placeOfWork.numberOfLines = 0;
        [self addSubview:_placeOfWork];
        
        _position = [UILabel new];
        _position.font = [UIFont italicSystemFontOfSize:10];
        _position.lineBreakMode = NSLineBreakByWordWrapping;
        _position.numberOfLines = 0;
        [self addSubview:_position];
        
        _starred = [[UIImageView alloc] initWithImage:[UIImage new]];
        [self addSubview:_starred];
        
        _linkPDF = [UIImageView new];
        _linkPDF.image = [UIImage new];
        [self addSubview:_linkPDF];
    }
    
    return self;
}

- (void)configureWithPerson:(Person *)aPerson {
    _lastNamelabel.text = aPerson.lastName;
    _firstNamelabel.text = aPerson.firstName;
    _placeOfWork.text = [NSString stringWithFormat:@"Організація: %@",aPerson.placeOfWork];
    _position.text = [NSString stringWithFormat:@"Посада: %@", aPerson.position];
}

+ (CGFloat)calculateCellHeightWithPerson:(Person *)aPerson {
    CGFloat height = 5 * kVertMargin + 2 * kLabelHeight;
    
    UIFont* font = [UIFont systemFontOfSize:10.f];
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font , NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName, nil];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect rect1 = [[NSString stringWithFormat:@"Організація: %@", aPerson.placeOfWork] boundingRectWithSize:CGSizeMake(width - 2 * kHorMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    CGRect rect2 = [[NSString stringWithFormat:@"Посада: %@", aPerson.position] boundingRectWithSize:CGSizeMake(width - 2 * kHorMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    height += rect1.size.height + rect2.size.height;

    return height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat rowWidth = self.frame.size.width;
    
    _lastNamelabel.frame = CGRectMake(kHorMargin, kVertMargin, rowWidth-2*kImageWidth - 2*kHorMargin, kLabelHeight);
    _firstNamelabel.frame = CGRectMake(kHorMargin, CGRectGetMaxY(_lastNamelabel.frame)+kVertMargin, rowWidth-2*kImageWidth - 2*kHorMargin, kLabelHeight);
    _placeOfWork.frame = CGRectMake(kHorMargin, CGRectGetMaxY(_firstNamelabel.frame)+kVertMargin, rowWidth-kHorMargin, 0);
    [_placeOfWork sizeToFit];
    _position.frame = CGRectMake(kHorMargin, CGRectGetMaxY(_placeOfWork.frame)+kVertMargin, rowWidth-kHorMargin, 0);
    [_position sizeToFit];

    _starred.frame = CGRectMake(rowWidth - 2*kImageWidth - 2*kHorMargin, kVertMargin, kImageWidth, kImageHeight);
    _linkPDF.frame = CGRectMake(rowWidth - kImageWidth - kHorMargin, kVertMargin, kImageWidth, kImageHeight);

}

@end
