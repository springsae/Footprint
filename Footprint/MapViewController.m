//
//  MapViewController.m
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import "MapViewController.h"

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
    
    
    //------- exifを取得する --------
    // raw data
    //ALAssetRepresentationクラスのインスタンスの作成
    ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
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
                NSLog(@"%@", [metadata description]);
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

    
    //MapViewオブジェクトを作成
    MKMapView *mapView = [[MKMapView alloc] init];
    
    //delegate設定
    mapView.delegate = self;
    
    //大きさ、位置を設定
    mapView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20);
    
    //表示位置の中心を設定
    CLLocationCoordinate2D co;
    
    //アヤラの位置を設定
    co.latitude = 10.317347; //緯度
    co.longitude = 123.905759; //経度
    
    [mapView setCenterCoordinate:co];
    
    //縮尺を設定
    MKCoordinateRegion cr = mapView.region;
    cr.span.latitudeDelta = 50; //数字を小さくすると、詳細な地図（範囲が狭い）になる
    cr.span.longitudeDelta = 50;
    cr.center = co;
    [mapView setRegion:cr];
    
    //地図の表示種類設定
    mapView.mapType = MKMapTypeStandard;
    //現在地を表示
    mapView.showsUserLocation = YES;
//    
//    MKPointAnnotation *pin = [self createdPin:co Title:@"アヤラ" Subutitle:@"Biggest Shopping Mall in Cebu"];
//    [mapView addAnnotation:pin];
//    
    
    //要確認：exif情報を追加する
    JPSThumbnail *thumbnail = [[JPSThumbnail alloc] init];
    thumbnail.image = [UIImage imageNamed:@"ayala.jpg"];
//    thumbnail.title = @"Ayala Mall";
//    thumbnail.subtitle = @"Biggest Shopping Mall in Cebu";
    thumbnail.coordinate = CLLocationCoordinate2DMake(10.317347, 123.905759);
    thumbnail.disclosureBlock = ^{ NSLog(@"selected ayala"); };
    
    [mapView addAnnotation:[JPSThumbnailAnnotation annotationWithThumbnail:thumbnail]];
    
    //mapに表示させる
    [self.view addSubview:mapView];
    
    
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
