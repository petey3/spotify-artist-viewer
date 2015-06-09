//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"

@interface SARequestManager()
//@property (nonatomic, readwrite) BOOL isLive; //singleton class, only init when isLive is NO
@end

@implementation SARequestManager

//our singleton instance
static SARequestManager* sharedManager = nil;

- (instancetype) init
{
    self = [super init];
    return self;
}

+ (instancetype)sharedManager {
    if(!sharedManager) sharedManager = [[SARequestManager alloc] init];
    return sharedManager;
}

- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure {
    // TODO: make network calls to spotify API
}

@end
