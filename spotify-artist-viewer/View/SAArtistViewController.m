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
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.artist.name;
    [self setArtistImage:self.artist.pictureURL];
    
    //Load and set the artist Bio
    void (^setBio)(SAArtist *) = ^(SAArtist *artist) {
        self.bioText.text = artist.bio;
    };
    
    //reportError: do something constructive if error
    void (^reportError)(NSError*) = ^(NSError* error){};
    
    //Update artists based on the search
    SARequestManager *reqManager = [SARequestManager sharedManager];
    [reqManager storeArtistBio:self.artist
                       success:setBio
                       failure:reportError];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setArtistImage:(NSString *)picture {
    NSURL *imgURL = [NSURL URLWithString:picture];
    [self.artistImageView sd_setImageWithURL:imgURL];
    [self.blurImageView sd_setImageWithURL:imgURL];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
