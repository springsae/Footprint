//
//  TLViewController.m
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import "TLViewController.h"
#import "CustomTableViewCell.h"
#import "TableViewConst.h"
#import <ImageIO/ImageIO.h>



@interface TLViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UserDefaultObjectを用意する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //一旦配列に取り出す
    _assetsUrls = [defaults objectForKey:@"photoData"];

    _counter = 0;
    
    

//    for (NSString *assetsURL in assetsURL) {
//        [self showPhoto:assetsURL];
//    }
    
    // デリゲートメソッドをこのクラスで実装する
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    //テーブルに表示したいデータソースをセット
    
    

    // カスタマイズしたセルをテーブルビューにセット
    UINib *nib = [UINib nibWithNibName:CustomTableViewCellIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
//    
//    //------- exifを取得する --------
//    // raw data
//    //ALAssetRepresentationクラスのインスタンスの作成
//    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
//    NSUInteger size = [assetRepresentation size];
//    uint8_t *buff = (uint8_t *)malloc(sizeof(uint8_t)*size);
//    if(buff != nil)
//    {
//        NSError *error = nil;
//        NSUInteger bytesRead = [assetRepresentation getBytes:buff fromOffset:0 length:size error:&error];
//        if (bytesRead && !error)
//        {
//            NSData *photo = [NSData dataWithBytesNoCopy:buff length:bytesRead freeWhenDone:YES];
//            
//            CGImageSourceRef cgImage = CGImageSourceCreateWithData((CFDataRef)photo, nil);
//            NSDictionary *metadata = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(cgImage, 0, nil));
//            if (metadata)
//            {
//                NSLog(@"%@", [metadata description]);
//            }
//            else
//            {
//                NSLog(@"no metadata");
//            }
//            
//        }
//        if (error)
//        {
//            NSLog(@"error:%@", error);
//            free(buff);
//        }
//        
//    }

    if (_library ==nil)
    {
        _library = [[ALAssetsLibrary alloc]init];
    }
    
//   [UITabBar appearance].backgroundImage = [UIImage imageNamed:@"tabbarBG3"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_BG4_usui.jpg"]];
    UIImage *backgroundImage = [UIImage imageNamed:@"sky_BG4_usui.jpg"];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _assetsUrls.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    
    //再利用可能なCellオブジェクトを作成
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //要確認
    ALAssetRepresentation *assetRepresentation = [Asset defaultRepresentation];
    UIImage *returnfullscreenImage = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage]];
    cell.CustomCellImage.image = returnfullscreenImage;
    
    //textfield編集不可
    cell.CustomCellText.editable = NO;
    
    NSDictionary *rowDictionary = _assetsUrls[indexPath.row];
    cell.CustomCellText.text = rowDictionary[@"comment"];
    [self showPhoto:rowDictionary[@"photo"] ImageView:cell.CustomCellImage Label:cell.CustomCellTime];
    
//    cell.backgroundColor = [UIColor clearColor];
    
       return cell;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
//   カスタムセル横幅調節　確認
    CustomTableViewCell *iCell = (CustomTableViewCell *) cell;
    iCell.inset = 9.0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CustomTableViewCell rowHeight];
}


// Cell が選択された時
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath
{
    [self performSegueWithIdentifier:@"backToComment" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"backToComment"])
    {
        TLViewController *tvc = (TLViewController*)[segue destinationViewController];
        // 移行先の ViewController に画像名を渡す
        tvc.assetsurl = self.assetsurl;
    }

}

//
-(void)showPhoto:(NSString *)url ImageView:(UIImageView *)imageView Label:(UILabel *)label
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
            UIImage *fullscreenImage = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage]];
            imageView.image = fullscreenImage;
            
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
                        label.text = metadata[@"{TIFF}"][@"DateTime"];
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
            }
            
           }
           else
          {
            NSLog(@"データがありません");
          }
                  
    } failureBlock: nil];
}




//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSInteger dataCount;
//    
//    
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

@end
