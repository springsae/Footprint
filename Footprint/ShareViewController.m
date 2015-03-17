//
//  ShareViewController.m
//  Footprint
//
//  Created by Saeko Fuse on 2015/03/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UserDefaultObjectを用意する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //一旦配列に取り出す
    _assetsUrl = [defaults objectForKey:@"photoData"];

    
    if (_library ==nil)
    {
        _library = [[ALAssetsLibrary alloc]init];
    }
    
    [self showPhoto:self.assetsurl];
    
//    //保存されたデータを取り出す
//    _photolist = [[defaults objectForKey:@"photoData"] mutableCopy];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_BG4_usui.jpg"]];
    UIImage *backgroundImage = [UIImage imageNamed:@"sky_BG4_usui.jpg"];

}


-(void)showPhoto:(NSString *)url
{
    //URLからALAssetを取得
    [_library assetForURL:[NSURL URLWithString:url]
              resultBlock:^(ALAsset *asset)
     {
         
         //画像があればYES、無ければNOを返す
         if(asset)
         {
             NSLog(@"データがあります");
             //ALAssetRepresentationクラスのインスタンスの作成
             ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
             
             //ALAssetRepresentationを使用して、フルスクリーン用の画像をUIImageに変換
             //fullScreenImageで元画像と同じ解像度の写真を取得する。
             
             UIImage *fullscreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]];
             
             //             [fullscreenImage setContentMode:UIViewContentModeScaleAspectFill];
             self.shareImage.image = fullscreenImage; //イメージをセット
             _originalImage = fullscreenImage;
             
         }else
         {
             NSLog(@"データがありません");
         }
         
     } failureBlock: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapBackTL:(id)sender {
}
- (IBAction)tapShare:(id)sender {
}
@end
