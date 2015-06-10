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

@interface ViewController ()
@property (strong, nonatomic) NSArray* artists; //array of SAArtists
@property (strong, nonatomic) SARequestManager* reqManager;
@end

@implementation ViewController

#pragma mark - Inititializers
- (SARequestManager*) reqManager {
    if(!_reqManager) _reqManager = [[SARequestManager alloc] init];
    return _reqManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActions
- (IBAction)testButton:(UIButton *)sender {
    NSString* testQuery = @"tycho";
    
    //addArtists: stores the arists passed in
    void (^addArtists)(NSArray*) = ^(NSArray* artists)
    {
        self.artists = artists;
        
        for(SAArtist* artist in self.artists)
        {
            NSLog(@"Added artist named %@ who is %@ popular", artist.name, artist.popularity);
        }
    };
    
    //reportError: do something constructive if error
    void (^reportError)(NSError*) = ^(NSError* error){};
    
    [self.reqManager getArtistsWithQuery:testQuery
                                 success:addArtists
                                 failure:reportError];
}



@end
