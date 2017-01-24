//
//  MovileModel.m
//  Flicks
//
//  Created by Kaeson Ho on 1/23/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel

- (instancetype)initWithDictionary:(NSDictionary *) dictionary
{
    self = [super init];
    if (self) {
        self.title = dictionary[@"original_title"];
        self.movieDescription = dictionary[@"overview"];
        NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", dictionary[@"poster_path"]];
        self.posterURL = [NSURL URLWithString: urlString];
    }
    return self;
}
@end
