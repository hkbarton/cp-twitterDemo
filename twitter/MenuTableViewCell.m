//
//  MenuTableViewCell.m
//  twitter
//
//  Created by Ke Huang on 2/28/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "MenuTableViewCell.h"

@interface MenuTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *labelMenu;

@end

@implementation MenuTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setMenuItem:(NSDictionary *)menuItem {
    [self.iconView setImage:[UIImage imageNamed:menuItem[@"icon"]]];
    self.labelMenu.text = menuItem[@"menuDes"];
}

@end
