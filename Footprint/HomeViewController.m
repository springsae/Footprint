//
//  HomeViewController.m
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import "HomeViewController.h"
#import "imageViewController.h"



@interface HomeViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    //assetsUrlを格納するインスタンス
    NSString *_assetsurl;

    //    CGPoint _koteiViewCenter;
}


@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_library ==nil)
    {
        _library = [[ALAssetsLibrary alloc]init];
    }
    
    //スクロールする
    self.myScrollView.contentSize = CGSizeMake(320, 2000);
    
    
    
//    //固定する
//     _koteiViewCenter = [_koteiView center];
//    
//    
//    UIImage *image = [UIImage imageNamed:@"preview.jpg"];
//    
//    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 160, 160)];
//    imagev.image = image;
//    
//    [self.view addSubview:imagev];
//    
//    UIImageView *imagev2 = [[UIImageView alloc]initWithFrame:CGRectMake(160, 40, 160, 160)];
//    imagev2.image = image;
//    
//    [self.view addSubview:imagev2];
//    
//    UIImageView *imagev3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, 160, 160)];
//    imagev3.image = image;
//    
//    [self.view addSubview:imagev3];
//    
//    UIImageView *imagev4 = [[UIImageView alloc]initWithFrame:CGRectMake(160, 200, 160, 160)];
//    imagev4.image = image;
//    
//    [self.view addSubview:imagev4];
//    
//    UIImageView *imagev5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 360 , 160, 160)];
//    imagev5.image = image;
//    
//    [self.view addSubview:imagev5];
    
//    UIImageView *imagev6 = [[UIImageView alloc]initWithFrame:CGRectMake(160, 360 , 160, 160)];
//    imagev6.image = image;
//    
//    [self.view addSubview:imagev6];
//    
//    UIImageView *imagev7 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 520, 160, 160)];
//    imagev7.image = image;
//    
//    [self.view addSubview:imagev7];
    
    //UserDefaultObjectを用意する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //一旦配列に取り出す
    NSArray *assetsURLs = [defaults objectForKey:@"assetsURLs"];
    
    _counter = 0;
    
    for (NSString *assetsURL in assetsURLs) {
        [self showPhoto:assetsURL];
    }
    
    
    self.view.frame = CGRectMake(0, 40, 320, 1200);
    
}

-(void)showPhoto:(NSString *)url
{
    
    //URLからALAssetを取得
    [_library assetForURL:[NSURL URLWithString:url]
              resultBlock:^(ALAsset *asset) {
                  
                  //画像があればYES、無ければNOを返す
                  if(asset){
                      NSLog(@"データがあります");
                      //ALAssetRepresentationクラスのインスタンスの作成
                      ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
                      
                      //ALAssetRepresentationを使用して、フルスクリーン用の画像をUIImageに変換
                      //fullScreenImageで元画像と同じ解像度の写真を取得する。
                      
                      _img_x = 0;
                      _img_y = 40;
                      
                      if (_counter % 2 == 1) {
                          _img_x = 160;
                      }
                      
                      _img_y = 160 * (_counter / 2);
                      
                      UIImage *fullscreenImage = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage]];
                      
                      UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(_img_x, _img_y, 160, 160)];
                      imagev.image = fullscreenImage;
                      
                      [self.view addSubview:imagev];
                      _counter++;
                      
                  }else{
                      NSLog(@"データがありません");
                  }
                  
              } failureBlock: nil];
}



////viewの表示位置を固定する
//-(void)scrollViewDidScroll:(UIScrollView*)scrollView
//{
//    CGPoint contentOffset = [scrollView contentOffset];
//    CGPoint newCenter = CGPointMake(_koteiViewCenter.x + contentOffset.x,
//                                    _koteiViewCenter.y + contentOffset.y);
//    [_koteiView setCenter:newCenter];
//}

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

//アクションシートの設定
- (IBAction)tapCallCamera:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"Take Photo"];
    [actionSheet addButtonWithTitle:@"Select From Library"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:2];
    [actionSheet showInView:self.view];
}


//アクションシートのボタン選択で発動する
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    UIImagePickerController *ipc;
    
    switch (buttonIndex)
    {
        case 0:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable:sourceType])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"カメラを起動できません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            ipc = [[UIImagePickerController alloc] init];
            [ipc setSourceType:sourceType];
            [ipc setDelegate:self];
            ipc.allowsEditing = YES;
            [self presentViewController:ipc animated:YES completion:nil];
            break;
            
        case 1:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if (![UIImagePickerController isSourceTypeAvailable:sourceType])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"フォトライブラリーを表示できません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            ipc = [[UIImagePickerController alloc] init];
            [ipc setSourceType:sourceType];
            [ipc setDelegate:self];
            [self presentViewController:ipc animated:YES completion:nil];
            break;
            
        default:
            break;
            
    }
    
}

//画像を引き出し
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    NSLog(@"%@", info);
    
    //取り出して使用
    UIImage *fromCamera=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    //画面表示
    //[self.showImage setImage:fromCamera];
    
    //元の画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //オリジナル画像
    UIImage *originalImage=(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    //カメラライブラリから選んだ写真のURLを取得
    _assetsurl=[[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    
    //カメラが撮影したときだけ保存
    if (_assetsurl==nil){
        
        //トリミング
        originalImage=(UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        
        //カメラのときのNRL取得
        //_library=[[ALAssetsLibrary alloc] init];
        [_library writeImageToSavedPhotosAlbum:originalImage.CGImage orientation:(ALAssetOrientation)originalImage.imageOrientation completionBlock:^(NSURL *assetURL,NSError *error){
            if(error ){
                NSLog(@"error");
            }else{
                NSLog(@"save");
                _assetsurl=[(NSURL *)assetURL absoluteString];
                imageViewController *imageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IV"];
                imageViewController.assetsurl = _assetsurl;
                [self presentViewController:imageViewController animated:YES completion:nil];
                //imageViewController.assetsurl = [self.storyboard instantiateViewControllerWithIdentifier:@"IV"];
                
            }
        }];
    }else{
        //カメラロールから選んだ写真のURLを表示
        imageViewController *imageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IV"];
        imageViewController.assetsurl = _assetsurl;
        [self presentViewController:imageViewController animated:YES completion:nil];
        
        
    }
}

// カメラで撮った画像を保存し終わったときに呼ばれるメソッド
- (void)didFinishSavingImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    //NSLog(@"%@", image);
    //NSLog(@"%@", contextInfo);
}

@end
