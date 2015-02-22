//
//  TweetDetailViewController.h
//  twitter
//
//  Created by Ke Huang on 2/21/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@protocol TweetDetailViewControllerDelegate <NSObject>

@optional
-(void)didBack;

@end

@interface TweetDetailViewController : UIViewController

- (id)initWithTweet: (Tweet *)tweet;

@property (nonatomic, weak) id<TweetDetailViewControllerDelegate> delegate;

@end
