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

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *movieDescription;
@property (nonatomic, strong) NSURL *posterURL;

@end
