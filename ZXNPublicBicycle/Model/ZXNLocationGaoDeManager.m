//
//  ZXNLocationGaoDeManager.m
//  Yingke
//
//  Created by 张伟 on 2017/1/3.
//  Copyright © 2017年 ZXN. All rights reserved.
//

#import "ZXNLocationGaoDeManager.h"
#import <CoreLocation/CoreLocation.h>

@interface ZXNLocationGaoDeManager()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locManager;
@property (nonatomic,strong) locationBlock block;
@end
@implementation ZXNLocationGaoDeManager

+ (instancetype)sharedManager{
    static ZXNLocationGaoDeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZXNLocationGaoDeManager alloc]init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _locManager = [[CLLocationManager alloc]init];
        //精确度
        [_locManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //精确到几百米
        _locManager.distanceFilter = 1;
        _locManager.delegate = self;
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"开启服务");
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"手机未开启定位服务，请到【设置】- 【程序】-【位置】中打开" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusNotDetermined) {
                [_locManager requestWhenInUseAuthorization];
            }
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    CLLocation *location= [locations lastObject];

    NSString *lat = [NSString stringWithFormat:@"%@",@(location.coordinate.latitude)];
    NSString *lon = [NSString stringWithFormat:@"%@",@(location.coordinate.longitude)];
    
    [ZXNLocationGaoDeManager sharedManager].lat_gaode = lat;
    [ZXNLocationGaoDeManager sharedManager].lon_gaode = lon;

    // 保存 Device 的现语言 (英语 法语 ，，，)
    CLGeocoder *geoCoder=[CLGeocoder new];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *placemark in placemarks) {
//            NSLog(@"字典:%@,纬度:%f,经度:%f",placemark.addressDictionary,placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
//            
            self.current_city = placemark.addressDictionary[@"City"];
            self.showCityMsg = [NSString stringWithFormat:@"%@ %@",placemark.addressDictionary[@"SubLocality"],placemark.addressDictionary[@"Street"]];
        }
    }];

    self.block(lat,lon);
    [self.locManager stopUpdatingLocation];
}

-(void)getGps:(locationBlock)block{
    self.block = block;
    [self.locManager startUpdatingLocation];
}
@end
