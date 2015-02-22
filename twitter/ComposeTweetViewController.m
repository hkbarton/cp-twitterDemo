//
//  ComposeTweetViewController.m
//  twitter
//
//  Created by Ke Huang on 2/21/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeTweetViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConOfContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConOfContentView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelHandle;
@property (weak, nonatomic) IBOutlet UITextView *txtText;

@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (nonatomic, strong) UILabel *labelRestCount;
@property (nonatomic, strong) UIButton *buttonDone;
@property (nonatomic, strong) UIColor *normalButtonColor;
@property (nonatomic, strong) UIColor *holdButtonColor;
@property (nonatomic, strong) UIColor *disableButtonColor;

@property (nonatomic, strong) Tweet *oriTweet;

@end

@implementation ComposeTweetViewController

- (ComposeTweetViewController *)initWithTweet: (Tweet *) oriTweet {
    if (self = [super init]) {
        self.oriTweet = oriTweet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.normalButtonColor = [UIColor colorWithRed:84.0f/255.0f green:169.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    self.holdButtonColor = [UIColor colorWithRed:61.0f/255.0f green:124.0f/255.0f blue:173.0f/255.0f alpha:1.0f];
    self.disableButtonColor = [UIColor colorWithRed:142.0f/255.0f green:204.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    // setup navigation bar
    self.labelRestCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    self.labelRestCount.textAlignment = NSTextAlignmentRight;
    self.labelRestCount.font = [UIFont systemFontOfSize:12];
    self.labelRestCount.textColor = [UIColor grayColor];
    self.labelRestCount.text = @"140";
    
    self.buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [self.buttonDone setTitle:@"Tweet" forState:UIControlStateNormal];
    [self.buttonDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buttonDone.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    self.buttonDone.backgroundColor = self.normalButtonColor;
    self.buttonDone.layer.cornerRadius = 4.0f;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:
                                               [[UIBarButtonItem alloc] initWithCustomView:self.buttonDone],
                                               [[UIBarButtonItem alloc] initWithCustomView:self.labelRestCount],
                                               nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(onCloseButtonClicked:)];
    
    // setup view style
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    self.widthConOfContentView.constant = appFrame.size.width;
    self.heightConOfContentView.constant = appFrame.size.height - self.navigationController.navigationBar.frame.size.height;
    self.scrollView.alwaysBounceVertical = YES;
    self.imageProfile.layer.cornerRadius = 4.0f;
    self.imageProfile.clipsToBounds = YES;
    
    // hookup event
    [self.buttonDone addTarget:self action:@selector(onButtonDoneHold:) forControlEvents:UIControlEventTouchDown];
    [self.buttonDone addTarget:self action:@selector(onButtonDoneRelease:) forControlEvents:UIControlEventTouchUpInside];
    self.txtText.delegate = self;
    
    // setup data
    User *user = [User currentUser];
    [self.imageProfile setImageWithURL: [NSURL URLWithString:user.profileImageURL]];
    self.labelName.text = user.name;
    self.labelHandle.text = user.handle;
    if (self.oriTweet) {
        NSMutableString *initText = [[NSMutableString alloc] initWithString:self.oriTweet.user.handle];
        if (self.oriTweet.retweetStatus) {
            [initText appendString:@" "];
            [initText appendString:self.oriTweet.retweetStatus.user.handle];
        }
        [initText appendString:@" "];
        self.txtText.text = initText;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.txtText becomeFirstResponder];
}

- (void)onButtonDoneHold:(id)sender {
    self.buttonDone.backgroundColor = self.holdButtonColor;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger leftCount = 140 - textView.text.length;
    [self.buttonDone setEnabled:YES];
    self.buttonDone.backgroundColor = self.normalButtonColor;
    if (leftCount < 0) {
        self.labelRestCount.textColor = [UIColor redColor];
        [self.buttonDone setEnabled:NO];
        self.buttonDone.backgroundColor = self.disableButtonColor;
    } else if (leftCount < 20) {
        self.labelRestCount.textColor = [UIColor orangeColor];
    } else {
        self.labelRestCount.textColor = [UIColor grayColor];
    }
    self.labelRestCount.text = [NSString stringWithFormat:@"%ld", leftCount];
}

- (void)onButtonDoneRelease:(id)sender {
    self.buttonDone.backgroundColor = self.normalButtonColor;
    NSString *replyID = nil;
    if (self.oriTweet) {
        replyID = self.oriTweet.ID;
    }
    Tweet *newTweet = [Tweet createNewTweet:self.txtText.text withReply:replyID];
    if (self.delegate) {
        [self.delegate didTweet:newTweet];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onCloseButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
