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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    
    //Make the arist image uhm. Round? Round. Jk its a diamond or something lol.
    self.artistImageView.layer.cornerRadius = self.artistImageView.frame.size.width / 2;
    self.artistImageView.clipsToBounds = YES;
    
    //Give it a border
    self.artistImageView.layer.borderWidth = 3.0f;
    self.artistImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
