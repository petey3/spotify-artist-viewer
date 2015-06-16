//
//  SAArtist.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtist.h"

@interface SAArtist()

#pragma mark - Properties
@property (strong, nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSNumber *popularity;
@property (strong, nonatomic, readwrite) NSString *spotifyURI;
@end

@implementation SAArtist

#pragma mark - Instance Methods
- (instancetype) initWithName:(NSString *)name
                   popularity:(NSNumber *)popularity
                       imgURL:(NSString *)imgURL
                    spotifyURI:(NSString *)spuri {
    self = [super init];
    
    if(self) {
        self.name = name;
        self.popularity = popularity;
        self.pictureURL = imgURL;
        self.spotifyURI = spuri;
    }
    
    return self;
}
@end
