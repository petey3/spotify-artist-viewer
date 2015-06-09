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
@property (strong, nonatomic, readonly) NSString* picturePath;
@property (strong, nonatomic, readonly) NSString* bio;

#pragma mark - Instance Methods
- (instancetype) initWithName:(NSString*) name
                  picturePath:(NSString*) picturePath
                          bio:(NSString*) bio;
@end
