//
//  commentViewController.m
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import "commentViewController.h"
#import "imageViewController.h"
#import "HomeViewController.h"


@interface  commentViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation commentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_library ==nil)
    {
        _library = [[ALAssetsLibrary alloc]init];
    }
    
    [self showPhoto:self.assetsurl];
    
//    self.picker.delegate = self;
//    _categoryArray = [NSArray arrayWithObjects:
//                      @"Place",@"Food",@"View",@"Other",nil];
    
    //UserDefaultObjectを用意する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存されたデータを取り出す
    _photolist = [[defaults objectForKey:@"photoData"] mutableCopy];
    
    _textField.delegate = self;
    
    //textViewを角丸にする
    [[self.commentText layer] setCornerRadius:10.0];
    [self.commentText setClipsToBounds:YES];
    
    //textViewに黒色の枠を付ける
    [[self.commentText layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.commentText layer] setBorderWidth:1.0];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_BG4_usui2.jpg"]];

//    [self.smallImage setContentMode:UIViewContentModeScaleAspectFit];
    
////加工画像保存   
//    switch (_imageEffect) {
//        case 0:
//            _imageEffect = 1;
//            self.smallImage.image = [_originalImage vignetteWithRadius:0 andIntensity:18];
//            break;
//        case 1:
//            _imageEffect = 2;
//            self.smallImage.image = [_originalImage saturateImage:0 withContrast:1.05];
//            break;
//        case 2:
//            _imageEffect = 3;
//            self.smallImage.image = [_originalImage saturateImage:1.7 withContrast:1];
//            break;
//        case 3:
//             _imageEffect = 4;
//            self.smallImage.image = [_originalImage curveFilter];
//            break;
//
//        default:
//            break;
//    }

    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //カメラライブラリから選んだ写真のURLを取得。
    _assetsurl = [(NSURL *)[info objectForKey:@"UIImagePickerControllerReferenceURL"] absoluteString];
    
    [self showPhoto:_assetsurl];
    
    if (!_assetsurl)
    {
        UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        self.smallImage.image = originalImage;
    }
    
}

//assetsから取得した画像を表示する
-(void)showPhoto:(NSString *)url
{
    //表示前にUserDefaultに保存
    [self saveAssetsURL];
    
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
             self.smallImage.image = fullscreenImage; //イメージをセット
             
             switch (_imageEffect) {
                 case 1:
                     self.smallImage.image = [self.smallImage.image vignetteWithRadius:0 andIntensity:18];
                     break;
                 case 2:
                     
                     self.smallImage.image = [self.smallImage.image saturateImage:0 withContrast:1.05];
                     break;
                 case 3:
                     
                     self.smallImage.image = [self.smallImage.image saturateImage:1.7 withContrast:1];
                     break;
                 case 4:
    
                     self.smallImage.image = [self.smallImage.image curveFilter];
                     break;
                     
                 default:
                     break;
             }

             
             //exifを取得する
             // raw data
             NSUInteger size = [assetRepresentation size];
             uint8_t *buff = (uint8_t *)malloc(sizeof(uint8_t)*size);
             if(buff != nil)
             {
                 NSError *error = nil;
                 NSUInteger bytesRead = [assetRepresentation getBytes:buff fromOffset:0 length:size error:&error];
                 if (bytesRead && !error)
                 {
                     NSData *photo = [NSData dataWithBytesNoCopy:buff length:bytesRead freeWhenDone:YES];
                     
                     CGImageSourceRef cgImage = CGImageSourceCreateWithData((CFDataRef)photo, nil);
                     NSDictionary *metadata = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(cgImage, 0, nil));
                     if (metadata)
                     {
                            _photoDateTime = metadata[@"{TIFF}"][@"DateTime"];
//                         label.text = metadata[@"{TIFF}"][@"DateTime"];
                         NSLog(@"%@", [metadata description]);
                     }
                     else
                     {
                         NSLog(@"no metadata");
                     }
                     
                 }
                 if (error) {
                     NSLog(@"error:%@", error);
                     free(buff);
                 }
             }else{
                 NSLog(@"データがありません");
             }
         }
         
    } failureBlock: nil];
    
