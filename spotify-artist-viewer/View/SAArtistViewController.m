//
//  SAArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Eric Peterson on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SARequestManager.h"
#import "SAFavoritesManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SAArtistViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioText;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;
@property (strong, nonatomic) SAFavoritesManager *favManager;
@end

@implementation SAArtistViewController

#pragma mark - View Delegates
- (void)viewDidLoad {
    [super viewDidLoad];
    
    void (^setBio)(SAArtist *) = ^(SAArtist *artist) {
        self.bioText.text = artist.bio;
    };
    
    void (^reportError)(NSError *) = ^(NSError *error){};
    
    //Update artists based on the search
    SARequestManager *reqManager = [SARequestManager sharedManager];
    self.favManager = [SAFavoritesManager sharedManager];
    [reqManager populateArtistBio:self.artist
                       success:setBio
                       failure:reportError];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = self.artist.name;
    self.editButtonItem.title = [self.favManager isFavorited:self.artist] ? @"★" : @"☆";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationItem setRightBarButtonItem:self.editButtonItem];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setArtistImage:self.artist.pictureURL];
}

#pragma mark - Navigation Bar Delegates
- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    BOOL favorited = [self.favManager isFavorited:self.artist];
    if(favorited) {
        [self.favManager removeArtist:self.artist];
        self.editButtonItem.title = @"☆";
    } else {
        [self.favManager addArtist:self.artist];
        self.editButtonItem.title = @"★";
    }
}

#pragma mark - Utility
- (void)setArtistImage:(NSString *)picture {
    NSURL *imgURL = [NSURL URLWithString:picture];
    [self.artistImageView sd_setImageWithURL:imgURL];
    [self.blurImageView sd_setImageWithURL:imgURL];
    
    //Make the arist image a circle
    self.artistImageView.layer.cornerRadius = self.artistImageView.frame.size.width / 2;
    self.artistImageView.clipsToBounds = YES;
    
    //Give it a border
    self.artistImageView.layer.borderWidth = 3.0f;
    self.artistImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

@end
