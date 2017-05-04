//
//  NazkAPIManager.h
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NazkAPIManager : NSObject

@property (nonatomic) Boolean hasConnection;

+ (NazkAPIManager *)sharedManager;

-(void)fetchPersonsWithKeyword:(NSString *)keyword completion:(void (^)(NSArray *, int))completion;
-(void)fetchPersonsWithKeyword:(NSString *)keyword page:(int)page completion:(void (^)(NSArray *, int))completion;


@end
