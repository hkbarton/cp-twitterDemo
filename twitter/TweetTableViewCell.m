//
//  TweetTableViewCell.m
//  twitter
//
//  Created by Ke Huang on 2/19/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface TweetTableViewCell()

@property (nonatomic, weak) Tweet *tweetRef;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib {
    [self.buttonReply setImage:[UIImage imageNamed:@"reply_light"] forState:UIControlStateNormal];
    [self.buttonRetweet setImage:[UIImage imageNamed:@"retweet_light"] forState:UIControlStateNormal];
    [self.buttonRetweet setImage:[UIImage imageNamed:@"retweet_selected"] forState:UIControlStateSelected];
    [self.buttonFavorite setImage:[UIImage imageNamed:@"fav_light"] forState:UIControlStateNormal];
    [self.buttonFavorite setImage:[UIImage imageNamed:@"fav_selected"] forState:UIControlStateSelected];
    self.labelText.preferredMaxLayoutWidth = self.labelText.frame.size.width;
    self.imageProfile.layer.cornerRadius = 4.0f;
    self.imageProfile.clipsToBounds = YES;
    self.imageTweet.layer.cornerRadius = 4.0f;
    self.imageTweet.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.labelText.preferredMaxLayoutWidth = self.labelText.frame.size.width;
}

- (void)updateConstraints {
    [super updateConstraints];
    if (!self.tweetRef) {
        return;
    }
    if (self.tweetRef.retweetStatus != nil) {
        self.heightOfRetweetStatus.constant = 12;
        self.topSpaceOfRetweetStatus.constant = 8;
    } else {
        self.heightOfRetweetStatus.constant = 0;
        self.topSpaceOfRetweetStatus.constant = 0;
    }
    if (self.tweetRef.mainImageURL) {
        self.topSpaceOfImageTweet.constant = 8;
        self.heightOfImageTweet.constant = 150;
    } else {
        self.topSpaceOfImageTweet.constant = 0;
        self.heightOfImageTweet.constant = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadImage:(__weak UIImageView *)imageView withURL:(NSString *)url {
    NSURL *posterUrl = [NSURL URLWithString:url];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3.0f];
    [imageView setImageWithURLRequest:posterRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        imageView.image = image;
        // Only animate image fade in when result come from network
        if (response != nil) {
            imageView.alpha = 0;
            [UIView animateWithDuration:0.5f animations:^{
                imageView.alpha = 1.0f;
            }];
        }
    } failure:nil];
}

- (void)setTweet: (Tweet *)tweet {
    self.tweetRef = tweet;
    self.buttonRetweet.selected = NO;
    self.labelRetweetCount.hidden = YES;
    self.labelRetweetCount.textColor = [UIColor blackColor];
    self.buttonFavorite.selected = NO;
    self.labelFavCount.hidden = YES;
    self.labelFavCount.textColor = [UIColor blackColor];
    if (tweet.retweetStatus != nil) {
        [self loadImage:self.imageProfile withURL:tweet.retweetStatus.user.profileImageURL];
        self.labelRetweetStatus.text = [NSString stringWithFormat:@"%@ retweeted", tweet.user.name];
        self.labelName.text = tweet.retweetStatus.user.name;
        self.labelHandle.text = tweet.retweetStatus.user.handle;
    } else {
        self.labelRetweetStatus.text = @"";
        [self loadImage:self.imageProfile withURL:tweet.user.profileImageURL];
        self.labelName.text = tweet.user.name;
        self.labelHandle.text = tweet.user.handle;
    }
    self.labelCreatedAt.text = tweet.createdAt.shortTimeAgoSinceNow;
    self.labelText.text= tweet.text;
    if (tweet.mainImageURL) {
        [self loadImage:self.imageTweet withURL:tweet.mainImageURL];
    }
    UIColor *selectedColor = [UIColor colorWithRed:253.0f/255.0f green:160.0f/255.0f blue:65.0f/255.0f alpha:1.0f];
    if (tweet.isRetweeted) {
        self.buttonRetweet.selected = YES;
        self.labelRetweetCount.textColor = selectedColor;
    }
    if (tweet.retweetCount > 0) {
        self.labelRetweetCount.hidden = NO;
        self.labelRetweetCount.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
    }
    if (tweet.isFavorited) {
        self.buttonFavorite.selected = YES;
        self.labelFavCount.textColor = selectedColor;
    }
    if (tweet.favouritesCount > 0) {
        self.labelFavCount.hidden = NO;
        self.labelFavCount.text = [NSString stringWithFormat:@"%ld", tweet.favouritesCount];
    }
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}

- (IBAction)didClickReply:(id)sender {
    if (self.delegate) {
        [self.delegate tweetTableViewCell:self didClickReply:self.tweetRef];
    }
}

- (IBAction)didClickRetweet:(id)sender {
    if (self.tweetRef.isRetweeted) {
        self.tweetRef.isRetweeted = false;
        self.tweetRef.retweetCount -= 1;
    } else {
        self.tweetRef.isRetweeted = true;
        self.tweetRef.retweetCount += 1;
    }
    [self setTweet:self.tweetRef];
    if (self.delegate) {
        [self.delegate tweetTableViewCell:self didClickRetweet:self.tweetRef];
    }
}

- (IBAction)didClickFavorite:(id)sender {
    if (self.tweetRef.isFavorited) {
        self.tweetRef.isFavorited = false;
        self.tweetRef.favouritesCount -= 1;
    } else {
        self.tweetRef.isFavorited = true;
        self.tweetRef.favouritesCount += 1;
    }
    [self setTweet:self.tweetRef];
    if (self.delegate) {
        [self.delegate tweetTableViewCell:self didClickFavorite:self.tweetRef];
    }
}


@end
