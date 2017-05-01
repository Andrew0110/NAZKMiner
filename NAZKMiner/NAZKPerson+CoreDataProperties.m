//
//  NAZKPerson+CoreDataProperties.m
//  NAZKMiner
//
//  Created by Andrew on 30.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "NAZKPerson+CoreDataProperties.h"

@implementation NAZKPerson (CoreDataProperties)

+ (NSFetchRequest<NAZKPerson *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NAZKPerson"];
}

@dynamic firstname;
@dynamic identifier;
@dynamic lastname;
@dynamic linkPDF;
@dynamic notes;
@dynamic placeOfWork;
@dynamic position;

@end
