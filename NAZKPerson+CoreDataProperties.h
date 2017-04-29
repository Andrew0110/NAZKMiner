//
//  NAZKPerson+CoreDataProperties.h
//  NAZKMiner
//
//  Created by Andrew on 29.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "NAZKPerson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NAZKPerson (CoreDataProperties)

+ (NSFetchRequest<NAZKPerson *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *identifier;
@property (nullable, nonatomic, copy) NSString *firstname;
@property (nullable, nonatomic, copy) NSString *lastname;
@property (nullable, nonatomic, copy) NSString *placeOfWork;
@property (nullable, nonatomic, copy) NSString *position;
@property (nullable, nonatomic, copy) NSString *linkPDF;
@property (nullable, nonatomic, copy) NSString *notes;

@end

NS_ASSUME_NONNULL_END
