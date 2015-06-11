//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"
#import "SAArtist.h"

@interface SARequestManager()
@property (strong, nonatomic) NSURLSession* session;
@end

@implementation SARequestManager

//our singleton instance
static SARequestManager* sharedManager = nil;

#pragma mark - Initializers
- (instancetype) init
{
    self = [super init];
    return self;
}

- (NSURLSession*) session
{
    if(!_session)
    {
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return _session;
}

#pragma mark - Class Methods
+ (instancetype)sharedManager {
    if(!sharedManager) sharedManager = [[SARequestManager alloc] init];
    return sharedManager;
}


#pragma mark - Instance Methods
- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString* artistQuery = @"https://api.spotify.com/v1/search?q=%@&type=artist";
    
    //Set up the request
    NSString* target = [NSString stringWithFormat: artistQuery, query];
    NSURL* downloadURL = [NSURL URLWithString:target];
    NSURLRequest* request = [NSURLRequest requestWithURL:downloadURL];
    
    //Block for processing the JSON we get back for or artist query
    typedef void (^artistDataProcessor)(NSData* data, NSURLResponse* response, NSError* error);
    artistDataProcessor block = ^void(NSData* data, NSURLResponse* response, NSError* error)
    {
        NSLog(@"Grabbed Data!");
        
        //Convert data into JSON Object
        NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray* items = [[jsonDict objectForKey:@"artists"] objectForKey:@"items"];

        //Create SAArtists
        NSMutableArray* artists = [[NSMutableArray alloc] init];
        for(id item in items)
        {
            NSString* name = [item objectForKey:@"name"];
            NSNumber* pop = [item objectForKey:@"popularity"];
            //Also grab the 3rd image from the images key
            NSString* imgUrl = [self findBestImage:item];
            SAArtist* artist = [[SAArtist alloc] initWithName:name
                                                   popularity:pop
                                                       imgUrl:imgUrl];
            [artists addObject:artist];
        }
        
        //If successful, call success on the array of artists (which we trust does something good with them)
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error.code) success(artists);
            else failure(error);
        });
    };
    
    //Make the request and start the download
    NSURLSessionDataTask* dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:block];
    [dataTask resume];
}

#pragma mark - Utility
//Looks at the item from the dictionary and finds the best picture match
- (NSString *) findBestImage:(id)item {
    
    NSString* imgURL;
    NSArray* images = [item objectForKey:@"images"];
    
    if(images.count) {
        imgURL = [images[0] objectForKey:@"url"];
    }
    else {
        imgURL = @"";
    }
    
    return imgURL;
}

@end
