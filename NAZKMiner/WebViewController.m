//
//  WebViewController.m
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic) NSURL *url;
@property (nonatomic) UIWebView *webView;

@end

@implementation WebViewController

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    //NSLog(@"%@", url);
    _url = url;
    
    return self;
}

- (void) loadView {
    _webView = [UIWebView new];
    self.view = _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLRequest *requestObj = [NSURLRequest requestWithURL:_url];
    [_webView loadRequest:requestObj];
}



@end
