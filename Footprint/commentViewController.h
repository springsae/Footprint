//
//  commentViewController.h
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

@interface commentViewController : UIViewController<UIPickerViewDelegate>
{
    NSString *_assetsUrl;    //assetsUrlを格納するインスタンス
    ALAssetsLibrary *_library;
    NSArray *_categoryArray;
    NSMutableArray *_photolist;
    NSString *_photoDateTime;
    UIImage *_originalImage;
    int _imageEffect;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UITextView *textField;

@property (weak, nonatomic) IBOutlet UIButton *backImage;
- (IBAction)tapBackImage:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *okButton;
- (IBAction)tapOkButton:(id)sender;

@property (nonatomic,assign) NSString *assetsurl;

@property NSUserDefaults *userDefaults;

@property NSMutableArray *photoData;
//@property (weak, nonatomic) IBOutlet UIButton *homeButton;
//- (IBAction)tapBackHome:(id)sender;
//
//@property (weak, nonatomic) IBOutlet UIButton *shareButton;
//
//- (IBAction)tapShare:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *commentText;

@end
