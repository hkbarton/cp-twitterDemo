//
//  ComposeTweetViewController.h
//  twitter
//
//  Created by Ke Huang on 2/21/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"

@protocol ComposeTweetViewControllerDelegate <NSObject>

-(void)didTweet: (Tweet *)newTweet;

@end

@interface ComposeTweetViewController : UIViewController

@property (nonatomic, strong) id<ComposeTweetViewControllerDelegate> delegate;

- (ComposeTweetViewController *)initWithTweet: (Tweet *) oriTweet;

@end