//    switch (_imageEffect) {
//        case 0:
//            _imageEffect = 1;
//            self.smallImage.image = [_originalImage vignetteWithRadius:0 andIntensity:18];
//            break;
//        case 1:
//            _imageEffect = 2;
//            self.smallImage.image = [_originalImage saturateImage:0 withContrast:1.05];
//            break;
//        case 2:
//            _imageEffect = 3;
//            self.smallImage.image = [_originalImage saturateImage:1.7 withContrast:1];
//            break;
//        case 3:
//            _imageEffect = 4;
//            self.smallImage.image = [_originalImage curveFilter];
//            break;
//            
//        default:
//            break;
//    }

    
}

//- (BOOL)textField:(UITextField *)textField
//shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    // すでに入力されているテキストを取得
//    NSMutableString *text = [textField.text mutableCopy];
//    
//    // すでに入力されているテキストに今回編集されたテキストをマージ
//    [text replaceCharactersInRange:range withString:string];
//    
//    // 結果が文字数をオーバーしていないならYES，オーバーしている場合はNO
//    return ([text length] < 200);
//}

//- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSMutableString *tmp = [textField.text mutableCopy];
//    [tmp replaceCharactersInRange:range withString:string];
//    return ([tmp doubleValue] <= 100 && [tmp length] <= 200);
//}

//
////文字制限をするメソッド
//- (BOOL)textField:(UITextView *)textField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//    int maxInputLength = 60;    //文字制限数
//    
//    //入力済のテキストを取得
//    NSMutableString *str = [textField.text mutableCopy];
//    
//    //入力済のテキストと入力が行われたテキストを結合
//    [str replaceCharactersInRange:range withString:text];
//    
//    //文字数制限を超えたら
//    if([str length] > maxInputLength)
//    {
//        return NO;  //入力を禁止する
//    }
////    //現在の文字数を表示
////    self.textLengthLabel.text = [NSString stringWithFormat:@"%d/%d文字",[str length],maxInputLength];
//
//    return YES;
//}


-(void) scrollToVisible:(UITextField *)textField
{
    if ([textField isFirstResponder] && textField.selectedTextRange.end) {
        CGRect caretRect = [textField caretRectForPosition:textField.selectedTextRange.end];
        [_commentText scrollRectToVisible:caretRect animated:YES];
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self performSelector:@selector(scrollToVisible:) withObject:textField afterDelay:0.3];
}

- (void) textFieldDidChangeSelection:(UITextView *)textField
{
    [self performSelector:@selector(scrollToVisible:) withObject:textField afterDelay:0.1];
}

-(void) textFieldDidChange:(UITextField *)textField
{
    [self performSelector:@selector(scrollToVisible:) withObject:textField afterDelay:0.2];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *tmp = [textField.text mutableCopy];
    [tmp replaceCharactersInRange:range withString:string];
    return ([tmp doubleValue] <= 60 && [tmp length] <= 4);
}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    // キーボードの非表示.
//    [self.view endEditing:YES];
//    // 改行しない.
//    return NO;
//}

