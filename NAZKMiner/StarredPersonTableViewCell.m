//
//  StarredPersonTableViewCell.m
//  NAZKMiner
//
//  Created by Andrew on 01.05.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "StarredPersonTableViewCell.h"
#import "NAZKPerson+CoreDataClass.h"

@implementation StarredPersonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _firstNamelabel = [UILabel new];
        _firstNamelabel.font = [UIFont systemFontOfSize:14];
        //        _firstNamelabel.numberOfLines = 0;
        [self addSubview:_firstNamelabel];
        
        _lastNamelabel = [UILabel new];
        _lastNamelabel.font = [UIFont boldSystemFontOfSize:14];
        //        _lastNamelabel.numberOfLines = 0;
        [self addSubview:_lastNamelabel];
        
        _placeOfWork = [UILabel new];
        _placeOfWork.font = [UIFont systemFontOfSize:10];
        //        _placeOfWork.lineBreakMode = NSLineBreakByWordWrapping;
        _placeOfWork.numberOfLines = 0;
        [self addSubview:_placeOfWork];
        
        _position = [UILabel new];
        _position.font = [UIFont italicSystemFontOfSize:10];
        //        _position.lineBreakMode = NSLineBreakByWordWrapping;
        _position.numberOfLines = 0;
        [self addSubview:_position];
        
        _notes = [UITextView new];
        _notes.font = [UIFont italicSystemFontOfSize:10];
        [self addSubview:_notes];
        
        _starred = [[UIImageView alloc] initWithImage:[UIImage new]];
        [self addSubview:_starred];
        
        _linkPDF = [UIImageView new];
        _linkPDF.image = [UIImage new];
        [self addSubview:_linkPDF];
    }
    
    return self;
}

- (void)configureWithNAZKPerson:(NAZKPerson *)aNAZKPerson {
    _lastNamelabel.text = aNAZKPerson.lastname;
    _firstNamelabel.text = aNAZKPerson.firstname;
    _placeOfWork.text = aNAZKPerson.placeOfWork;
    _position.text = aNAZKPerson.position;
    _notes.text = aNAZKPerson.notes;
    NSLog(@"%@", aNAZKPerson.notes);
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat rowWidth = self.frame.size.width;
    
    _lastNamelabel.frame = CGRectMake(10, 10, rowWidth-85, 15);
    _firstNamelabel.frame = CGRectMake(10, 25, rowWidth-85, 15);
    _placeOfWork.frame = CGRectMake(10, 45, rowWidth-10, 12);
    _position.frame = CGRectMake(10, 60, rowWidth-10, 12);
    _notes.frame = CGRectMake(10, 75, rowWidth-10, 30);
    
    _starred.frame = CGRectMake(rowWidth - 75, 5, 30, 30);
    _linkPDF.frame = CGRectMake(rowWidth - 40, 5, 30, 30);
    
}

@end
