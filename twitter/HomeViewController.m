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

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIActivityIndicatorView *infiniteLoadingView;

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) TwitterQueryParameter *queryParam;
@property (nonatomic, assign) BOOL hasNextPage;

@end

@implementation HomeViewController

NSString *const TABLE_VIEW_CELL_ID = @"TweetTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    
    // setup table
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:TABLE_VIEW_CELL_ID];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 112;
    
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
    [self refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Util

- (void)loadData {
    [[TwitterClient defaultClient] queryHomeTimeline:self.queryParam withCallback:^(NSArray *tweets, NSError *error) {
        [SVProgressHUD dismiss];
        [self.tableRefreshControl endRefreshing];
        if (error != nil) {
            return;
        }
        self.hasNextPage = tweets.count == self.queryParam.pageCount ? YES : NO;
        if (!self.hasNextPage) {
            self.tableView.tableFooterView.hidden = YES;
        } else {
            self.tableView.tableFooterView.hidden = NO;
        }
        self.queryParam.maxID = ((Tweet*)tweets[tweets.count-1]).ID;
        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
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
    
    [cell setTweet:self.tweets[indexPath.row]];
    
    if (indexPath.row >= self.tweets.count -1 && self.hasNextPage) {
        CGRect frame = self.tableFooterView.frame;
        frame.size.width = tableView.bounds.size.width;
        self.tableFooterView.frame = frame;
        CGPoint center = self.infiniteLoadingView.center;
        center.x = self.tableFooterView.center.x;
        self.infiniteLoadingView.center = center;
        [self loadData];
    }
    
    return cell;
}

@end
