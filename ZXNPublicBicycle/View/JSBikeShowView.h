//
//  JSBikeShowView.h
//  BothJiangSu
//
//  Created by 张小牛 on 2017/6/6.
//  Copyright © 2017年 BothJiangSu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSBikeShowView : UIView

@property(nonatomic,strong) void(^gotoOtherPlace)();

@property (nonatomic,strong) UILabel *label_address;
@property (nonatomic,strong) UILabel *label_minutes;
@property (nonatomic,strong) UILabel *label_distance;
@property (nonatomic,strong) UILabel *label_availTotal;
@property (nonatomic,strong) UILabel *label_emptyTotal;
@end
