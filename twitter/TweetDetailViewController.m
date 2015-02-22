//
//  TweetDetailViewController.m
//  twitter
//
//  Created by Ke Huang on 2/21/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "DetailTableViewCell.h"
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"

@interface TweetDetailViewController () <UITableViewDataSource, UITableViewDelegate, DetailTableViewCellDelegate, ComposeTweetViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) Tweet *tweetRef;

@end

@implementation TweetDetailViewController

- (id)initWithTweet: (Tweet *)tweet {
    if (self = [super init]) {
        self.tweetRef = tweet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tweet";
    // setup navigation bar
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // setup table view
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 350;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)didTweet: (Tweet *)newTweet {
    [[TwitterClient defaultClient] tweet:newTweet withCallback:^(Tweet *tweet, NSError *error) {}];
}

-(void)didClickReply: (Tweet*) tweet {
    ComposeTweetViewController *cc = [[ComposeTweetViewController alloc] initWithTweet: tweet];
    cc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:cc];
    nvc.navigationBar.barTintColor = [UIColor whiteColor];
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)didClickRetweet: (Tweet*) tweet {
    if (tweet.isRetweeted) {
        [[TwitterClient defaultClient] retweet:tweet withCallback:^(Tweet *tweet, NSError *error) {}];
    } else {
        [[TwitterClient defaultClient] deleteTweet:tweet.myRetweetStatus withCallback:^(Tweet *tweet, NSError *error) {
            tweet.myRetweetStatus = nil;
        }];
    }
}

-(void)didClickFavorite: (Tweet*) tweet {
    if (tweet.isFavorited) {
        [[TwitterClient defaultClient] favorite:tweet withCallback:^(Tweet *tweet, NSError *error) {}];
    } else {
        [[TwitterClient defaultClient] unFavorite:tweet withCallback:^(Tweet *tweet, NSError *error) {}];
    }
}

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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailTableViewCell"];
        [cell setTweet:self.tweetRef];
        cell.delegate = self;
        return cell;
    } else {
        return nil;
    }
}

@end
