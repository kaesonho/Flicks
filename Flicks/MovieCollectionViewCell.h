//
//  MovieCollectionViewCell.h
//  Flicks
//
//  Created by Kaeson Ho on 1/26/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface MovieCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MovieModel *model;
- (void) reloadData;

@end
