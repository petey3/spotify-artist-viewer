//
//  SATableCellTableViewCell.h
//  spotify-artist-viewer
//
//  Created by Eric Peterson on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SATableCellTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UIProgressView *popularity;
@end
