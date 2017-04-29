//
//  PersonTableViewCell.h
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface PersonTableViewCell : UITableViewCell

@property (nonatomic) UILabel       *firstNamelabel;
@property (nonatomic) UILabel       *lastNamelabel;
@property (nonatomic) UILabel       *placeOfWork;
@property (nonatomic) UILabel       *position;
@property (nonatomic) UIImageView   *starred;
@property (nonatomic) UIImageView   *linkPDF;

- (void)configureWithPerson:(Person *)aPerson;

@end
