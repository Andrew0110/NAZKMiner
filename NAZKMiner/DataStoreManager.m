//
//  DataStoreManager.m
//  NAZKMiner
//
//  Created by Andrew on 30.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "DataStoreManager.h"
#import "AppDelegate.h"
#import "Person.h"
#import "NAZKPerson+CoreDataClass.h"

@interface DataStoreManager()

@property (nonatomic) NSManagedObjectContext *context;

@end

@implementation DataStoreManager

- (instancetype)init {
    self = [super init];
    if (self) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _context = delegate.persistentContainer.viewContext;
    }
    
    return self;
}

+ (DataStoreManager *)sharedManager {
    static DataStoreManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [DataStoreManager new];
    });
    
    return manager;
}

- (NSArray *)getAllPersons {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"NAZKPerson" inManagedObjectContext:_context];
    
    [request setEntity: description];
//    [request setResultType:NSDictionaryResultType];
    NSError* error = nil;
    NSArray *resultArray = [_context executeFetchRequest:request error:&error];
    
    return resultArray;
}

- (NSArray *)getAllPersonsDict {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"NAZKPerson" inManagedObjectContext:_context];
    
    [request setEntity: description];
    
    NSSortDescriptor *lastNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:true];
    NSSortDescriptor *firstNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:true];
    [request setSortDescriptors:@[lastNameSortDescriptor, firstNameSortDescriptor]];
    
    [request setResultType:NSDictionaryResultType];
    NSError* error = nil;
    NSArray *resultArray = [_context executeFetchRequest:request error:&error];
    
    return resultArray;
}

- (NSSet *)getAllIDs {
    NSArray *allPersons = [self getAllPersons];
    NSMutableSet * allIDs = [NSMutableSet new];
    for (NAZKPerson *pers in allPersons) {
        [allIDs addObject:pers.identifier];
    }
    return allIDs;
}


- (NAZKPerson *)getPersonWithID:(NSString *)id {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"NAZKPerson" inManagedObjectContext:_context];
    [request setEntity: description];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", id];
    [request setPredicate:predicate];
    
    NAZKPerson *pers = [[_context executeFetchRequest:request error:nil] firstObject];
    
    return pers;
}

- (void)insertPerson:(Person *)person withNote:(NSString *)note {
    NSManagedObject *nazkPerson = [NSEntityDescription insertNewObjectForEntityForName:@"NAZKPerson" inManagedObjectContext:_context];
    
    [nazkPerson setValue:person.firstName forKey:@"firstname"];
    [nazkPerson setValue:person.identifier forKey:@"identifier"];
    [nazkPerson setValue:person.lastName forKey:@"lastname"];
    [nazkPerson setValue:person.placeOfWork forKey:@"placeOfWork"];
    [nazkPerson setValue:person.position forKey:@"position"];
    [nazkPerson setValue:person.linkPDF forKey:@"linkPDF"];
    [nazkPerson setValue:note forKey:@"notes"];
    
    NSError* error = nil;
    if (![_context save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }

}

- (void)updateNote:(NSString *)note forPerson:(NAZKPerson *)person {
    if (person) {
        person.notes = note;
    }
    [_context save:nil];
}


- (void)removePersonWithID:(NSString *)id {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"NAZKPerson" inManagedObjectContext:_context];
    [request setEntity: description];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", id];
    [request setPredicate:predicate];
    NAZKPerson *pers = [[_context executeFetchRequest:request error:nil] firstObject];
    if (pers) {
        [_context deleteObject:pers];
        [_context save:nil];
    }
}

- (void)removePerson:(NAZKPerson *)person {
    if (person) {
        [_context deleteObject:person];
        [_context save:nil];
    }
}


- (BOOL)havePersonWithID:(NSString *)id {
    return false;
}

- (void)clearDatabase {
    NSArray *persons = [self getAllPersons];
    
    for (NAZKPerson *person in persons) {
        [_context deleteObject: person];
    }
    [_context save:nil];

}


@end
