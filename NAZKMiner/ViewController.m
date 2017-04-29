//
//  ViewController.m
//  NAZKMiner
//
//  Created by Andrew on 28.04.17.
//  Copyright © 2017 NodeAds. All rights reserved.
//

#import "ViewController.h"
#import "PersonSearchView.h"
#import "PersonTableViewCell.h"
#import "Person.h"
#import "NazkAPIManager.h"
#import "WebViewController.h"
#import "AppDelegate.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic) PersonSearchView *searchView;
@property (nonatomic) NSArray *persons;
@property (nonatomic) NazkAPIManager *manager;

@end

@implementation ViewController

static NSString * const kPersonCellIdentifier = @"PersonSearchViewCell";
static NSUInteger const kCellHeight = 80;


- (void) loadView {
    _searchView = [PersonSearchView new];
    self.view = _searchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchView.tableView.dataSource = self;
    _searchView.tableView.delegate = self;
    _searchView.searchBar.delegate = self;
    
    _searchView.tableView.bounces = YES;
    _searchView.tableView.showsVerticalScrollIndicator = YES;

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _searchView.searchBar.text = @"";
    
    
    //===========================CoreData===============================

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //NSLog(@"%@", [delegate.persistentContainer.managedObjectModel entitiesByName]);
    //============================Insert================================
//    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"NAZKPerson" inManagedObjectContext:delegate.persistentContainer.viewContext];
//
//    [person setValue:@"Andriy" forKey:@"firstname"];
//    [person setValue:@"1" forKey:@"identifier"];
//    [person setValue:@"Roshchin" forKey:@"lastname"];
//    [person setValue:@"TRK Ukraine" forKey:@"placeOfWork"];
//    [person setValue:@"specialist" forKey:@"position"];
//    [person setValue:@"" forKey:@"linkPDF"];
//    [person setValue:@"" forKey:@"notes"];
//
//    NSError* error = nil;
//    if (![delegate.persistentContainer.viewContext save:&error]) {
//        NSLog(@"%@", [error localizedDescription]);
//    }
    //============================Read==================================
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"NAZKPerson" inManagedObjectContext:delegate.persistentContainer.viewContext];
    
    [request setEntity: description];
    [request setResultType:NSDictionaryResultType];
    NSError* error = nil;
    NSArray *resultArray = [delegate.persistentContainer.viewContext executeFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        NSLog(@"%@", resultArray);
    }
    
    
    //==================================================================

    _manager = [NazkAPIManager sharedManager];
    
    [self.searchView.tableView registerClass: [PersonTableViewCell class]
                      forCellReuseIdentifier: kPersonCellIdentifier];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem* logoutButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Обрані" style:UIBarButtonItemStylePlain target:self action:@selector(watchStarredPersons)];
    [self.navigationItem setRightBarButtonItem:logoutButton];
    [self.navigationItem setHidesBackButton:NO];
    self.navigationItem.title = @"Пошук";
    
    //    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Actions

- (void)watchStarredPersons {
    
}

- (void)starClick: (UITapGestureRecognizer *)tapGesture {
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    Person *person = _persons[imageView.tag];
    
    imageView.image = [UIImage imageNamed:@"star"];

}

- (void)openPDFLink: (UITapGestureRecognizer *)tapGesture {
    UIImageView *image = (UIImageView *)tapGesture.view;
    Person *person = _persons[image.tag];
    if (person.linkPDF) {
        WebViewController *wvc = [[WebViewController alloc] initWithURL:[NSURL URLWithString:person.linkPDF]];
        
        [self.navigationController pushViewController:wvc
                                             animated:YES];
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
//    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [(PersonTableViewCell*)cell configureWithPerson:self.persons[indexPath.row]];

    Person *person = (Person*)_persons[indexPath.row];

    UIImageView *imageStarred = ((PersonTableViewCell*)cell).starred;
    imageStarred.image = [UIImage imageNamed:@"empty_star"];
    imageStarred.tag = indexPath.row;
    imageStarred.userInteractionEnabled = true;
    [imageStarred addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starClick:)]];
    
    if (person.linkPDF) {
        UIImageView *linkView = ((PersonTableViewCell *)cell).linkPDF;
        linkView.image = [UIImage imageNamed:@"book"];
        linkView.tag = indexPath.row;
        linkView.userInteractionEnabled = true;
        [linkView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPDFLink:)]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_searchView.searchBar resignFirstResponder];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPersonCellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchView.searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    
    _persons = @[];
    [_searchView.tableView reloadData];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    __weak typeof(self) weakSelf = self;
    
    [_manager fetchPersonsWithKeyword:searchBar.text completion:^(NSArray *users)
     {
         _persons = users;
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.searchView.tableView reloadData];
         });
     }];
    
    [searchBar resignFirstResponder];
}


@end
