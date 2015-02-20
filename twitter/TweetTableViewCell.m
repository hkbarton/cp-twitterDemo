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

@end

@implementation TweetTableViewCell

NSInteger heightOfImgRetweetStatus, heightOfLabelRetweetStatus;

- (void)awakeFromNib {
    [self.buttonReply setImage:[UIImage imageNamed:@"reply_light"] forState:UIControlStateNormal];
    [self.buttonRetweet setImage:[UIImage imageNamed:@"retweet_light"] forState:UIControlStateNormal];
    [self.buttonRetweet setImage:[UIImage imageNamed:@"retweet_selected"] forState:UIControlStateSelected];
    [self.buttonFavorite setImage:[UIImage imageNamed:@"fav_light"] forState:UIControlStateNormal];
    [self.buttonFavorite setImage:[UIImage imageNamed:@"fav_selected"] forState:UIControlStateSelected];
    self.labelText.preferredMaxLayoutWidth = self.labelText.frame.size.width;
    self.imageProfile.layer.cornerRadius = 4.0f;
    self.imageProfile.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.labelText.preferredMaxLayoutWidth = self.labelText.frame.size.width;
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
    self.buttonRetweet.selected = NO;
    self.labelRetweetCount.hidden = YES;
    self.buttonFavorite.selected = NO;
    self.labelFavCount.hidden = YES;
    if (tweet.retweetStatus != nil) {
        CGRect frameImgRetweetStatus = self.imageRetweetStatus.frame;
        CGRect frameLabelRetweetStatus = self.labelRetweetStatus.frame;
        if (frameImgRetweetStatus.size.height == 0) {
            frameImgRetweetStatus.size.height = heightOfImgRetweetStatus;
            frameLabelRetweetStatus.size.height = heightOfLabelRetweetStatus;
            self.imageRetweetStatus.frame = frameImgRetweetStatus;
            self.labelRetweetStatus.frame = frameLabelRetweetStatus;
        }
        
        [self loadImage:self.imageProfile withURL:tweet.retweetStatus.user.profileImageURL];
        self.labelRetweetStatus.text = [NSString stringWithFormat:@"%@ retweeted", tweet.user.name];
        self.labelName.text = tweet.retweetStatus.user.name;
        self.labelHandle.text = tweet.retweetStatus.user.handle;
    } else {
        CGRect frameImgRetweetStatus = self.imageRetweetStatus.frame;
        CGRect frameLabelRetweetStatus = self.labelRetweetStatus.frame;
        heightOfImgRetweetStatus = frameImgRetweetStatus.size.height;
        heightOfLabelRetweetStatus = frameLabelRetweetStatus.size.height;
        frameImgRetweetStatus.size.height = 0;
        frameLabelRetweetStatus.size.height = 0;
        self.imageRetweetStatus.frame = frameImgRetweetStatus;
        self.labelRetweetStatus.frame = frameLabelRetweetStatus;
        
        [self loadImage:self.imageProfile withURL:tweet.user.profileImageURL];
        self.labelName.text = tweet.user.name;
        self.labelHandle.text = tweet.user.handle;
    }
    self.labelCreatedAt.text = tweet.createdAt.shortTimeAgoSinceNow;
    self.labelText.text= tweet.text;
    if (tweet.isRetweeted) {
        self.buttonRetweet.selected = YES;
    }
    if (tweet.retweetCount > 0) {
        self.labelRetweetCount.hidden = NO;
        self.labelRetweetCount.text = [NSString stringWithFormat:@"%ld", tweet.retweetCount];
    }
    if (tweet.isFavorited) {
        self.buttonFavorite.selected = YES;
    }
    if (tweet.favouritesCount > 0) {
        self.labelFavCount.hidden = NO;
        self.labelFavCount.text = [NSString stringWithFormat:@"%ld", tweet.favouritesCount];
    }
}

@end
