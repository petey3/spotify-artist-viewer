//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"
#import "SAArtist.h"

@interface SARequestManager()
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
    
    //Testing hitting spotify
    NSString* artistQuery = @"https://api.spotify.com/v1/search?q=%@&type=artist";
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    //Set up the request and start the data download
    __block NSData* myData;
    NSString* target = [NSString stringWithFormat: artistQuery, query];
    NSURL* downloadURL = [NSURL URLWithString:target];
    NSURLRequest* request = [NSURLRequest requestWithURL:downloadURL];
    
    //Block for handling the incoming data
    typedef void (^dataHandler)(NSData* data, NSURLResponse* response, NSError* error);
    dataHandler dataBlock = ^void(NSData* data, NSURLResponse* response, NSError* error)
    {
        //TODO: Actually use success and failure
        myData = data;
        NSLog(@"Grabbed Data!");
        
        //Convert data into JSON
        NSError* jsonError;
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:myData options:0 error:&jsonError];
        NSArray* items = [[jsonDict objectForKey:@"artists"] objectForKey:@"items"];

        //Create SAArtists
        for(id item in items)
        {
            NSString* name = [item objectForKey:@"name"];
            NSNumber* pop = [item objectForKey:@"popularity"];
            SAArtist* artist = [[SAArtist alloc] initWithName:name popularity:pop];
            NSLog(@"Found artist named %@ who is %@ popular", artist.name, artist.popularity);
        }
    };
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:dataBlock];
    [dataTask resume];
}

@end
