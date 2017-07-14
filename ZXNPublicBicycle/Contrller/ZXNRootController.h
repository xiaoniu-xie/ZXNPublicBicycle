//
//  ZXNRootController.h
//  ZXNPublicBicycle
//
//  Created by 张小牛 on 2017/7/13.
//  Copyright © 2017年 ZXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXNRootController : UIViewController

//当前城市
@property (nonatomic,strong) NSString *currentCity;
//当前的经纬度
@property (nonatomic,strong) NSString *show_longitude;
@property (nonatomic,strong) NSString *show_latitude;

//导航去的经纬度
//- (void)toLatitude:(NSString *)latitude longitude:(NSString *)longitude;

@end
