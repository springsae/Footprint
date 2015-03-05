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

@interface commentViewController ()<UITextFieldDelegate,UITextViewDelegate>

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
    
    self.picker.delegate = self;
    _categoryArray = [NSArray arrayWithObjects:
                      @"Place",@"Food",@"View",@"Other",nil];
    
    //UserDefaultObjectを用意する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存されたデータを取り出す
    _photolist = [[defaults objectForKey:@"photoData"] mutableCopy];
    
    _textField.delegate = self;
    
    
    //textFieldを角丸にする
    [[self.textField layer] setCornerRadius:10.0];
    [self.textField setClipsToBounds:YES];
    
    //textViewに黒色の枠線を付ける
    [[self.textField layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.textField layer] setBorderWidth:1.0];
    
    // UITextFieldのインスタンスを生成
    CGRect rect = CGRectMake(10, 270, 295, 80);
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    
    // 枠線のスタイルを設定
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    // デリゲートを設定
    textField.delegate = self;
    
    // UITextFieldのインスタンスをビューに追加
    [self.view addSubview:textField];

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
    [self seveAssetsURL];
    
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
         }else
         {
             NSLog(@"データがありません");
      }
         
     } failureBlock: nil];
    
}

//横方向の個数を指定
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// pickerViewの縦の長さを決める
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int cnt = [_categoryArray count];
    return cnt;
}

//ピッカービューの行のタイトルを返す
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_categoryArray objectAtIndex:row];
}


//選択された行番号を取得
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger selectedRow = [pickerView selectedRowInComponent:0];
    NSLog(@"%ld",(long)selectedRow);
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


//文字制限をするメソッド
- (BOOL)textField:(UITextView *)textField shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    int maxInputLength = 100;    //文字制限数
    
    //入力済のテキストを取得
    NSMutableString *str = [textField.text mutableCopy];
    
    //入力済のテキストと入力が行われたテキストを結合
    [str replaceCharactersInRange:range withString:text];
    
    //文字数制限を超えたら
    if([str length] > maxInputLength)
    {
        return NO;  //入力を禁止する
    }
//    //現在の文字数を表示
//    self.textLengthLabel.text = [NSString stringWithFormat:@"%d/%d文字",[str length],maxInputLength];

    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボードの非表示.
    [self.view endEditing:YES];
    // 改行しない.
    return NO;
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
    [[self presentingViewController] dismissModalViewControllerAnimated:YES];

}


- (IBAction)tapOkButton:(id)sender
{
    
    //コメントページのdictionaryを作成
    NSMutableDictionary *myDictionary = [[NSMutableDictionary alloc] init];
    [myDictionary setObject:_assetsurl forKey:@"photo"];
    [myDictionary setObject:_categoryArray[[self.picker selectedRowInComponent:0]] forKey:@"title"];
    [myDictionary setObject:_textField.text forKey:@"comment"];
    
    //NSMutableArrayにdictionaryを挿入
    //NSMutableArray *_photoList = [[NSMutableArray alloc] init];
    [_photolist addObject:myDictionary];
    
    NSLog(@"%@データあり",myDictionary);
    
    //UserDefaultObjectを用意する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //画像を保存
    [defaults setObject:_photolist forKey:@"photoData"];
    [defaults synchronize];
    
    NSLog(@"%@保存",_photolist);
    
//    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    
//    [self performSegueWithIdentifier:@"backToHome" sender:self];
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}

//UserDefaultにassetsURLを保存
-(void)seveAssetsURL{
    
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
- (IBAction)tapShare:(id)sender
{
    
}
@end
