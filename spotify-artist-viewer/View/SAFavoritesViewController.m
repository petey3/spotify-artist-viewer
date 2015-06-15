//
//  SAFavoritesViewController.m
//  spotify-artist-viewer
//
//  Created by Eric Peterson on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAFavoritesViewController.h"
#import "SAFavoritesManager.h"
#import "SAArtistViewController.h"
#import "SATableCell.h"

@interface SAFavoritesViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) SAFavoritesManager *favManager;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSString *lastSearch;
@end

@implementation SAFavoritesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSearchResults:@""];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    /*
    //can't get the following code to work, working around an edit button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem setRightBarButtonItem:self.editButtonItem];
    if(![self.navigationItem rightBarButtonItem]) NSLog(@"Still Not Set Yet Chief");
     */
}

- (void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.topItem.title = @"Your Favorites";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem setRightBarButtonItem:self.editButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SAFavoritesManager *)favManager {
    if(!_favManager) _favManager = [SAFavoritesManager sharedManager];
    return _favManager;
}

#pragma mark - SearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateSearchResults:searchText];
    [self.tableView reloadData];
}

#pragma mark - Search Utility

- (void) updateSearchResults:(NSString *)searchText {
    self.lastSearch = searchText;
    if([searchText isEqual: @""]) {
        self.searchResults = self.favManager.artists;
    } else {
        NSString *predicateFormat = @"(SELF.name contains[c] %@)";
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:predicateFormat, searchText];
        self.searchResults = [self.favManager.artists filteredArrayUsingPredicate:namePredicate];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Table sees %li artists", self.searchResults.count);
    return self.searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    SATableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SATableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.name.text = [self.searchResults[indexPath.row] name];
    NSNumber *artistPopularity = [self.searchResults[indexPath.row] popularity];
    [cell.popularity setProgress:(float)(artistPopularity.floatValue / 100.0f) animated:YES];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *artists = self.searchResults;
        SAArtist *artist = [artists objectAtIndex:indexPath.row];
        [self.favManager removeArtist:artist];
        [self updateSearchResults:self.lastSearch];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"goToArtistDetail" sender:tableView];
}

#pragma mark - Navigation

 - (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([[segue identifier] isEqualToString:@"goToArtistDetail"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         SAArtist *artist = self.favManager.artists[indexPath.row];
         
         SAArtistViewController *detailVC = [segue destinationViewController];
         detailVC.artist = artist;
     }
}

@end
