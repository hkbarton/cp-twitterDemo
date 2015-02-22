//
//  DetailTableViewCell.h
//  twitter
//
//  Created by Ke Huang on 2/21/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@protocol DetailTableViewCellDelegate <NSObject>

-(void)didClickReply: (Tweet*) tweet;
-(void)didClickRetweet: (Tweet*) tweet;
-(void)didClickFavorite: (Tweet*) tweet;

@end

@interface DetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelRetweetStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelHandle;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UILabel *labelCreatedAt;
@property (weak, nonatomic) IBOutlet UILabel *labelRetweetCount;
@property (weak, nonatomic) IBOutlet UILabel *labelFavCount;
@property (weak, nonatomic) IBOutlet UIButton *buttonReply;
@property (weak, nonatomic) IBOutlet UIButton *buttonRetweet;
@property (weak, nonatomic) IBOutlet UIButton *buttonFavorite;
@property (weak, nonatomic) IBOutlet UIImageView *imageTweet;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfImageTweet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceOfImageTweet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceOfRetweetStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfRetweetStatus;

@property (nonatomic, weak) id<DetailTableViewCellDelegate> delegate;


- (void)setTweet: (Tweet *)tweet;

@end
