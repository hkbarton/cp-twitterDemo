//
//  TweetTableViewCell.h
//  twitter
//
//  Created by Ke Huang on 2/19/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageRetweetStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelRetweetStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelHandle;
@property (weak, nonatomic) IBOutlet UILabel *labelCreatedAt;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *buttonReply;
@property (weak, nonatomic) IBOutlet UIButton *buttonRetweet;
@property (weak, nonatomic) IBOutlet UILabel *labelRetweetCount;
@property (weak, nonatomic) IBOutlet UIButton *buttonFavorite;
@property (weak, nonatomic) IBOutlet UILabel *labelFavCount;

- (void)setTweet: (Tweet *)tweet;

@end
