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

@interface TweetDetailViewController : UIViewController

- (id)initWithTweet: (Tweet *)tweet;

@end
