//
//  ZXNRootController.m
//  ZXNPublicBicycle
//
//  Created by 张小牛 on 2017/7/13.
//  Copyright © 2017年 ZXN. All rights reserved.
//

#import "ZXNRootController.h"

@interface ZXNRootController ()

@end

@implementation ZXNRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
}

//当前城市
- (NSString *)currentCity{
    ZXNLocationGaoDeManager *current = [ZXNLocationGaoDeManager sharedManager];
    return current.current_city;
}
//当前的经纬度
- (NSString *)show_longitude{//118.727559
    return @"118.727559";
}
- (NSString *)show_latitude{//32.038987
    return @"32.038987";
}

//导航去的经纬度
//- (void)toLatitude:(NSString *)latitude longitude:(NSString *)longitude{
//    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:[self.current_latitude doubleValue] longitude:[self.current_longitude doubleValue]];
//    
//    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
//    
//    JSParkToNaviController *js = [[JSParkToNaviController alloc]init];
//    js.startPoint = startPoint;
//    js.endPoint = endPoint;
//    [self.navigationController pushViewController:js animated:YES];
//}
@end
