//
//  MapViewController.h
//  myApp4
//
//  Created by Saeko Fuse on 2015/02/17.
//  Copyright (c) 2015年 Saeko Fuse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <JPSThumbnailAnnotation.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>
{
    ALAsset *asset;
    NSArray *_assetsUrls;
    int _counter;
}

@end
