//
//  SAArtist.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SAArtist.h"

@interface SAArtist()
#pragma mark - Properties
@property (strong, nonatomic, readwrite) NSString* name;
@property (nonatomic, readwrite) NSNumber* popularity;
@end

@implementation SAArtist

#pragma mark - Instance Methods
- (instancetype) initWithName:(NSString *)name
                   popularity:(NSNumber *)popularity
                       imgUrl:(NSString *)imgUrl;

{
    self = [super init];
    
    if(self)
    {
        self.name = name;
        self.popularity = popularity;
        self.pictureUrl = imgUrl;
    }
    
    return self;
}
@end
