//
//  imageViewController.m
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import "imageViewController.h"
#import "HomeViewController.h"
#import "commentViewController.h"


@interface imageViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation imageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        if (_library ==nil)
        {
            _library = [[ALAssetsLibrary alloc]init];
        }
        
        [self showPhoto:self.assetsurl];
    
//    self.imageChangePicker.delegate = self;
//    _imageChangeArray = [NSArray arrayWithObjects:
//                      @"Saturation",@"B&W",@"Vignette",@"Vintage",@"Curve",nil];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_BG4_usui.jpg"]];
    
    

    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //カメラライブラリから選んだ写真のURLを取得。
    _assetsurl = [(NSURL *)[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
    
    [self showPhoto:_assetsurl];
    
    
    if (!_assetsurl)
    {
        UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
//        [originalImage setContentMode:UIViewContentModeScaleAspectFill];
        self.showImage.image = originalImage;
    }
    
//    UIGraphicsBeginImageContext(originalImage.size);
//    [originalImage drawInRect:CGRectMake(0, 0, imageOriginal.size.width, imageOriginal.size.height)];
//    originalImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    [picker dismissViewControllerAnimated:YES completion:nil];  //元の画面に戻る
    
    
    
    

}

//assetsから取得した画像を表示する
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
             self.showImage.image = fullscreenImage; //イメージをセット
             _originalImage = fullscreenImage;
             
         }else
         {
             NSLog(@"データがありません");
         }
         
     } failureBlock: nil];
    
    }


////横方向の個数を指定
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//// pickerViewの縦の長さを決める
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    int cnt = [_imageChangeArray count];
//    return cnt;
//}
//
////ピッカービューの行のタイトルを返す
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [_imageChangeArray objectAtIndex:row];
//}
//
//
////選択された行番号を取得
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    NSInteger selectedRow = [pickerView selectedRowInComponent:0];
//    NSLog(@"%ld",(long)selectedRow);
//    
//}

//pickerViewで選択した後の動作を指定




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    if (_library ==nil)
//    {
//        _library = [[ALAssetsLibrary alloc]init];
//    }
//    
//    [self showPhoto:self.assetsurl];
//    
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapBackCamera:(id)sender
{
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//
//    [self.inputViewController dismissViewControllerAnimated:YES completion:nil];
//    [[self.inputViewController navigationController] popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
//
//    UIImagePickerControllerSourceType sourceType;
//    
//    UIImagePickerController *ipc;
//    
//    sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    if (![UIImagePickerController isSourceTypeAvailable:sourceType])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"カメラを起動できません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    ipc = [[UIImagePickerController alloc] init];
//    
//    [ipc setSourceType:sourceType];
//    
//    [ipc setDelegate:self];
//    
//    ipc.allowsEditing = YES;
//    
//    [self presentViewController:ipc animated:YES completion:nil];
}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
//    NSLog(@"キャンセル");
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showComment"]){
        commentViewController *cVC = [segue destinationViewController];
        cVC.assetsurl = self.assetsurl;
    }
    
}


- (IBAction)vignetteBtn:(id)sender {
    self.showImage.image = [_originalImage vignetteWithRadius:0 andIntensity:18];
    
}

- (IBAction)blackAndWhiteBtn:(id)sender {
    self.showImage.image = [_originalImage saturateImage:0 withContrast:1.05];
}

- (IBAction)saturationBtn:(id)sender {
    self.showImage.image = [_originalImage saturateImage:1.7 withContrast:1];
}

- (IBAction)CurveBtn:(id)sender {
    self.showImage.image = [_originalImage curveFilter];
}

//- (IBAction)returnBtn:(id)sender {
//    [self.myPhoto setImage:self.originalImage];
//    
//}
@end
