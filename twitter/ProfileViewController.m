//
//  ProfileViewController.m
//  twitter
//
//  Created by Ke Huang on 2/28/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "TweetTableViewCell.h"
#import "TweetDetailViewController.h"
#import "NavigationTitleView.h"
#import "ALDBlurImageProcessor.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageBg;
@property (nonatomic, strong) UIImage *oriBGImage;
@property (nonatomic, strong) ALDBlurImageProcessor *blurImageProcessor;
@property (weak, nonatomic) IBOutlet UIView *detialContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelHandle;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelFollowingCount;
@property (weak, nonatomic) IBOutlet UILabel *labelFollowerCount;
@property (weak, nonatomic) IBOutlet UIView *splitView;
@property (weak, nonatomic) IBOutlet UIButton *btnEditProfile;
@property (nonatomic, strong) NavigationTitleView *navTitleView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIActivityIndicatorView *infiniteLoadingView;

@property (nonatomic, strong) TwitterQueryParameter *queryParam;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic, assign) BOOL isLoading;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat topLimitHeight;
@property (nonatomic, assign) CGFloat topLimitOfNavTitle;
@property (nonatomic, assign) CGFloat yPosOfDetialNamelLabel;
@property (nonatomic, assign) CGRect nativeImageBGFrame;
@property (nonatomic, assign) CGRect nativeImageProfileFrame;
@property (nonatomic, assign) CGRect nativeDetailContainerFrame;
@property (nonatomic, assign) CGRect nativeTableViewFrame;
@property (nonatomic, assign) CGRect oriImageBGFrame;
@property (nonatomic, assign) CGRect oriImageProfileFrame;
@property (nonatomic, assign) CGRect oriDetailContainerFrame;
@property (nonatomic, assign) CGRect oriTableViewFrame;
@property (nonatomic, assign) CGFloat transWhenScrollTable;
@property (nonatomic, assign) CGFloat transWhenNotScrollTable;

- (IBAction)panGestureHandler:(UIPanGestureRecognizer *)sender;

@end

@implementation ProfileViewController

-(ProfileViewController *)initWithUser:(User *) user {
    if (self = [super init]) {
        self.user = user;
    }
    return self;
}

- (void)loadTableData {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    void (^callback)(NSArray *tweets, NSError *error) = ^(NSArray *newTweets, NSError *error) {
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
    };
    [[TwitterClient defaultClient] getUserTimeline:self.user withParameter:self.queryParam withCallback:callback];
}

- (void)loadData {
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.user.profileBGImageURL] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3.0f];
    [self.imageBg setImageWithURLRequest:posterRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.blurImageProcessor = [[ALDBlurImageProcessor alloc] initWithImage:image];
        self.imageBg.image = image;
        self.oriBGImage = image;
    } failure:nil];
    [self.imageProfile setImageWithURL:[NSURL URLWithString:self.user.profileImageURL]];
    self.labelName.text = self.user.name;
    self.labelHandle.text = self.user.handle;
    self.labelDescription.text = self.user.des;
    self.labelLocation.text = self.user.location;
    self.labelFollowingCount.text = [NSString stringWithFormat:@"%ld", self.user.followingCount];
    self.labelFollowerCount.text = [NSString stringWithFormat:@"%ld", self.user.followerCount];
    [self.navTitleView setUser:self.user];
    // load table data
    self.tableView.tableFooterView.hidden = YES;
    [self.tweets removeAllObjects];
    [self.queryParam reset];
    [self loadTableData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.panGesture.delegate = self;
    // navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onMenuClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"new_tweet"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweetClicked)];
    // view setup
    self.imageProfile.layer.cornerRadius = 4.0f;
    self.imageProfile.clipsToBounds = YES;
    self.imageProfile.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.imageProfile.layer setBorderWidth:2.0f];
    self.navTitleView = [[[NSBundle mainBundle] loadNibNamed:@"NavigationTitleView" owner:self options:nil] objectAtIndex:0];
    
    // table view setup
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"TweetTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
    self.infiniteLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.infiniteLoadingView startAnimating];
    [self.tableFooterView addSubview:self.infiniteLoadingView];
    self.tableView.tableFooterView = self.tableFooterView;
    // load data
    self.tweets = [NSMutableArray array];
    self.queryParam = [TwitterQueryParameter defaultParameter];
    self.hasNextPage = NO;
    self.isLoading = NO;
    [self loadData];
}

