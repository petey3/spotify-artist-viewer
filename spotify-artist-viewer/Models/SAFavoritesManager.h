//
//  SAFavoritesManager.h
//  spotify-artist-viewer
//
//  Created by Eric Peterson on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAArtist.h"

@interface SAFavoritesManager : NSObject
@property (strong, nonatomic, readonly) NSArray *artists; //SAArtists

+ (instancetype) sharedManager;
- (void) addArtist:(SAArtist *)artist;
- (void) removeArtist:(SAArtist *)artist;

@end
