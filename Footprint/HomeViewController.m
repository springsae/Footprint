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
    
    UIView *_koteiView;
    CGPoint _koteiViewCenter;
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
    self.myScrollView.delegate = self;
    
//    /* インスタンス作成 */
//    HomeViewController *pagingView = [[InfiniteHomeView alloc] initWithFrame:frame];
//    /* 1ページあたりのサイズを指定 */
//    pagingView.pageSize = CGSizeMake(320.f, 100.f);
//    /* スクロール方向を垂直に指定 */
//    pagingView.scrollDirection = InfinitePagingViewVerticalScrollDirection;
    
    if([CLLocationManager locationServicesEnabled]){
        self.locationManager =[[CLLocationManager alloc] init];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingHeading];
        
    }
    
    //固定ビューの初期化
    _koteiView =[UIView new];
    
    //配置
    _koteiView.frame = CGRectMake(self.view.bounds.size.width/2-25,self.view.bounds.size.height-100,50,50);
    _koteiView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0 alpha:0];
    
    //ボタンを作成
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(0, 0, 50, 50);
    [cameraBtn setImage:[UIImage imageNamed:@"cameraIcon48"] forState:UIControlStateNormal];
    [_koteiView addSubview:cameraBtn];
    
    //ボタンがタップされた時に呼ばれるメソッドの設定
    [cameraBtn  addTarget:self action:@selector(tapCallCamera:) forControlEvents:UIControlEventTouchUpInside];
    _koteiViewCenter = [_koteiView center];
    
    self.view.frame = CGRectMake(0, 40, 320, 1200);
//    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"sky_BG4_usui.jpg"] drawInRect:self.view.bounds];
//    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_BG4_usui2.jpg"]];
    
   
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    //UserDefaultObjectを用意する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //一旦配列に取り出す
    NSArray *assetsURLs = [defaults objectForKey:@"assetsURLs"];
    
    _counter = 0;
    
    for (NSString *assetsURL in assetsURLs) {
        [self showPhoto:assetsURL];
    }
    

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
                      
                      int marginwidth = self.view.bounds.size.width;
                      
                      marginwidth = marginwidth - 160*2;
                      
                      marginwidth = marginwidth / 3;
                      
                      _img_x = marginwidth;
                      
                      if (_counter % 2 == 1) {
                          _img_x = 160 + marginwidth*2;
                      }
                      
                      _img_y = 160 * (_counter / 2);
                      
                      if (_img_y + 160 > 2000){
                          self.myScrollView.contentSize = CGSizeMake(320, _img_y+200);
                      }
                      
//                      UIImage *fullscreenImage = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage]];
                      
                      UIImage *thumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
                    
////                      //画像を回転させないための処理　確認
//                      thumbnail =  [UIImage imageWithCGImage:thumbnail.CGImage scale:thumbnail.scale orientation:UIImageOrientationUp];
                      
                      
                      UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(_img_x, _img_y, 160, 160)];
                      imagev.image = thumbnail;
                      
                      [self.view addSubview:imagev];
                      _counter++;
                      
                      [self.view bringSubviewToFront:_koteiView];
                      
                  }else{
                      NSLog(@"データがありません");
                  }
                  
              } failureBlock: nil];
}



//viewの表示位置を固定する
-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGPoint contentOffset = [scrollView contentOffset];
    CGPoint newCenter = CGPointMake(_koteiViewCenter.x + contentOffset.x,
                                    _koteiViewCenter.y + contentOffset.y);
    [_koteiView setCenter:newCenter];
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
    
    //メタデータを含んだ静止画をカメラロールに保存
    NSMutableDictionary *metadata = [info[UIImagePickerControllerMediaMetadata] mutableCopy];