- (void)layoutDetailContainer:(CGRect) appFrame{
}

- (void)viewDidAppear:(BOOL)animated {
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.nativeImageBGFrame = CGRectMake(0, 0, appFrame.size.width, 115);
    self.imageBg.frame = self.nativeImageBGFrame;
    self.topLimitOfNavTitle = self.nativeImageBGFrame.size.height - navigationBarHeight + 5;
    self.navTitleView.frame = CGRectMake(0, self.nativeImageBGFrame.size.height, appFrame.size.width, navigationBarHeight);
    [self.imageBg addSubview:self.navTitleView];
    self.nativeDetailContainerFrame = CGRectMake(0, 115, appFrame.size.width, 165);
    self.detialContainer.frame = self.nativeDetailContainerFrame;
    [self layoutDetailContainer:appFrame];
    self.yPosOfDetialNamelLabel = self.labelName.frame.origin.y + 17;
    self.nativeImageProfileFrame = self.imageProfile.frame;
    self.nativeTableViewFrame = CGRectMake(0, 280, appFrame.size.width, appFrame.size.height - navigationBarHeight);
    self.tableView.frame = self.nativeTableViewFrame;
    self.topLimitHeight = navigationBarHeight + statusBarHeight;
}

- (void)onMenuClicked {
    if (self.delegate) {
        [self.delegate profileViewController:self didMenuClicked:YES];
    }
}

- (void)onNewTweetClicked {
}

#pragma mark Scroll Animation

- (void)saveFrame{
    self.oriImageBGFrame = self.imageBg.frame;
    self.oriImageProfileFrame = self.imageProfile.frame;
    self.oriDetailContainerFrame = self.detialContainer.frame;
    self.oriTableViewFrame = self.tableView.frame;
    self.transWhenScrollTable = 0;
    self.transWhenNotScrollTable = 0;
}

- (CGRect)translateTableView:(CGPoint) tranlation {
    if (self.tableView.frame.origin.y <= self.topLimitHeight && self.tableView.contentOffset.y > 0) {
        self.transWhenScrollTable = tranlation.y - self.transWhenNotScrollTable;
        CGRect fixResult = self.nativeTableViewFrame;
        fixResult.origin.y = self.topLimitHeight;
        return fixResult;
    }
    self.transWhenNotScrollTable = tranlation.y;
    CGRect result = self.oriTableViewFrame;
    result.origin.y = self.oriTableViewFrame.origin.y + tranlation.y - self.transWhenScrollTable;
    if (result.origin.y <= self.topLimitHeight) {
        result.origin.y = self.topLimitHeight;
    } else {
        CGPoint tableContentOffset = self.tableView.contentOffset;
        tableContentOffset.y = 0;
        self.tableView.contentOffset = tableContentOffset;
    }
    return result;
}

- (CGRect)translateDetialContiner:(CGFloat)absChange {
    CGRect result = self.nativeDetailContainerFrame;
    result.origin.y = self.nativeDetailContainerFrame.origin.y + absChange;
    return result;
}

- (void)blurImageBGView {
    //[self.imageBg setImageToBlur:self.oriBGImage blurRadius:10 completionBlock:nil];
}

