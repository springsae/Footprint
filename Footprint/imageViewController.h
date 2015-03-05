//
//  imageViewController.h
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>



@interface imageViewController : UIViewController
{
    NSString *_assetsUrl; //assetsUrlを格納するインスタンス
    ALAssetsLibrary *_library;
    NSArray *_imageChangeArray;
}


@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (nonatomic,assign) NSString *assetsurl;

@property (weak, nonatomic) IBOutlet UIButton *backCamera;
- (IBAction)tapBackCamera:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *callComment;
@property (weak, nonatomic) IBOutlet UIButton *tapCallComment;
@property (weak, nonatomic) IBOutlet UIPickerView *imageChangePicker;

@end
