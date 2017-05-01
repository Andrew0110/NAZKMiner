//
//  DataStoreManager.h
//  NAZKMiner
//
//  Created by Andrew on 30.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAZKPerson+CoreDataClass.h"

@class Person;

@interface DataStoreManager : NSObject

+ (DataStoreManager *)sharedManager;

- (NSArray *)getAllPersonsDict;
- (NSArray *)getAllPersons;
- (NSSet *)getAllIDs;
- (NAZKPerson *)getPersonWithID:(NSString *)id;
- (void)insertPerson:(Person *)person withNote:(NSString *)note;
- (void)removePersonWithID:(NSString *)id;
- (void)removePerson:(NAZKPerson *)person;
- (BOOL)havePersonWithID:(NSString *)id;
- (void)clearDatabase;

@end
