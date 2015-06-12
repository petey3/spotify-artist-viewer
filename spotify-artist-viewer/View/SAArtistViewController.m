//
//  SAArtistViewController.m
//  spotify-artist-viewer
//
//  Created by Eric Peterson on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtistViewController.h"
#import "SARequestManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SAArtistViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *artistImageView;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioText;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;
@end

@implementation SAArtistViewController

#pragma mark - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.artist.name;
    
    void (^setBio)(SAArtist *) = ^(SAArtist *artist) {
        self.bioText.text = artist.bio;
    };
    
    void (^reportError)(NSError *) = ^(NSError *error){};
    
    //Update artists based on the search
    SARequestManager *reqManager = [SARequestManager sharedManager];
    [reqManager storeArtistBio:self.artist
                       success:setBio
                       failure:reportError];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setArtistImage:self.artist.pictureURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
