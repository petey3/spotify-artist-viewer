//
//  SARequestManager.h
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAArtist.h"

@interface SARequestManager : NSObject

+ (instancetype)sharedManager;

- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure;

/*!
 @discussion Loads the artist bio only when we need it and stores it
 */
- (void)populateArtistBio:(SAArtist *)artist
             success:(void (^)(SAArtist *arist))success
             failure:(void (^)(NSError *error))failure;
@end
