//
//  NAZKPerson+CoreDataProperties.m
//  NAZKMiner
//
//  Created by Andrew on 29.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "NAZKPerson+CoreDataProperties.h"

@implementation NAZKPerson (CoreDataProperties)

+ (NSFetchRequest<NAZKPerson *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NAZKPerson"];
}

@dynamic identifier;
@dynamic firstname;
@dynamic lastname;
@dynamic placeOfWork;
@dynamic position;
@dynamic linkPDF;
@dynamic notes;

@end
