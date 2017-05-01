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

static NSString * const kBaseURL = @"https://public-api.nazk.gov.ua/v1/declaration/?q=";

- (instancetype)init {
    self = [super init];
    if (self) {
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

- (void)fetchPersonsWithKeyword:(NSString *)keyword completion:(void (^)(NSArray *))completion {
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseURL, [keyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    //NSLog(@"%@", requestURL);

    
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
                        } else {
                            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            NSMutableArray *persons = [NSMutableArray array];
                            for ( NSDictionary *dict in [jsonObject objectForKey:@"items"]) {
                                [persons addObject:[Person personFromDict:dict]];
                            }
                            if (completion) {
                                completion(persons);
                            }
                        }
                    }];
    [dataTask resume];

}

@end
