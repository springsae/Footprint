//
//  CustomTableViewCell.h
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/23.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *CustomCellImage;
@property (weak, nonatomic) IBOutlet UITextView *CustomCellText;
@property (weak, nonatomic) IBOutlet UITextField *CustomCellTime;

+ (CGFloat)rowHeight;

@end
