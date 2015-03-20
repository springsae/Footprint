//
//  imageViewController.h
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
//#import "GPUImage.h"
#import "UIImage+Filters.h"




@interface imageViewController : UIViewController
{
    NSString *_assetsUrl; //assetsUrlを格納するインスタンス
    ALAssetsLibrary *_library;
    NSArray *_imageChangeArray;
    UIImage *_originalImage;
    int _imageEffect;
    
    
}


@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (nonatomic,assign) NSString *assetsurl;

@property (weak, nonatomic) IBOutlet UIButton *backCamera;
- (IBAction)tapBackCamera:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *callComment;
@property (weak, nonatomic) IBOutlet UIButton *tapCallComment;
@property (weak, nonatomic) IBOutlet UIPickerView *imageChangePicker;

@property (weak, nonatomic) IBOutlet UIButton *vignette;
@property (weak, nonatomic) IBOutlet UIButton *blackAndWhite;
@property (weak, nonatomic) IBOutlet UIButton *saturation;
@property (weak, nonatomic) IBOutlet UIButton *curve;

@property (weak, nonatomic) IBOutlet UIButton *reset;


- (IBAction)vignetteBtn:(id)sender;
- (IBAction)blackAndWhiteBtn:(id)sender;
- (IBAction)saturationBtn:(id)sender;
- (IBAction)CurveBtn:(id)sender;
- (IBAction)returnBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelVignette;
@property (weak, nonatomic) IBOutlet UILabel *labelBandW;

@property (weak, nonatomic) IBOutlet UILabel *labelSaturation;
@property (weak, nonatomic) IBOutlet UILabel *labelCurve;
@property (weak, nonatomic) IBOutlet UILabel *labelReset;





//@interface imageViewController : UIViewController
//{
//    GPUImageStillCamera *stillCamera;
//    GPUImageOutput<GPUImageInput> *filter, *secondFilter, *terminalFilter;
//    UISlider *filterSettingsSlider;
//    UIButton *photoCaptureButton;
//    
//    GPUImagePicture *memoryPressurePicture1, *memoryPressurePicture2;
//}

@end
