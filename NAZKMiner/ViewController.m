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
#import "DataStoreManager.h"
#import "StarredViewController.h"
#import "NAZKPerson+CoreDataClass.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic) PersonSearchView *searchView;
@property (nonatomic) NSArray *persons;
@property (nonatomic) NSMutableArray *personsInStarred;
@property (nonatomic) NSMutableArray *cellHeights;
@property (nonatomic) NSSet *starredIDs;
@property (nonatomic) NazkAPIManager *manager;
@property (nonatomic) DataStoreManager *dataManager;
@property (nonatomic) UITableViewCell *progressCell;
@property (nonatomic) int nextPage;
@property (nonatomic) Boolean isLoading;

@end

@implementation ViewController

static NSString * const kPersonCellIdentifier = @"PersonSearchViewCell";

- (void) loadView {
    _searchView = [PersonSearchView new];
    self.view = _searchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchView.tableView.dataSource = self;
    _searchView.tableView.delegate = self;
    _searchView.searchBar.delegate = self;
    _searchView.searchBar.placeholder = @"Введіть параметри та запустіть пошук";
    
    _searchView.tableView.bounces = YES;
    _searchView.tableView.showsVerticalScrollIndicator = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _searchView.searchBar.text = @"";
    
    _dataManager = [DataStoreManager sharedManager];
    _starredIDs = [_dataManager getAllIDs];
    
    _manager = [NazkAPIManager sharedManager];
    
    [self.searchView.tableView registerClass: [PersonTableViewCell class]
                      forCellReuseIdentifier: kPersonCellIdentifier];
    
    _progressCell = [UITableViewCell new];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.color = [UIColor grayColor];
    UIView* rootView = _progressCell.contentView;
    indicator.center = rootView.center;
    [_progressCell.contentView addSubview:indicator];
    [indicator startAnimating];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Зачекайте, йде загрузка";
    label.font = [UIFont systemFontOfSize:12];
    [label sizeToFit];
    label.center = CGPointMake(rootView.center.x, rootView.center.y+20);
    [_progressCell.contentView addSubview:label];
    _isLoading = false;
    _nextPage = 0;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem* logoutButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Обрані" style:UIBarButtonItemStylePlain target:self action:@selector(watchStarredPersons)];
    [self.navigationItem setRightBarButtonItem:logoutButton];
    [self.navigationItem setHidesBackButton:NO];
    self.navigationItem.title = @"Пошук";
}

#pragma mark - Properties Logic

-(void)setPersons:(NSArray *)persons {
    _persons = persons;
    _cellHeights = [NSMutableArray new];
    _personsInStarred = [NSMutableArray new];
    for (int i = 0; i < persons.count; ++i) {
        Person *pers = persons[i];
        NSNumber *inStarred = [NSNumber numberWithBool:NO];
        if ([_starredIDs containsObject:pers.identifier]) {
            inStarred = [NSNumber numberWithBool:YES];
        }
        [_personsInStarred addObject:inStarred];
        [_cellHeights addObject:[NSNumber numberWithFloat:0.f]];
    }
}

#pragma mark - Actions

- (void)watchStarredPersons {
    StarredViewController *svc = [[StarredViewController alloc] init];
    
    [self.navigationController pushViewController:svc animated:YES];

}

- (void)starClick: (UITapGestureRecognizer *)tapGesture {
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    Person *person = _persons[imageView.tag];

    if ([_personsInStarred[imageView.tag] boolValue]) {
        [_dataManager removePersonWithID:person.identifier];
        _personsInStarred[imageView.tag] = [NSNumber numberWithBool:NO];
        imageView.image = [UIImage imageNamed:@"empty_star"];
    } else {
        UIAlertController *alertController = [UIAlertController
                    alertControllerWithTitle:@"Додати персону в обрані"
                                    message:@"Можете ввести свій коментар"
                            preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.placeholder = NSLocalizedString(@"Ваш коментар", @"Коментар");
         }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [_dataManager insertPerson:person withNote:alertController.textFields.firstObject.text];
                                       _personsInStarred[imageView.tag] = [NSNumber numberWithBool:YES];
                                       imageView.image = [UIImage imageNamed:@"star"];
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
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

- (void)loadPersonsWithKeyword:(NSString*)keyword {
    __weak typeof(self) weakSelf = self;
    
    [_manager fetchPersonsWithKeyword:keyword page:_nextPage completion:^(NSArray *users, int nextPage)
     {
         if (weakSelf.nextPage > 1) {
             weakSelf.persons = [weakSelf.persons arrayByAddingObjectsFromArray:users];
         } else {
             weakSelf.persons = users;
         }
         weakSelf.isLoading = true;
         weakSelf.nextPage = nextPage;
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.searchView.tableView reloadData];
             weakSelf.isLoading = false;
         });
         NSLog(@"%d", nextPage);
         
     }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _persons.count) {
        return 60;
    }
    if ([[_cellHeights objectAtIndex:indexPath.row] floatValue] < 1.f) {
        [_cellHeights insertObject:[NSNumber numberWithFloat:[PersonTableViewCell calculateCellHeightWithPerson:_persons[indexPath.row]]] atIndex:indexPath.row];
    }
    return [_cellHeights[indexPath.row] floatValue];
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _persons.count) {
        if (!_isLoading) {
            [self loadPersonsWithKeyword:_searchView.searchBar.text];
        }
        return;
    }
    [(PersonTableViewCell*)cell configureWithPerson:_persons[indexPath.row]];

    Person *person = (Person*)_persons[indexPath.row];


    UIImageView *imageStarred = ((PersonTableViewCell*)cell).starred;
    if ([_personsInStarred[indexPath.row] boolValue]) {
        imageStarred.image = [UIImage imageNamed:@"star"];
    } else {
        imageStarred.image = [UIImage imageNamed:@"empty_star"];
    }
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
    if (_nextPage == -1 || _persons.count == 0) {
        return _persons.count;
    }
    return _persons.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _persons.count) {
        return _progressCell;
    }
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
    _nextPage = 0;
    _persons = @[];
    [_searchView.tableView reloadData];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _nextPage = 0;
    [self loadPersonsWithKeyword:searchBar.text];
    [searchBar resignFirstResponder];
}


@end
