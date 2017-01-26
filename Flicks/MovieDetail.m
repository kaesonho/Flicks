//
//  MovieDetail.m
//  Flicks
//
//  Created by Kaeson Ho on 1/24/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "MovieDetail.h"
#import "MovieModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MovieDetail ()

@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;



@end

@implementation MovieDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchMovie];
    
    CGFloat xMargin = 20;
    CGFloat cardHeight = 250; // arbitrary value
    CGFloat bottomPadding = 40;
    CGFloat cardOffset = cardHeight * 0.76;
    self.scrollView.frame = CGRectMake(xMargin, // x
                                       CGRectGetHeight(self.view.bounds) - cardHeight - bottomPadding, // y
                                       CGRectGetWidth(self.view.bounds) - 2 * xMargin, // width
                                       cardHeight); // height
    
    self.cardView.frame = CGRectMake(0, cardOffset, CGRectGetWidth(self.scrollView.bounds), cardHeight);
    
    // content height is the height of the card plus the offset we want
    CGFloat contentHeight =  cardHeight + cardOffset;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, contentHeight);
    
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self reloadDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadDetail {
    [self.moviePoster setImageWithURL: self.movie.posterURL];
    self.titleLabel.text = self.movie.title;
    self.descLabel.text = self.movie.movieDescription;
    self.voteLabel.text = self.movie.vote;
    self.durationLabel.text = self.movie.duration;
    [self.cardView sizeToFit];
}

- (void) fetchMovie {
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movie.movieId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];

                                                    [self.movie updateDataByDictionary:responseDictionary];
                                                    [self reloadDetail];

                                                    // [self.movieTableView reloadData];
                                                } else {
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];
    [task resume];
}

@end
