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
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_BG4_usui2.jpg"]];
    
//    [self.shareImage setContentMode:UIViewContentModeScaleAspectFit];
    
    self.shareComment.editable = NO;
    
    


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
    if( [UIActivityViewController class] ) {
        //共有テキスト設定
        NSString *textToShare = [NSString stringWithFormat:@"%@", @"共有するテキストがここに入ります"];
        //共有イメージ設定
        UIImage *imageToShare = _assetsUrl;
        //共有アイテム生成
        NSArray *itemsToShare = [[NSArray alloc] initWithObjects:textToShare, imageToShare, nil];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = [[NSArray alloc] initWithObjects: UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToWeibo, nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }

}

//画像ファイルを取得
- (UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = _assetsUrl;
    return (imageView.image);
}
@end
