//
//  StarredPersonView.m
//  NAZKMiner
//
//  Created by Andrew on 01.05.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "StarredPersonView.h"

@implementation StarredPersonView

//static CGFloat const kSearchBarHeight = 44;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _tableView = [UITableView new];
        //_tableView.rowHeight = UITableViewAutomaticDimension;
        //_tableView.estimatedRowHeight = 60.0;
        [self addSubview:_tableView];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat width = self.bounds.size.width;
    const CGFloat height = self.bounds.size.height;
    
    CGFloat yOffset = 0;
    
    //_searchBar.frame = CGRectMake(0, yOffset, width, kSearchBarHeight);
    //yOffset += CGRectGetHeight(_searchBar.frame);
    yOffset = 0;
    _tableView.frame = CGRectMake(0, yOffset, width, height-yOffset);
}

@end
