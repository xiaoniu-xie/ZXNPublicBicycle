//
//  ZXNBicycleToNaviController.m
//  ZXNPublicBicycle
//
//  Created by 张小牛 on 2017/7/13.
//  Copyright © 2017年 ZXN. All rights reserved.
//

#import "SpeechSynthesizer.h"
#import "MoreMenuView.h"
#import "ZXNBicycleToNaviController.h"

@interface ZXNBicycleToNaviController ()<AMapNaviWalkManagerDelegate, AMapNaviWalkViewDelegate,MoreMenuViewDelegate>{
    AMapNaviWalkView *js_walkView;
    
    MoreMenuView *js_moreMenu;
}


@end

@implementation ZXNBicycleToNaviController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initWalkView];
    
    [self initWalkManager];
    
    [self initMoreMenu];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self calculateRoute];
}

#pragma mark - Initalization

- (void)initWalkManager{
    if (self.js_walkManager == nil){
        self.js_walkManager = [[AMapNaviWalkManager alloc] init];
    }
    [self.js_walkManager setDelegate:self];
    [self.js_walkManager setAllowsBackgroundLocationUpdates:YES];
    [self.js_walkManager setPausesLocationUpdatesAutomatically:NO];
    
    //将walkView添加为导航数据的Representative，使其可以接收到导航诱导数据
    
    [self.js_walkManager addDataRepresentative:js_walkView];
}

- (void)initWalkView
{
    if (js_walkView == nil)
    {
        js_walkView = [[AMapNaviWalkView alloc] initWithFrame:self.view.bounds];
        js_walkView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [js_walkView setDelegate:self];
        
        [self.view addSubview:js_walkView];
    }
}

- (void)initMoreMenu
{
    if (js_moreMenu == nil)
    {
        js_moreMenu = [[MoreMenuView alloc] init];
        js_moreMenu.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [js_moreMenu setDelegate:self];
    }
}

#pragma mark - Route Plan

- (void)calculateRoute
{
    [self.js_walkManager calculateWalkRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]];
    //进行路径规划
}

#pragma mark - AMapNaviWalkManager Delegate


- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager{
    [self.js_walkManager startGPSNavi];
}
- (BOOL)walkManagerIsNaviSoundPlaying:(AMapNaviWalkManager *)walkManager
{
    return [[SpeechSynthesizer sharedSpeechSynthesizer] isSpeaking];
}


- (void)walkManager:(AMapNaviWalkManager *)walkManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType{
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

#pragma mark - AMapNaviWalkViewDelegate

- (void)walkViewCloseButtonClicked:(AMapNaviWalkView *)walkView
{
    //停止导航
    [self.js_walkManager stopNavi];
    [self.js_walkManager removeDataRepresentative:js_walkView];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)walkViewMoreButtonClicked:(AMapNaviWalkView *)walkView
{
    //配置MoreMenu状态
    [js_moreMenu setTrackingMode:js_walkView.trackingMode];
    [js_moreMenu setShowNightType:js_walkView.showStandardNightType];
    
    [js_moreMenu setFrame:self.view.bounds];
    [self.view addSubview:js_moreMenu];
}


#pragma mark - MoreMenu Delegate

- (void)moreMenuViewFinishButtonClicked
{
    [js_moreMenu removeFromSuperview];
}

- (void)moreMenuViewNightTypeChangeTo:(BOOL)isShowNightType
{
    [js_walkView setShowStandardNightType:isShowNightType];
}

- (void)moreMenuViewTrackingModeChangeTo:(AMapNaviViewTrackingMode)trackingMode
{
    [js_walkView setTrackingMode:trackingMode];
}

@end
