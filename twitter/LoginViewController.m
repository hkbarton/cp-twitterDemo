//
//  LoginViewController.m
//  twitter
//
//  Created by Ke Huang on 2/16/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import  "HomeViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    if ([User currentUser] != nil) {
        [self translateToHomeView];
    } else {
        self.btnLogin.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)translateToHomeView {
    self.btnLogin.hidden = YES;
    [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.imgLogo.frame = CGRectMake(0, 0, self.imgLogo.frame.size.width * 0.8, self.imgLogo.frame.size.height * 0.8);
        self.imgLogo.center = self.view.center;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.imgLogo.frame = CGRectMake(0, 0, self.imgLogo.frame.size.width * 17, self.imgLogo.frame.size.height * 17);
            self.imgLogo.center = self.view.center;
        } completion:^(BOOL finished) {
            MainViewController *mvc = [[MainViewController alloc] init];
            [[UIApplication sharedApplication] keyWindow].rootViewController = mvc;
        }];
    }];
}

- (IBAction)btnLoginClicked:(id)sender {
    [[TwitterClient defaultClient] login:^(User *user, NSError *error) {
        if (user!=nil) {
            [self translateToHomeView];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