// UITextField の Return キーをタップ時にキーボードを隠す
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)tapBackImage:(id)sender
{
//    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)tapOkButton:(id)sender
{
    [_library writeImageToSavedPhotosAlbum:self.smallImage.image.CGImage orientation:self.smallImage.image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        if(error){
            NSLog(@"error");
            
        }else{
            NSLog(@"save");
            _assetsurl = [(NSURL*) assetURL absoluteString];
            
            //コメントページのdictionaryを作成
            NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
            [myDictionary setObject:_assetsurl forKey:@"photo"];
            //    [myDictionary setObject:_categoryArray[[self.picker selectedRowInComponent:0]] forKey:@"title"];
            [myDictionary setObject:_commentText.text forKey:@"comment"];
            
            if (!_photoDateTime){
                _photoDateTime = @"";
                
            }else{
                NSLog(@"%@",_photoDateTime);
                
                NSDateFormatter *DateFormatter =[[NSDateFormatter alloc] init];
                [DateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
                
                //一旦日付型に変換
                NSDate *photoDate = [DateFormatter dateFromString:_photoDateTime];
                
                //フォーマットをyyyy/MM/dd HH:mm　に変換して再代入
                [DateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
                _photoDateTime = [DateFormatter stringFromDate:photoDate];
            }
            
            [myDictionary setObject:_photoDateTime forKey:@"datetime"];
            
            //NSMutableArrayにdictionaryを挿入
            //NSMutableArray *_photoList = [[NSMutableArray alloc] init];
            if(_photolist==nil)
            {
                _photolist= [[NSMutableArray alloc] init];
            }
            
            
            [_photolist addObject:myDictionary];
            
            NSLog(@"%@データあり",myDictionary);
            
            //UserDefaultObjectを用意する
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //画像を保存
            [defaults setObject:_photolist forKey:@"photoData"];
            NSMutableArray *assetsURLs = [[defaults objectForKey:@"assetsURLs"] mutableCopy];
            
            [assetsURLs removeLastObject];
            [assetsURLs addObject:_assetsurl];
            [defaults setObject:assetsURLs forKey:@"assetsURLs"];
            
            [defaults synchronize];
            
            NSLog(@"%@保存",_photolist);
            
            //    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
            
            //    [self performSegueWithIdentifier:@"backToHome" sender:self];
            
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
            
    }];
    
//    //コメントページのdictionaryを作成
//    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
//    [myDictionary setObject:_assetsurl forKey:@"photo"];
////    [myDictionary setObject:_categoryArray[[self.picker selectedRowInComponent:0]] forKey:@"title"];
//    [myDictionary setObject:_commentText.text forKey:@"comment"];
//    
//    if (!_photoDateTime){
//        _photoDateTime = @"";
//    
//    }else{
//        NSLog(@"%@",_photoDateTime);
//        
//        NSDateFormatter *DateFormatter =[[NSDateFormatter alloc] init];
//        [DateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
//        
//        //一旦日付型に変換
//        NSDate *photoDate = [DateFormatter dateFromString:_photoDateTime];
//        
//        //フォーマットをyyyy/MM/dd HH:mm　に変換して再代入
//        [DateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
//        _photoDateTime = [DateFormatter stringFromDate:photoDate];
//    }
//    
//    [myDictionary setObject:_photoDateTime forKey:@"datetime"];
//    
//    //NSMutableArrayにdictionaryを挿入
//    //NSMutableArray *_photoList = [[NSMutableArray alloc] init];
//    if(_photolist==nil)
//    {
//        _photolist= [[NSMutableArray alloc] init];
//    }
//    
//    
//    [_photolist addObject:myDictionary];
//    
//    NSLog(@"%@データあり",myDictionary);
//    
//    //UserDefaultObjectを用意する
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    //画像を保存
//    [defaults setObject:_photolist forKey:@"photoData"];
//    [defaults synchronize];
//    
//    NSLog(@"%@保存",_photolist);
//    
////    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
//    
////    [self performSegueWithIdentifier:@"backToHome" sender:self];
//    
//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    
}

//UserDefaultにassetsURLを保存
-(void)saveAssetsURL{
    
    //UserDefaultObjectを用意する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //一旦配列に取り出す
    NSMutableArray *assetsURLs = [[defaults objectForKey:@"assetsURLs"] mutableCopy];
    
    if (assetsURLs == nil) {
        assetsURLs = [NSMutableArray new];
    }
    
    //配列に新しいURLを追加
    [assetsURLs addObject:_assetsurl];
    
    //assetsURLを保存
    [defaults setObject:assetsURLs forKey:@"assetsURLs"];
    
    [defaults synchronize];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"backImageView"])
    {
        imageViewController *iVC = [segue destinationViewController];
        iVC.assetsurl = self.assetsurl;
    }
}



- (IBAction)tapBackHome:(id)sender
{
    
    
}
//確認
- (IBAction)tapShare:(id)sender
{
    if( [UIActivityViewController class] ) {
        //共有テキスト設定
        NSString *textToShare = [NSString stringWithFormat:@"%@", @"共有するテキストがここに入ります"];
        //共有イメージ設定
        UIImage *imageToShare = self.assetsurl;
        //共有アイテム生成
        NSArray *itemsToShare = [[NSArray alloc] initWithObjects:textToShare, imageToShare, nil];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = [[NSArray alloc] initWithObjects: UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToWeibo, nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}
@end
