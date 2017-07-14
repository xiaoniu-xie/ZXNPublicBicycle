//
//  ZXNBicycleToNaviController.h
//  ZXNPublicBicycle
//
//  Created by 张小牛 on 2017/7/13.
//  Copyright © 2017年 ZXN. All rights reserved.
//

#import "ZXNRootController.h"

@interface ZXNBicycleToNaviController : ZXNRootController

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic, strong) AMapNaviWalkManager *js_walkManager;


@end
