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
@property (strong, nonatomic, readwrite) NSString* picturePath;
@property (strong, nonatomic, readwrite) NSString* bio;
@end

@implementation SAArtist

#pragma mark - Instance Methods
- (instancetype) initWithName:(NSString *)name
                  picturePath:(NSString *)picturePath
                          bio:(NSString *)bio {
    self = [super init];
    
    if(self)
    {
        self.name = name;
        self.picturePath = picturePath;
        self.bio = bio;
    }
    
    return self;
}
@end