- (CGRect)translateBGImage:(CGFloat)absChange {
    CGRect result = self.nativeImageBGFrame;
    CGRect navTitleFrame = self.navTitleView.frame;
    if (absChange > 0) {
        result.size.height = self.nativeImageBGFrame.size.height + absChange;
        navTitleFrame.origin.y = result.size.height;
        self.imageBg.image = self.oriBGImage;
    } else {
        navTitleFrame.origin.y = result.size.height;
        result.origin.y = self.nativeImageBGFrame.origin.y + absChange;
        if (result.origin.y + self.nativeImageBGFrame.size.height < self.topLimitHeight) {
            result.origin.y = self.topLimitHeight - self.nativeImageBGFrame.size.height;
            if (self.imageBg.layer.zPosition < 1) {
                self.imageBg.layer.zPosition = 1;
            }
            CGFloat absPosOfNomalNameLabel = self.nativeDetailContainerFrame.origin.y + self.yPosOfDetialNamelLabel + absChange;
            if (absPosOfNomalNameLabel < self.topLimitOfNavTitle) {
                navTitleFrame.origin.y = self.nativeImageBGFrame.size.height - (self.topLimitOfNavTitle - absPosOfNomalNameLabel) - 3;
                if (navTitleFrame.origin.y < self.topLimitOfNavTitle) {
                    navTitleFrame.origin.y = self.topLimitOfNavTitle;
                }
            }
            CGFloat blurRadius = ((result.size.height - navTitleFrame.origin.y) / (result.size.height - self.topLimitOfNavTitle)) * 9;
            [self.blurImageProcessor asyncBlurWithRadius:blurRadius iterations:7 successBlock:^(UIImage *blurredImage) {
                self.imageBg.image = blurredImage;
            } errorBlock:nil];
        } else {
            if (self.imageBg.layer.zPosition == 1) {
                self.imageBg.layer.zPosition = 0;
            }
            self.imageBg.image = self.oriBGImage;
        }
    }
    self.navTitleView.frame = navTitleFrame;
    return result;
}

- (CGRect)translateProfileImage:(CGFloat)absChange{
    CGRect result = self.nativeImageProfileFrame;
    if (absChange < 0) {
        CGFloat changeFactor = self.nativeImageProfileFrame.origin.y * 2;
        if (self.detialContainer.frame.origin.y > self.topLimitHeight) {
            changeFactor = changeFactor * (absChange / (self.topLimitHeight - self.nativeImageBGFrame.size.height));
        }
        result.size.width = self.nativeImageProfileFrame.size.width + changeFactor/2;
        result.size.height = self.nativeImageProfileFrame.size.height + changeFactor/2;
        result.origin.x = self.nativeImageProfileFrame.origin.x - changeFactor/4;
        result.origin.y = self.nativeImageProfileFrame.origin.y - changeFactor/2;
    }
    return result;
}

- (IBAction)panGestureHandler:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self saveFrame];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.tableView.frame = [self translateTableView:translation];
        CGFloat absChange = self.tableView.frame.origin.y - self.nativeTableViewFrame.origin.y;
        self.detialContainer.frame = [self translateDetialContiner:absChange];
        self.imageBg.frame = [self translateBGImage:absChange];
        self.imageProfile.frame = [self translateProfileImage:absChange];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.detialContainer.frame.origin.y > self.nativeDetailContainerFrame.origin.y) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.detialContainer.frame = self.nativeDetailContainerFrame;
                self.tableView.frame = self.nativeTableViewFrame;
                self.imageBg.frame = self.nativeImageBGFrame;
                self.imageProfile.frame = self.nativeImageProfileFrame;
            } completion:nil];
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (otherGestureRecognizer.view == self.tableView) {
        return YES;
    }
    return NO;
}

#pragma mark tableView

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
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    
    //cell.delegate = self;
    [cell setTweet:self.tweets[indexPath.row]];
    
    if (indexPath.row >= self.tweets.count -1 && self.hasNextPage) {
        CGRect frame = self.tableFooterView.frame;
        frame.size.width = tableView.bounds.size.width;
        self.tableFooterView.frame = frame;
        CGPoint center = self.infiniteLoadingView.center;
        center.x = self.tableFooterView.center.x;
        self.infiniteLoadingView.center = center;
        // Because twitter API return so fast, in order to show the loading spiner, delay 1 sec here
        [self performSelector:@selector(loadTableData) withObject:nil afterDelay:1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Tweet *tweet = self.tweets[indexPath.row];
    TweetDetailViewController *tvc = [[TweetDetailViewController alloc] initWithTweet:tweet];
    //tvc.delegate = self;
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
