//
//  ViewController.m
//  Flicks
//
//  Created by Kaeson Ho on 1/23/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "MovieModel.h"
#import "MovieDetail.h"
#import "MovieCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ViewController () <UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIRefreshControl *refreshControlC;
@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (strong, nonatomic) NSArray<MovieModel *> *movies;
@property (strong, nonatomic) NSArray<MovieModel *> *moviesSource;
@property (nonatomic, strong) UICollectionView *movieCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSwitcher;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *errorMessage;
@property BOOL isError;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // table view, initegrated with storyboard
    self.movieTableView.dataSource = self;
    self.movieTableView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.movieTableView insertSubview:self.refreshControl atIndex:0];
    [self.movieTableView setAllowsSelection:YES];
    
    // create a collection view
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout alloc];
    [layout setSectionInset:UIEdgeInsetsMake(64, 0, 50, 0)];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [collectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat itemHeight = 170;
    CGFloat itemWidth = screenWidth / 3;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection= UICollectionViewScrollDirectionVertical;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.refreshControlC = [[UIRefreshControl alloc] init];
    [self.refreshControlC addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    self.movieCollectionView = collectionView;
    [self.movieCollectionView addSubview:self.refreshControlC];
    
    // Search bar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    searchBar.delegate = self;
    
    [self fetchMovie:NO];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI {
    if (self.isError) {
        self.errorMessage.hidden = NO;
        self.movieTableView.hidden = YES;
        self.movieCollectionView.hidden = YES;
    } else {
        self.errorMessage.hidden = YES;
        [self switchView];
    }
}

# pragma mark TableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
    [self.movieTableView deselectRowAtIndexPath:indexPath animated:true];
}

- (NSInteger)tableView:(UITableView *)movieTableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

//configure cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellIdentifier = @"MovieTableViewCell";
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.title;
    cell.descLabel.text = model.movieDescription;
    [cell.posterImg setImageWithURL:model.posterURL];
    return cell;
}

# pragma mark segue for detail view

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath;
    MovieModel *model;
    if (self.viewSwitcher.selectedSegmentIndex == 0) {
        indexPath = [self.movieTableView indexPathForSelectedRow];
        model = [self.movies objectAtIndex:indexPath.row];
    } else {
        indexPath = [[self.movieCollectionView indexPathsForSelectedItems] objectAtIndex:0];
        model = [self.movies objectAtIndex:indexPath.item];
    }
    MovieDetail *movieDetail = [segue destinationViewController];
    [movieDetail setMovie:model];
}

# pragma mark data fetching

- (void) fetchMovie: (Boolean) endRefresh {
    NSString *apiKey = @"a07e22bc18f5cb106bfe4cc1f83ad8ed";
    NSString *urlString;
    if ([self.restorationIdentifier isEqual:@"nowPlaying"]) {
        urlString =
        [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
    } else {
        urlString =
        [@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:apiKey];
    }
    
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
                                                if (error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    // NSLog(@"Response: %@", responseDictionary);
                                                    NSArray *results = responseDictionary[@"results"];
                                                    
                                                    NSMutableArray *models = [NSMutableArray array];
                                                    for (NSDictionary *result in results) {
                                                        MovieModel *model = [[MovieModel alloc]initWithDictionary:result];
                                                        // NSLog(@"Model - %@", model);
                                                        [models addObject:model];
                                                    }
                                                    self.movies = models;
                                                    self.moviesSource = models;
                                                    [self.movieTableView reloadData];
                                                    [self.movieCollectionView reloadData];
                                                    if (endRefresh) {
                                                        [self.refreshControl endRefreshing];
                                                        [self.refreshControlC endRefreshing];
                                                    }
                                                    self.isError = NO;
                                                    [self updateUI];
                                                } else {
                                                    self.isError = YES;
                                                    NSLog(@"An error occurred: %@", error.description);
                                                    if (endRefresh) {
                                                        [self.refreshControl endRefreshing];
                                                        [self.refreshControlC endRefreshing];
                                                    }
                                                    [self updateUI];
                                                }
                                            }];
    [task resume];
}

- (void)onRefresh {
    [self fetchMovie:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (__kindof UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.item];
    cell.model = model;
    [cell reloadData];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"ToDetailView" sender: self];
}

# pragma mark - ViewSwitcher

- (void) switchView {
    if (self.viewSwitcher.selectedSegmentIndex == 0) {
        self.movieTableView.hidden = NO;
        self.movieCollectionView.hidden = YES;
    } else {
        self.movieTableView.hidden = YES;
        self.movieCollectionView.hidden = NO;
    }
}

- (IBAction)onViewChanged:(id)sender {
    [self updateUI];
}

# pragma mark UISearchBar

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock: ^BOOL(MovieModel *obj, NSDictionary *bind) {
        return [searchText length] == 0 || [obj.title containsString:searchText];
    }];

    self.movies = [self.moviesSource filteredArrayUsingPredicate:predicate];
    [self.movieTableView reloadData];
    [self.movieCollectionView reloadData];
}

@end
