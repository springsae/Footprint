//
//  CustomTableViewCell.m
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/23.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell



//(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

+ (CGFloat)rowHeight
{
    return 80.0f;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
