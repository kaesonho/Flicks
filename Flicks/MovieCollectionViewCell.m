//
//  MovieCollectionViewCell.m
//  Flicks
//
//  Created by Kaeson Ho on 1/26/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "MovieCollectionViewCell.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation MovieCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void) reloadData{
    [self.imageView setImageWithURL:self.model.posterURL];
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end
