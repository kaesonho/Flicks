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
    [self updateDataByDictionary:dictionary];
    return self;
}

- (void) updateDataByDictionary:(NSDictionary *) dictionary
{
    self.movieId = dictionary[@"id"];
    self.title = dictionary[@"original_title"];
    self.movieDescription = dictionary[@"overview"];
    NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342%@", dictionary[@"poster_path"]];
    self.posterURL = [NSURL URLWithString: urlString];
    NSNumber *runtime = dictionary[@"runtime"];
    if (runtime) {
        self.duration = [NSString stringWithFormat:@"%d hr %d mins", runtime.intValue/60, runtime.intValue%60];
    }
    NSNumber *vote = dictionary[@"vote_average"];
    self.vote = [NSString stringWithFormat:@"%0.2f", vote.doubleValue];
}

@end
