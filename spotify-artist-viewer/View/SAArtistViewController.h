//
//  SAArtistViewController.h
//  spotify-artist-viewer
//
//  Created by Eric Peterson on 6/11/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "ViewController.h"
#import "SAArtist.h"
@class SAArtist; //<- this was in the assignment...why?

@interface SAArtistViewController : UIViewController
@property (strong, nonatomic) SAArtist *artist;
@end
