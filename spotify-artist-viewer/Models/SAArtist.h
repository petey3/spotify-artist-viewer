//
//  SAArtist.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAArtist : NSObject
#pragma mark - Properties
@property (strong, nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSNumber* popularity;
@property (strong, nonatomic) NSString* picturePath;
@property (strong, nonatomic) NSString* bio;

#pragma mark - Instance Methods
- (instancetype) initWithName:(NSString*) name
                   popularity:(NSNumber*) popularity;
@end
