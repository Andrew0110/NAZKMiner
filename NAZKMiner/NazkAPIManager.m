//
//  NazkAPIManager.m
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "NazkAPIManager.h"
#import "Person.h"
#import <UIKit/UIKit.h>

@implementation NazkAPIManager

static NSString * const kBaseURL = @"https://public-api.nazk.gov.ua/v1/declaration/";

- (instancetype)init {
    self = [super init];
    if (self) {
        _hasConnection = true;
        //        _accessToken = kAccessToken;
    }
    
    return self;
}

+ (NazkAPIManager *)sharedManager {
    static NazkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [NazkAPIManager new];
    });
    
    return manager;
}

- (void)fetchPersonsWithKeyword:(NSString *)keyword page:(int)page completion:(void (^)(NSArray *, int))completion {
    if (page < 1) {
        page = 1;
    }
    NSString *requestURL = [NSString stringWithFormat:@"%@?q=%@&page=%d", kBaseURL, [keyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]], page];
    
    NSLog(@"%@", requestURL);

    
    NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:requestURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    
    NSURLSessionDataTask *dataTask =
            [session dataTaskWithRequest:req
                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                           if (error) {
                               NSLog(@"%@", [error localizedDescription]);
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Не вдалося загрузити дані. Можливо, немає мережі. Ви можете працювати з обраними записами"
                                    delegate:nil
                                cancelButtonTitle:@"Ok"
                                otherButtonTitles:nil];
                               [alertView show];
                               _hasConnection = false;
                        } else {
                            _hasConnection = true;
                            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            NSMutableArray *persons = [NSMutableArray array];
                            int currentPage = [[[jsonObject objectForKey:@"page"] objectForKey:@"currentPage"] integerValue];
                            int batchSize = [[[jsonObject objectForKey:@"page"] objectForKey:@"batchSize"] integerValue];
                            int totalItems = [[[jsonObject objectForKey:@"page"] objectForKey:@"totalItems"] integerValue];
                            int nextPage = currentPage + 1;
                            if (batchSize == 0) {
                                nextPage = -1;
                            } else if (nextPage > totalItems/batchSize) {
                                nextPage = -1;
                            }
                            for ( NSDictionary *dict in [jsonObject objectForKey:@"items"]) {
                                [persons addObject:[Person personFromDict:dict]];
                            }
                            if (completion) {
                                completion(persons, nextPage);
                            }
                        }
                    }];
    [dataTask resume];
}

-(void)fetchPersonsWithKeyword:(NSString *)keyword completion:(void (^)(NSArray *, int))completion {
    [self fetchPersonsWithKeyword:keyword page:0 completion:completion];
}


@end
