//
//  ViewController.m
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "StarredViewController.h"
#import "StarredPersonView.h"
#import "StarredPersonTableViewCell.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "DataStoreManager.h"
#import "NAZKPerson+CoreDataClass.h"

@interface StarredViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextViewDelegate>

@property (nonatomic) StarredPersonView *starredView;
@property (nonatomic) NSArray *persons;
@property (nonatomic) NSSet *starredIDs;
@property (nonatomic) DataStoreManager *dataManager;
@property (nonatomic) NSMutableArray *cellHeights;



@end

@implementation StarredViewController

static NSString * const kStarredPersonCellIdentifier = @"StarredPersonViewCell";
static NSUInteger const kCellHeight = 120;

- (void) loadView {
    _starredView = [StarredPersonView new];
    self.view = _starredView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _starredView.tableView.dataSource = self;
    _starredView.tableView.delegate = self;
    
    _starredView.tableView.bounces = YES;
    _starredView.tableView.showsVerticalScrollIndicator = YES;
    
    _starredView.tableView.rowHeight = UITableViewAutomaticDimension;
    _starredView.tableView.estimatedRowHeight = kCellHeight;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _dataManager = [DataStoreManager sharedManager];
    [self reloadPage];
    
    [_starredView.tableView registerClass: [StarredPersonTableViewCell class] forCellReuseIdentifier: kStarredPersonCellIdentifier];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:NO];
    self.navigationItem.title = @"Обрані";
}

#pragma mark - Actions

- (void) reloadPage {
    _persons = [_dataManager getAllPersons];
    _cellHeights = [NSMutableArray new];
    for (int i = 0; i<_persons.count; ++i) {
        [_cellHeights addObject:[NSNumber numberWithFloat:0.f]];
    }
    [_starredView.tableView reloadData];
}

- (void)starClick: (UITapGestureRecognizer *)tapGesture {
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    NAZKPerson *person = _persons[imageView.tag];
    
    [_dataManager removePerson:person];
    
    [self reloadPage];
}

- (void)openPDFLink: (UITapGestureRecognizer *)tapGesture {
    UIImageView *image = (UIImageView *)tapGesture.view;
    NAZKPerson *person = _persons[image.tag];
    if (person.linkPDF) {
        WebViewController *wvc = [[WebViewController alloc] initWithURL:[NSURL URLWithString:person.linkPDF]];
        
        [self.navigationController pushViewController:wvc
                                             animated:YES];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return kCellHeight;
//    return UITableViewAutomaticDimension;
    if ([[_cellHeights objectAtIndex:indexPath.row] floatValue] < 1.f) {
        [_cellHeights insertObject:[NSNumber numberWithFloat:[StarredPersonTableViewCell calculateCellHeightWithPerson:_persons[indexPath.row]]] atIndex:indexPath.row];
    }
    return [_cellHeights[indexPath.row] floatValue];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    NAZKPerson *person = (NAZKPerson*)_persons[indexPath.row];
    
    [(StarredPersonTableViewCell*)cell configureWithNAZKPerson:person];
    
    UITextView *notes = ((StarredPersonTableViewCell*)cell).notes;
    notes.delegate = self;
    notes.editable = YES;
    notes.tag = indexPath.row;
    
    UIImageView *imageStarred = ((StarredPersonTableViewCell*)cell).starred;
    imageStarred.image = [UIImage imageNamed:@"star"];
    imageStarred.tag = indexPath.row;
    imageStarred.userInteractionEnabled = true;
    [imageStarred addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starClick:)]];
    
    if (person.linkPDF) {
        UIImageView *linkView = ((StarredPersonTableViewCell *)cell).linkPDF;
        linkView.image = [UIImage imageNamed:@"book"];
        linkView.tag = indexPath.row;
        linkView.userInteractionEnabled = true;
        [linkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPDFLink:)]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StarredPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStarredPersonCellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    NAZKPerson *pers = _persons[textView.tag];
    [_dataManager updateNote:textView.text forPerson:pers];
    
}


@end
