//
//  SATableCell.m
//  spotify-artist-viewer
//
//  Created by Eric Peterson on 6/10/15.
//  Copyright (c) 2015 Intrepid. All rights reserved.
//

#import "SATableCell.h"

@implementation SATableCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor blackColor];
    [self setSelectedBackgroundView:bgColorView];
}

@end
