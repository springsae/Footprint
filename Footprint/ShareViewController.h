//
//  ShareViewController.h
//  Footprint
//
//  Created by Saeko Fuse on 2015/03/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLViewController.h"

@interface ShareViewController : UIViewController
{
    NSString *_assetsUrl; //assetsUrlを格納するインスタンス
    ALAssetsLibrary *_library;
    UIImage *_originalImage;
    NSMutableArray *_photolist;
   
    
}

@property (weak, nonatomic) IBOutlet UITextView *shareComment;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
- (IBAction)tapBackTL:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *backTL;
- (IBAction)tapShare:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (nonatomic,assign) NSString *assetsurl;
@property (nonatomic,assign) int selectNum;

@end
