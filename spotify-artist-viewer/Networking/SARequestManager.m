//
//  SARequestManager.m
//  spotify-artist-viewer
//
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SARequestManager.h"

@interface SARequestManager()
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation SARequestManager

#pragma mark - Initializers
- (instancetype) init {
    self = [super init];
    return self;
}

- (NSURLSession *)session {
    if(!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return _session;
}

#pragma mark - Class Methods
+ (instancetype)sharedManager {
    static SARequestManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SARequestManager alloc] init];
    });
    
    return sharedManager;
}


#pragma mark - Instance Methods
- (void)getArtistsWithQuery:(NSString *)query
                    success:(void (^)(NSArray *artists))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString *artistQuery = @"https://api.spotify.com/v1/search?q=%@&type=artist";

    NSString *target = [NSString stringWithFormat: artistQuery, query];
    NSURL *downloadURL = [NSURL URLWithString:target];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    
    typedef void (^artistDataProcessor)(NSData *data, NSURLResponse *response, NSError *error);
    artistDataProcessor block = ^void(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *items = [[jsonDict objectForKey:@"artists"] objectForKey:@"items"];

        NSMutableArray *artists = [[NSMutableArray alloc] init];
        for(id item in items)
        {
            NSString *name = [item objectForKey:@"name"];
            NSNumber *pop = [item objectForKey:@"popularity"];
            NSString *imgURL = [self findBestImage:item];
            NSString *spotifyURI = [item objectForKey:@"uri"];
            //We make a call for bio only when the page is details are loaded
            SAArtist *artist = [[SAArtist alloc] initWithName:name
                                                   popularity:pop
                                                       imgURL:imgURL
                                                    spotifyURI:spotifyURI];
            [artists addObject:artist];
        }
        
        //Because artists are being poked by the UI thread (main thread)
        //we need to make sure the success block is called in the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error.code) {
                success(artists);
            } else {
                failure(error);
            }
        });
    };

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:block];
    [dataTask resume];
}

- (void)storeArtistBio:(SAArtist *)artist
               success:(void (^)(SAArtist *))success
               failure:(void (^)(NSError *))failure {
    
    NSString *echoKey = @"ODTPTVQHT41YLW9NF";
    NSString *endPointFormat = @"http://developer.echonest.com/api/v4/artist/biographies?api_key=%@&id=%@";
    NSString *query = [NSString stringWithFormat:endPointFormat, echoKey, artist.spotifyURI];
    
    //If the bio is already stored, skip all of this and call success
    if(artist.bio) {
        success(artist);
        return;
    }
    
    NSURL *downloadURL = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];
    
    typedef void (^bioDataProcessor)(NSData *data, NSURLResponse *response, NSError *error);
    bioDataProcessor block = ^void(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *bios = [[jsonDict objectForKey:@"response"] objectForKey:@"biographies"];
        
        NSString *bioText;
        for(id bio in bios)
        {
            //if its truncated it has the key, if its not it doesnt
            //(as opposed to truncated = false)
            if(![bio objectForKey:@"truncated"]) {
                bioText = [bio objectForKey:@"text"];
                break; //grab the first non-truncated one
            }
        }
        if(!bioText) bioText = @"No Bio To Find. They Are A Ghost";
        artist.bio = bioText;
        
        //Because artists are being poked by the UI thread (main thread)
        //we need to make sure the success block is called in the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error.code) {
                success(artist);
            } else {
                failure(error);
            }
        });
    };
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:block];
    [dataTask resume];
    
}

#pragma mark - Utility
- (NSString *)findBestImage:(id)item {
    
    NSString *imgURL;
    NSArray *images = [item objectForKey:@"images"];
    
    if(images.count) {
        imgURL = [images[0] objectForKey:@"url"];
    }
    else {
        imgURL = @"";
    }
    
    return imgURL;
}

@end
