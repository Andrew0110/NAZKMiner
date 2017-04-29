//
//  Person.m
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (instancetype)personFromDict:(NSDictionary *)source {
    Person *person = [Person new];
    
    person.identifier     = source[@"id"];
    person.firstName      = source[@"firstname"];
    person.lastName       = source[@"lastname"];
    person.placeOfWork    = source[@"placeOfWork"];
    person.position       = source[@"position"];
    person.linkPDF        = source[@"linkPDF"];
    
    return person;
}


- (instancetype)initWithID:(NSString *)identifier
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
               placeOfWork:(NSString *)placeOfWork
                  position:(NSString *)position
                   linkPDF:(NSString *)linkPDF {
    self = [super init];
    
    if (self) {
        _identifier     = identifier;
        _firstName      = firstName;
        _lastName       = lastName;
        _placeOfWork    = placeOfWork;
        _position       = position;
        _linkPDF        = linkPDF;
    }
    
    return self;
}

@end
