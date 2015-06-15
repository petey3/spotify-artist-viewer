//
//  ViewController.m
//  spotify-artist-viewer
//
//  Created by Ying Quan Tan on 6/8/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "ViewController.h"
#import "SAArtist.h"
#import "SARequestManager.h"
#import "SAFavoritesManager.h"
#import "SATableCell.h"
#import "SAArtistViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray *artists; //array of SAArtists
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) SARequestManager *reqManager;
@property (strong, nonatomic) SAFavoritesManager *favManager;
@property (strong, nonatomic) IBOutlet UITableView *resultsTable;
@end

@implementation ViewController

#pragma mark - Inititializers
- (SARequestManager*) reqManager {
    if(!_reqManager) _reqManager = [[SARequestManager alloc] init];
    return _reqManager;
}

- (SAFavoritesManager*) favManager {
    if(!_favManager) _favManager = [SAFavoritesManager sharedManager];
    return _favManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.resultsTable setBackgroundColor:[UIColor lightGrayColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTable:)];
    [self.view addGestureRecognizer:tap];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.navigationController.navigationBar.translucent = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = @"Spotify Artist Search";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBar Actions
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    void (^addArtists)(NSArray *) = ^(NSArray *artists) {
        self.artists = artists;
        [self.resultsTable reloadData];
    };
    
    //TODO:actually do something with error
    void (^reportError)(NSError*) = ^(NSError* error){};
    
    //Update artists based on the search
    [self.reqManager getArtistsWithQuery:searchText
                                 success:addArtists
                                 failure:reportError];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void) tapTable:(UIGestureRecognizer *)recognizer {
    CGPoint tapLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    
    if(indexPath) {
        recognizer.cancelsTouchesInView = NO;
    } else {
        [self.searchBar resignFirstResponder];
    }
}
     
#pragma mark - TableView Actions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    SATableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SATableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.name.text = [self.artists[indexPath.row] name];
    NSNumber *artistPopularity = [self.artists[indexPath.row] popularity];
    [cell.popularity setProgress:(float)(artistPopularity.floatValue / 100.0f) animated:YES];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    [self performSegueWithIdentifier:@"goToArtistDetail" sender:self.resultsTable];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"goToArtistDetail"]) {
        NSIndexPath *indexPath = [self.resultsTable indexPathForSelectedRow];
        SAArtist *artist = self.artists[indexPath.row];
        
        SAArtistViewController *detailVC = [segue destinationViewController];
        detailVC.artist = artist;
    }
}

@end
