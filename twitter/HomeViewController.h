//
//  HomeViewController.h
//  twitter
//
//  Created by Ke Huang on 2/17/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@protocol HomeViewControllerDelegate

@optional

-(void)homeViewController:(HomeViewController *)homeViewController didMenuClicked:(BOOL)isMenuClicked;

@end

@interface HomeViewController : UIViewController

-(HomeViewController *)initWithType:(NSString *)type;
@property (nonatomic, weak) id<HomeViewControllerDelegate> delegate;

@end
