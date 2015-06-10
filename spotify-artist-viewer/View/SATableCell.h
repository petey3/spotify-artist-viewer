//
//  SATableCell.h
//  spotify-artist-viewer
//
//  Created by Eric Peterson on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SATableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIProgressView *popularity;
@end
