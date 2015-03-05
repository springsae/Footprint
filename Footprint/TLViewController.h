//
//  TLViewController.h
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CustomTableViewCell.h"
#import "TableViewConst.h"
#import "commentViewController.h"


@interface TLViewController : UIViewController
{
    ALAssetsLibrary *_library;//ALAssetsLibraryのインスタンス
    NSArray *_assetsUrls;
    ALAsset *asset;
    
//    int _img_x;
//    int _img_y;
    int _counter;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSString *assetsurl;


@end
