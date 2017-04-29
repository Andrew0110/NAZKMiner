//
//  Person.h
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic) NSString  *identifier;
@property (nonatomic) NSString  *firstName;
@property (nonatomic) NSString  *lastName;
@property (nonatomic) NSString  *placeOfWork;
@property (nonatomic) NSString  *position;
@property (nonatomic) NSString  *linkPDF;

+ (instancetype)personFromDict:(NSDictionary *)source;

- (instancetype)initWithID:(NSString *)identifier
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
               placeOfWork:(NSString *)placeOfWork
                  position:(NSString *)position
                   linkPDF:(NSString *)linkPDF;

@end
