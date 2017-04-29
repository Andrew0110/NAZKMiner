//
//  NazkAPIManager.h
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NazkAPIManager : NSObject

+ (NazkAPIManager *)sharedManager;

-(void)fetchPersonsWithKeyword:(NSString *)keyword completion:(void (^)(NSArray *))completion;

@end
