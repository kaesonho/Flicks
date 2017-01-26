//
//  MovileModel.h
//  Flicks
//
//  Created by Kaeson Ho on 1/23/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *) otherDictionary;
- (void) updateDataByDictionary:(NSDictionary *) dictionary;
@property NSString *movieId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *movieDescription;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSString *vote;
@property (nonatomic, strong) NSString *duration;

@end
