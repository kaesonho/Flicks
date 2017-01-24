//
//  MovieCell.h
//  Flicks
//
//  Created by Kaeson Ho on 1/23/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end
