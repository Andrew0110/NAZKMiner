//
//  StarredPersonTableViewCell.m
//  NAZKMiner
//
//  Created by Andrew on 01.05.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "StarredPersonTableViewCell.h"
#import "NAZKPerson+CoreDataClass.h"

@interface StarredPersonTableViewCell ()

@property (nonatomic) UILabel *commentLabel;

@end

@implementation StarredPersonTableViewCell

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
        
        _firstName = [UILabel new];
        _firstName.font = [UIFont systemFontOfSize:14];
        _firstName.numberOfLines = 0;
        _firstName.textAlignment = NSTextAlignmentCenter;
//        [_firstName setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_firstName];
        
        _lastName = [UILabel new];
        _lastName.font = [UIFont boldSystemFontOfSize:14];
        _lastName.numberOfLines = 0;
        _lastName.textAlignment = NSTextAlignmentCenter;
//        [_lastName setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_lastName];
        
        _placeOfWork = [UILabel new];
        _placeOfWork.font = [UIFont systemFontOfSize:10];
        _placeOfWork.lineBreakMode = NSLineBreakByWordWrapping;
        _placeOfWork.numberOfLines = 0;
//        [_placeOfWork setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_placeOfWork];
        
        _position = [UILabel new];
        _position.font = [UIFont italicSystemFontOfSize:10];
        _position.lineBreakMode = NSLineBreakByWordWrapping;
        _position.numberOfLines = 0;
//        [_position setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_position];
        
        _commentLabel = [UILabel new];
        _commentLabel.font = [UIFont boldSystemFontOfSize:10];
        _commentLabel.text = @"Ваш коментар:";
//        [_commentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_commentLabel];
         
        _notes = [UITextView new];
        _notes.font = [UIFont systemFontOfSize:10];
//        [_notes setTranslatesAutoresizingMaskIntoConstraints:NO];
        //_notes.layer.borderWidth = 1.f;
        _notes.layer.borderColor = [[UIColor grayColor] CGColor];
        [self.contentView addSubview:_notes];
        
        _starred = [[UIImageView alloc] initWithImage:[UIImage new]];
//        [_starred  setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_starred];
        
        _linkPDF = [UIImageView new];
        _linkPDF.image = [UIImage new];
//        [_linkPDF  setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_linkPDF];
    }
    
    return self;
}

- (void)configureWithNAZKPerson:(NAZKPerson *)aNAZKPerson {
    _lastName.text = aNAZKPerson.lastname;
    _firstName.text = aNAZKPerson.firstname;
    _placeOfWork.text = [NSString stringWithFormat:@"Організація: %@",aNAZKPerson.placeOfWork];
    _position.text = [NSString stringWithFormat:@"Посада: %@", aNAZKPerson.position];
    _notes.text = aNAZKPerson.notes;
}

