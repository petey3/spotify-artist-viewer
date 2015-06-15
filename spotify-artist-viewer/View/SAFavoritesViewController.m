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
@end

@implementation SAFavoritesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [self.tableView reloadData];
    [self.tableView setEditing:YES animated:YES]; //TODO: Remove for legit edit button
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Table sees %li artists", self.favManager.artists.count);
    return self.favManager.artists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    NSArray *artists = self.favManager.artists;
    
    SATableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SATableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.name.text = [artists[indexPath.row] name];
    NSNumber *artistPopularity = [artists[indexPath.row] popularity];
    [cell.popularity setProgress:(float)(artistPopularity.floatValue / 100.0f) animated:YES];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *artists = self.favManager.artists;
        SAArtist *artist = [artists objectAtIndex:indexPath.row];
        [self.favManager removeArtist:artist];
        
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
