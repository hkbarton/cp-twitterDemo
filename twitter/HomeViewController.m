//
//  HomeViewController.m
//  twitter
//
//  Created by Ke Huang on 2/17/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "HomeViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TwitterQueryParameter.h"
#import "SVProgressHUD.h"
#import "TweetTableViewCell.h"
#import "LoginViewController.h"
#import "ComposeTweetViewController.h"
#import "TweetDetailViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, TweetTableViewCellDelegate, ComposeTweetViewControllerDelegate, TweetDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIActivityIndicatorView *infiniteLoadingView;

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TwitterQueryParameter *queryParam;
@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HomeViewController

NSString *const TABLE_VIEW_CELL_ID = @"TweetTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    // navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Logout"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onLogoutClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"new_tweet"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweetClicked:)];

    // setup table
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:TABLE_VIEW_CELL_ID];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.tableRefreshControl atIndex:0];
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
    self.infiniteLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.infiniteLoadingView startAnimating];
    [self.tableFooterView addSubview:self.infiniteLoadingView];
    self.tableView.tableFooterView = self.tableFooterView;
    
    // init and load data
    self.tweets = [NSMutableArray array];
    self.queryParam = [TwitterQueryParameter defaultParameter];
    self.hasNextPage = NO;
    self.isLoading = NO;
    [self refreshView];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didBack {
    [self.tableView reloadData];
}

- (void)onLogoutClicked:(id)sender {
    [User logout];
    UIView *animBgView = [[UIView alloc] initWithFrame:self.view.frame];
    animBgView.backgroundColor = [UIColor colorWithRed:84.0f/255.0f green:169.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    animBgView.alpha = 0;
    UIImageView *animImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TwitterLogo_Big"]];
    animImgView.frame = CGRectMake(0, 0, 1500, 1500);
    animImgView.center = animBgView.center;
    animImgView.alpha = 0;
    [animBgView addSubview:animImgView];
    [self.view addSubview:animBgView];
    [UIView animateWithDuration:0.7f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animImgView.frame = CGRectMake(0, 0, 96, 96);
        animImgView.center = animBgView.center;
        animImgView.alpha = 1;
        animBgView.alpha = 1;
    } completion:^(BOOL finished) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        [[UIApplication sharedApplication] keyWindow].rootViewController = lvc;
    }];
}

- (void)onNewTweetClicked: (id)sender {
    ComposeTweetViewController *cc = [[ComposeTweetViewController alloc] initWithTweet: nil];
    cc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cc];
    nvc.navigationBar.barTintColor = [UIColor whiteColor];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)tweetTableViewCell:(TweetTableViewCell *) tweetTableViewCell didClickReply: (Tweet*) tweet {
    ComposeTweetViewController *cc = [[ComposeTweetViewController alloc] initWithTweet: tweet];
    cc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cc];
    nvc.navigationBar.barTintColor = [UIColor whiteColor];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)didTweet: (Tweet *)newTweet {
    [[TwitterClient defaultClient] tweet:newTweet withCallback:^(Tweet *tweet, NSError *error) {
        if (tweet) {
            [self.tweets insertObject:tweet atIndex:0];
            [self.tableView reloadData];
        }
    }];
}

-(void)tweetTableViewCell:(TweetTableViewCell *) tweetTableViewCell didClickRetweet: (Tweet*) tweet {
    if (tweet.isRetweeted) {
        [[TwitterClient defaultClient] retweet:tweet withCallback:^(Tweet *tweet, NSError *error) {}];
    } else {
        [[TwitterClient defaultClient] deleteTweet:tweet.myRetweetStatus withCallback:^(Tweet *tweet, NSError *error) {
            tweet.myRetweetStatus = nil;
        }];
    }
}

-(void)tweetTableViewCell:(TweetTableViewCell *) tweetTableViewCell didClickFavorite: (Tweet*) tweet {
    if (tweet.isFavorited) {
        [[TwitterClient defaultClient] favorite:tweet withCallback:^(Tweet *tweet, NSError *error) {}];
    } else {
        [[TwitterClient defaultClient] unFavorite:tweet withCallback:^(Tweet *tweet, NSError *error) {}];
    }
}

#pragma mark - Util

- (void)loadData {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    [[TwitterClient defaultClient] queryHomeTimeline:self.queryParam withCallback:^(NSArray *newTweets, NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableRefreshControl endRefreshing];
        if (error != nil) {
            self.isLoading = NO;
            return;
        }
        self.hasNextPage = newTweets.count >= self.queryParam.pageCount/2 ? YES : NO;
        if (!self.hasNextPage) {
            self.tableView.tableFooterView.hidden = YES;
        } else {
            self.tableView.tableFooterView.hidden = NO;
        }
        self.queryParam.maxID = ((Tweet*)newTweets[newTweets.count-1]).ID;
        [self.tweets addObjectsFromArray:newTweets];
        [self.tableView reloadData];
        self.isLoading = NO;
    }];
}

- (void)reloadData {
    [self.tweets removeAllObjects]; // TODO instead of remove, insert new tweet
    [self.queryParam reset];
    [self loadData];
}

- (void)refreshView {
    [SVProgressHUD show];
    self.tableView.tableFooterView.hidden = YES;
    [self reloadData];
}

#pragma mark - Table View

// fix separator inset bug
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_VIEW_CELL_ID];
    
    cell.delegate = self;
    [cell setTweet:self.tweets[indexPath.row]];
    
    if (indexPath.row >= self.tweets.count -1 && self.hasNextPage) {
        CGRect frame = self.tableFooterView.frame;
        frame.size.width = tableView.bounds.size.width;
        self.tableFooterView.frame = frame;
        CGPoint center = self.infiniteLoadingView.center;
        center.x = self.tableFooterView.center.x;
        self.infiniteLoadingView.center = center;
        // Because twitter API return so fast, in order to show the loading spiner, delay 1 sec here
        [self performSelector:@selector(loadData) withObject:nil afterDelay:1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Tweet *tweet = self.tweets[indexPath.row];
    TweetDetailViewController *tvc = [[TweetDetailViewController alloc] initWithTweet:tweet];
    tvc.delegate = self;
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
