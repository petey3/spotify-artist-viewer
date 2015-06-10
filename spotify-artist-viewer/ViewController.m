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
#import "SATableCell.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray *artists; //array of SAArtists
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) SARequestManager *reqManager;
@property (weak, nonatomic) IBOutlet UITableView *resultsTable;
@end

@implementation ViewController

#pragma mark - Inititializers
- (SARequestManager*) reqManager {
    if(!_reqManager) _reqManager = [[SARequestManager alloc] init];
    return _reqManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.resultsTable setBackgroundColor:[UIColor lightGrayColor]];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View did load");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SearchBar Actions
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Search Bar Updated");
    
    //addArtists: stores the arists passed in
    void (^addArtists)(NSArray*) = ^(NSArray* artists) {
        self.artists = artists;
        [self.resultsTable reloadData];
    };
    
    //reportError: do something constructive if error
    void (^reportError)(NSError*) = ^(NSError* error){};
    
    //Update artists based on the search
    [self.reqManager getArtistsWithQuery:searchText
                                 success:addArtists
                                 failure:reportError];
}
     
#pragma mark - TableView Actions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artists.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    SATableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        //cell = [[SATableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //TODO: probably a better way to do this
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SATableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.name.text = [self.artists[indexPath.row] name];
    float pop = (float)([self.artists[indexPath.row] popularity].floatValue / 100.0f);
    cell.popularity.progress = pop;
    return cell;
}

@end
