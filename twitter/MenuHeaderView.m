//
//  MenuHeaderView.m
//  twitter
//
//  Created by Ke Huang on 2/28/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "MenuHeaderView.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface MenuHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@end

@implementation MenuHeaderView

- (void)awakeFromNib {
    self.imageProfile.layer.cornerRadius = 4.0f;
    self.imageProfile.clipsToBounds = YES;
    self.imageProfile.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.imageProfile.layer setBorderWidth:2.0f];
    User *user = [User currentUser];
    [self.imageProfile setImageWithURL:[NSURL URLWithString:user.profileImageURL]];
    self.labelName.text = user.name;
    self.labelStatus.text = user.des;
}

@end