//    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
//    [assetsLibrary writeImageToSavedPhotosAlbum:fromCamera.CGImage metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
//        if (error) {
//            NSLog(@"Save image failed. %@", error);
//        }
//    }];
    
    //画面表示
    //[self.showImage setImage:fromCamera];
    
    //元の画面に戻る
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //オリジナル画像
    UIImage *originalImage=(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    
    //カメラライブラリから選んだ写真のURLを取得
    _assetsurl=[[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
    
//    確認
//    CGImageRef ref = CGImageCreateWithImageInRect(self.CGImage, croppedSquare);
//    UIImage *originalImage = [UIImage imageWithCGImage:ref
//                                                scale:[UIScreen mainScreen].scale
//                                          orientation:self.imageOrientation];
//    NSLog(@"Orientation(After):%@", [NSNumber numberWithInteger:originalImage.imageOrientation]);
//    CGImageRelease(ref);
    
    //カメラが撮影したときだけ保存
    if (_assetsurl==nil){
        
        //トリミング
        originalImage=(UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        
        
        //位置情報を上書き
        if (self.locationManager) {
            [metadata setObject:[self GPSDictionaryForLocation:self.locationManager.location] forKey:(NSString *)kCGImagePropertyGPSDictionary];
//            [metadata setObject:[NSString stringWithFormat:@"%ld",originalImage.imageOrientation] forKey:@"Orientation"];
            [metadata setObject:[NSString stringWithFormat:@"%d",originalImage.imageOrientation] forKey:@"Orientation"];
            

        }
        
        
        //カメラのときのNRL取得
        //_library=[[ALAssetsLibrary alloc] init];
        [_library writeImageToSavedPhotosAlbum:originalImage.CGImage metadata:metadata completionBlock:^(NSURL *assetURL,NSError *error){
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

//位置情報を取得
- (NSDictionary *)GPSDictionaryForLocation:(CLLocation *)location
{
    NSMutableDictionary *gps = [NSMutableDictionary new];

    // 日付
    gps[(NSString *)kCGImagePropertyGPSDateStamp] = [[FormatterUtil GPSDateFormatter] stringFromDate:location.timestamp];
    // タイムスタンプ
    gps[(NSString *)kCGImagePropertyGPSTimeStamp] = [[FormatterUtil GPSTimeFormatter] stringFromDate:location.timestamp];

    // 緯度
    CGFloat latitude = location.coordinate.latitude;
    NSString *gpsLatitudeRef;
    if (latitude < 0) {
        latitude = -latitude;
        gpsLatitudeRef = @"S";
    } else {
        gpsLatitudeRef = @"N";
    }
    gps[(NSString *)kCGImagePropertyGPSLatitudeRef] = gpsLatitudeRef;
    gps[(NSString *)kCGImagePropertyGPSLatitude] = @(latitude);

    // 経度
    CGFloat longitude = location.coordinate.longitude;
    NSString *gpsLongitudeRef;
    if (longitude < 0) {
        longitude = -longitude;
        gpsLongitudeRef = @"W";
    } else {
        gpsLongitudeRef = @"E";
    }
    gps[(NSString *)kCGImagePropertyGPSLongitudeRef] = gpsLongitudeRef;
    gps[(NSString *)kCGImagePropertyGPSLongitude] = @(longitude);

    // 標高
    CGFloat altitude = location.altitude;
    if (!isnan(altitude)){
        NSString *gpsAltitudeRef;
        if (altitude < 0) {
            altitude = -altitude;
            gpsAltitudeRef = @"1";
        } else {
            gpsAltitudeRef = @"0";
        }
        gps[(NSString *)kCGImagePropertyGPSAltitudeRef] = gpsAltitudeRef;
        gps[(NSString *)kCGImagePropertyGPSAltitude] = @(altitude);
    }

    return gps;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.view addSubview:_koteiView];
    
}

// カメラで撮った画像を保存し終わったときに呼ばれるメソッド
- (void)didFinishSavingImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    //NSLog(@"%@", image);
    //NSLog(@"%@", contextInfo);
}

@end
