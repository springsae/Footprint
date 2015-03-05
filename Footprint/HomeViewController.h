//
//  HomeViewController.h
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>



@interface HomeViewController : UIViewController
{
    ALAssetsLibrary *_library;  //ALAssetsLibraryのインスタンス
    int _img_x;
    int _img_y;
    int _counter;
}


@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *myView;


@property (weak, nonatomic) IBOutlet UIButton *callCamera;

- (IBAction)tapCallCamera:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *koteiView;

@end