+ (CGFloat)calculateCellHeightWithPerson:(NAZKPerson *)aPerson {
    CGFloat height = 7 * kVertMargin + 3 * kLabelHeight +40;
    
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
//    CGRect rect3 = [[NSString stringWithFormat:@"%@", aPerson.notes] boundingRectWithSize:CGSizeMake(width - 2 * kHorMargin, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
//    CGFloat notesHeight = rect3.size.height;
//    if (notesHeight < 0) {
//        notesHeight = 30;
//    }
    height += rect1.size.height + rect2.size.height;
    
    return height;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat rowWidth = self.frame.size.width;
    
    _lastName.frame = CGRectMake(kHorMargin, kVertMargin, rowWidth-2*kImageWidth - 2*kHorMargin, kLabelHeight);
    
    _firstName.frame = CGRectMake(kHorMargin, CGRectGetMaxY(_lastName.frame)+kVertMargin, rowWidth-2*kImageWidth - 2*kHorMargin, kLabelHeight);
    _placeOfWork.frame = CGRectMake(kHorMargin, CGRectGetMaxY(_firstName.frame)+kVertMargin, rowWidth-kHorMargin, 0);
    [_placeOfWork sizeToFit];
    _position.frame = CGRectMake(kHorMargin, CGRectGetMaxY(_placeOfWork.frame)+kVertMargin, rowWidth-kHorMargin, 0);
    [_position sizeToFit];
    _commentLabel.frame = CGRectMake(kHorMargin, CGRectGetMaxY(_position.frame)+kVertMargin, rowWidth-kHorMargin, kLabelHeight);
    _notes.frame = CGRectMake(kHorMargin, CGRectGetMaxY(_commentLabel.frame), rowWidth-2*kHorMargin, 40);
//    if (_notes.text.length > 30) {
//        [_notes sizeToFit];
//    }

    _starred.frame = CGRectMake(rowWidth - 2*kImageWidth - 2*kHorMargin, kVertMargin, kImageWidth, kImageHeight);
    _linkPDF.frame = CGRectMake(rowWidth - kImageWidth - kHorMargin, kVertMargin, kImageWidth, kImageHeight);

    
//    NSDictionary *names = NSDictionaryOfVariableBindings(_firstName, _lastName, _placeOfWork, _position, _commentLabel, _notes, _starred,_linkPDF);
//    
//    NSArray *verticalConstraint = [NSLayoutConstraint
//                                    constraintsWithVisualFormat:@"V:|-5-[_lastName]-3-[_firstName]-5-[_placeOfWork]-3-[_position]-3-[_commentLabel]-3-[_notes(>=20)]"
//                                    options:NSLayoutFormatDirectionLeadingToTrailing
//                                    metrics:nil
//                                    views:names];
//    NSArray *vertical2Constraint = [NSLayoutConstraint
//                                   constraintsWithVisualFormat:@"V:|-[_starred(==30)]"
//                                   options:NSLayoutFormatDirectionLeadingToTrailing
//                                   metrics:nil
//                                   views:names];
//    NSArray *vertical3Constraint = [NSLayoutConstraint
//                                    constraintsWithVisualFormat:@"V:|-[_linkPDF(==30)]"
//                                    options:NSLayoutFormatDirectionLeadingToTrailing
//                                    metrics:nil
//                                    views:names];
//    NSArray *horisontalConstraint = [NSLayoutConstraint
//                                     constraintsWithVisualFormat:@"H:|-[_lastName]-0-[_starred(==30)]-5-[_linkPDF(==30)]-5-|"
//                                     options:NSLayoutFormatDirectionLeadingToTrailing
//                                     metrics:nil
//                                     views:names];
//    NSArray *horisontal2Constraint = [NSLayoutConstraint
//                                     constraintsWithVisualFormat:@"H:|-[_firstName]-[_starred(==30)]-5-[_linkPDF(==30)]-5-|"
//                                     options:NSLayoutFormatDirectionLeadingToTrailing
//                                     metrics:nil
//                                     views:names];
//    NSArray *horisontal3Constraint = [NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"H:|-[_placeOfWork]-|"
//                                      options:NSLayoutFormatDirectionLeadingToTrailing
//                                      metrics:nil
//                                      views:names];
//    NSArray *horisontal4Constraint = [NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"H:|-[_position]-|"
//                                      options:NSLayoutFormatDirectionLeadingToTrailing
//                                      metrics:nil
//                                      views:names];
//    NSArray *horisontal5Constraint = [NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"H:|-[_commentLabel]-|"
//                                      options:NSLayoutFormatDirectionLeadingToTrailing
//                                      metrics:nil
//                                      views:names];
//    NSArray *horisontal6Constraint = [NSLayoutConstraint
//                                      constraintsWithVisualFormat:@"H:|-[_notes]-|"
//                                      options:NSLayoutFormatDirectionLeadingToTrailing
//                                      metrics:nil
//                                      views:names];
//    
//    [self.contentView addConstraints:verticalConstraint];
//    [self.contentView addConstraints:vertical2Constraint];
//    [self.contentView addConstraints:vertical3Constraint];
//    [self.contentView addConstraints:horisontalConstraint];
//    [self.contentView addConstraints:horisontal2Constraint];
//    [self.contentView addConstraints:horisontal3Constraint];
//    [self.contentView addConstraints:horisontal4Constraint];
//    [self.contentView addConstraints:horisontal5Constraint];
//    [self.contentView addConstraints:horisontal6Constraint];

}

@end
