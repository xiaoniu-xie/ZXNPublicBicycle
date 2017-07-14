//
//  ZXNLocationGaoDeManager.h
//  Yingke
//
//  Created by 张伟 on 2017/1/3.
//  Copyright © 2017年 ZXN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^locationBlock)(NSString *lat,NSString *lon);

@interface ZXNLocationGaoDeManager : NSObject

+ (instancetype)sharedManager;

- (void)getGps:(locationBlock)block;

@property (nonatomic,copy) NSString *lat_gaode;
@property (nonatomic,copy) NSString *lon_gaode;
@property (nonatomic,strong) NSString *current_city;
@property (nonatomic,strong) NSString *showCityMsg;

@end
