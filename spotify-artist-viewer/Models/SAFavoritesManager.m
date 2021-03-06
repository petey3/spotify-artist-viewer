//
//  SAFavoritesManager.m
//  spotify-artist-viewer
//
//  Created by Eric Peterson on 6/12/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAFavoritesManager.h"

@interface SAFavoritesManager()
@property (strong, nonatomic) NSMutableArray *mutableArtists; //SAArtists
@property (strong, nonatomic, readwrite) NSArray *artists; //SAArtists
@end

@implementation SAFavoritesManager
static SAFavoritesManager *sharedManager = nil; //our singleton instance

#pragma mark - Initializers
- (instancetype) init {
    self = [super init];
    return self;
}


- (NSMutableArray *)mutableArtists {
    if(!_mutableArtists) {
        _mutableArtists = [[NSMutableArray alloc] init];
    }
    return _mutableArtists;
}

- (NSArray *)artists {
    if(!_artists) {
        _artists = [[NSArray alloc] init];
    }
    return _artists;
}


#pragma mark - Class Methods
+ (instancetype)sharedManager {
    if(!sharedManager) sharedManager = [[SAFavoritesManager alloc] init];
    return sharedManager;
}

#pragma mark - Instance Methods
- (void) addArtist:(SAArtist *)artist {
    //When checking for doubles, we need to look at URI's and not artist objects
    if(artist && ![self isFavorited:artist]) {
        [self.mutableArtists addObject:artist];
        self.artists = [self.mutableArtists copy];
    }
}

- (void) removeArtist:(SAArtist *)artist {
    if([self.mutableArtists containsObject:artist]) {
        [self.mutableArtists removeObject:artist];
        self.artists = [self.mutableArtists copy];
    }
}

- (BOOL) isFavorited:(SAArtist *)artist {
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF.spotifyURI = %@", artist.spotifyURI];
    NSArray *filteredArtists = [self.mutableArtists filteredArrayUsingPredicate:namePredicate];
    return filteredArtists.count > 0;
}

@end
