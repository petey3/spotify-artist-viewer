//
//  ViewController.m
//  spotify-artist-viewer
//
//  Created by Ying Quan Tan on 6/8/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testButton:(UIButton *)sender {
    //Testing hitting spotify
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    //Set up the request and start the data download
    __block NSData* myData;
    NSString* target = @"https://api.spotify.com/v1/search?q=tycho&type=artist";
    NSURL* downloadURL = [NSURL URLWithString:target];
    NSURLRequest* request = [NSURLRequest requestWithURL:downloadURL];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    myData = data;
                                                    NSLog(@"Grabbed Data!");
                                                    
                                                    //Convert data into JSON
                                                    NSError* jsonError;
                                                    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:myData options:0 error:&jsonError];
                                                    
                                                    //Printem out
                                                    for(NSString* key in [jsonDict allKeys])
                                                    {
                                                        NSLog(@"%@", [jsonDict objectForKey:key]);
                                                    }
                                                }];
    [dataTask resume];
}



@end
