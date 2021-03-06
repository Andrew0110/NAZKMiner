//
//  StarredPersonTableViewCell.h
//  NAZKMiner
//
//  Created by Andrew on 01.05.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NAZKPerson;

@interface StarredPersonTableViewCell : UITableViewCell

@property (nonatomic) UILabel       *firstName;
@property (nonatomic) UILabel       *lastName;
@property (nonatomic) UILabel       *placeOfWork;
@property (nonatomic) UILabel       *position;
@property (nonatomic) UITextView    *notes;
@property (nonatomic) UIImageView   *starred;
@property (nonatomic) UIImageView   *linkPDF;

- (void)configureWithNAZKPerson:(NAZKPerson *)aNAZKPerson;

+ (CGFloat)calculateCellHeightWithPerson:(NAZKPerson *)aPerson;

@end
