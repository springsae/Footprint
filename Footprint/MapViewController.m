//
//  MapViewController.m
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import "MapViewController.h"
#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //UserDefaultObjectを用意する
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //一旦配列に取り出す
    _assetsUrls = [defaults objectForKey:@"assetsURLs"];
    
    _counter = 0;
    
    if (_library ==nil)
    {
        _library = [[ALAssetsLibrary alloc]init];
    }
    
    
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

    
    //MapViewオブジェクトを作成
    MapView = [[MKMapView alloc] init];
    
    //delegate設定
    MapView.delegate = self;
    
    //大きさ、位置を設定
    MapView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20);
    
    //表示位置の中心を設定
    CLLocationCoordinate2D co;
    
    //アヤラの位置を設定
    co.latitude = 10.317347; //緯度
    co.longitude = 123.905759; //経度
    
    [MapView setCenterCoordinate:co];
    
    //縮尺を設定
    MKCoordinateRegion cr = MapView.region;
    cr.span.latitudeDelta = 50; //数字を小さくすると、詳細な地図（範囲が狭い）になる
    cr.span.longitudeDelta = 50;
    cr.center = co;
    [MapView setRegion:cr];
    
    //地図の表示種類設定
    MapView.mapType = MKMapTypeStandard;
    //現在地を表示
    MapView.showsUserLocation = YES;
//    
//    MKPointAnnotation *pin = [self createdPin:co Title:@"アヤラ" Subutitle:@"Biggest Shopping Mall in Cebu"];
//    [mapView addAnnotation:pin];
//    
    
//    //要確認：exif情報を追加する
//    JPSThumbnail *thumbnail = [[JPSThumbnail alloc] init];
//    thumbnail.image = [UIImage imageNamed:@"ayala.jpg"];
////    thumbnail.title = @"Ayala Mall";
////    thumbnail.subtitle = @"Biggest Shopping Mall in Cebu";
//    thumbnail.coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759);
//    thumbnail.disclosureBlock = ^{ NSLog(@"selected ayala"); };
    
    for (NSString *url in _assetsUrls){
        [self settingPin:url];
    }
    
    //mapに表示させる
    [self.view addSubview:MapView];
    
//     [UITabBar appearance].backgroundImage = [UIImage imageNamed:@"tabbarBG3"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sky_BG4_usui2.jpg"]];
}

//ピンをたてる
-(void)settingPin:(NSString *)url
{
    //URLからALAssetを取得
    [_library assetForURL:[NSURL URLWithString:url]
              resultBlock:^(ALAsset *asset)
     {

         //画像があればYES、無ければNOを返す
         if(asset)
         {
            //ALAssetsRepresentationクラスのインスタンス作成
            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
             
            //ALAssetsRepresentationを使用して、フルスクリーン用の画像をUIImageに変換
            //fullscreenImageで元画像と同じ解像度の写真を取得する
//             UIImage *fullscreenImage = [UIImage imageWithCGImage:[assetRepresentation fullResolutionImage]];
             
             UIImage *thumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
             JPSThumbnail *jpsThumbnail = [[JPSThumbnail alloc] init];
             
             jpsThumbnail.image = thumbnail;
             jpsThumbnail.subtitle = @"clickhere";
             

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
                         jpsThumbnail.title = metadata[@"{TIFF}"][@"DateTime"];
            
                         NSLog(@"%@", [metadata description]);
                         jpsThumbnail.disclosureBlock = ^{NSLog(@"selected");};
                          jpsThumbnail.coordinate = CLLocationCoordinate2DMake([metadata[@"{GPS}"][@"Latitude"] doubleValue], [metadata[@"{GPS}"][@"Longitude"] doubleValue]);
                        
                        [MapView addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:jpsThumbnail]];
                                                                               
            
                     }
                     else
                     {
                         NSLog(@"no metadata");
                     }
                     
                 }
                 if (error)
                 {
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

//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
//        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
//    }
//}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}
//
////位置情報オブジェクトを取得する
//- (NSDictionary *)GPSDictionaryForLocation:(CLLocation *)location
//{
//    NSMutableDictionary *gps = [NSMutableDictionary new];
//    
//    // 日付
//    gps[(NSString *)kCGImagePropertyGPSDateStamp] = [[HomeViewController GPSDateFormatter] stringFromDate:location.timestamp];
//    // タイムスタンプ
//    gps[(NSString *)kCGImagePropertyGPSTimeStamp] = [[HomeViewController GPSTimeFormatter] stringFromDate:location.timestamp];
//    
//    // 緯度
//    CGFloat latitude = location.coordinate.latitude;
//    NSString *gpsLatitudeRef;
//    if (latitude < 0) {
//        latitude = -latitude;
//        gpsLatitudeRef = @"S";
//    } else {
//        gpsLatitudeRef = @"N";
//    }
//    gps[(NSString *)kCGImagePropertyGPSLatitudeRef] = gpsLatitudeRef;
//    gps[(NSString *)kCGImagePropertyGPSLatitude] = @(latitude);
//    
//    // 経度
//    CGFloat longitude = location.coordinate.longitude;
//    NSString *gpsLongitudeRef;
//    if (longitude < 0) {
//        longitude = -longitude;
//        gpsLongitudeRef = @"W";
//    } else {
//        gpsLongitudeRef = @"E";
//    }
//    gps[(NSString *)kCGImagePropertyGPSLongitudeRef] = gpsLongitudeRef;
//    gps[(NSString *)kCGImagePropertyGPSLongitude] = @(longitude);
//    
//    // 標高
//    CGFloat altitude = location.altitude;
//    if (!isnan(altitude)){
//        NSString *gpsAltitudeRef;
//        if (altitude < 0) {
//            altitude = -altitude;
//            gpsAltitudeRef = @"1";
//        } else {
//            gpsAltitudeRef = @"0";
//        }
//        gps[(NSString *)kCGImagePropertyGPSAltitudeRef] = gpsAltitudeRef;
//        gps[(NSString *)kCGImagePropertyGPSAltitude] = @(altitude);
//    }
//    
//    return gps;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
////ピンを立てる自作メソッド
//-(MKPointAnnotation *)createdPin:(CLLocationCoordinate2D)co Title:(NSString *)title Subutitle:(NSString *)subtitle{
//    
//    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
//    pin.coordinate = co;
//    pin.title = title;
//    pin.subtitle = subtitle;
//    
//    return pin;
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
