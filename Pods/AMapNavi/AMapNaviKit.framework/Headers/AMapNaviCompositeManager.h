//
//  AMapNaviManager.h
//  AMapNaviKit
//
//  Created by eidan on 2017/5/9.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "AMapNaviCommonObj.h"

@class AMapNaviRoute;
@class AMapNaviLocation;

@protocol AMapNaviCompositeManagerDelegate;

///导航SDK综合管理类 since 5.1.0 注意：AMapNaviCompositeManager 不支持多实例，且不能和 AMapNaviDriveManager 同时实例化
@interface AMapNaviCompositeManager : NSObject

///实现了 AMapNaviCompositeManagerDelegate 协议的类指针
@property (nonatomic, weak, nullable) id<AMapNaviCompositeManagerDelegate>delegate;

///当前选择或者导航路径的ID
@property (nonatomic, readonly) NSInteger naviRouteID;

///当前选择或者导航路径的信息,参考 AMapNaviRoute 类.
@property (nonatomic, readonly, nullable) AMapNaviRoute *naviRoute;

///路径规划后的所有路径ID,路径ID为 NSInteger 类型.
@property (nonatomic, readonly, nullable) NSArray<NSNumber *> *naviRouteIDs;

///路径规划后的所有路径信息,参考 AMapNaviRoute 类.
@property (nonatomic, readonly, nullable) NSDictionary<NSNumber *, AMapNaviRoute *> *naviRoutes;

/**
 * @brief 通过present的方式显示路线规划页面
 * @param options为预留参数，目前并无实际作用，需传入nil
 */
- (void)presentRoutePlanViewControllerWithOptions:(id _Nullable)options;

@end

///AMapNaviCompositeManagerDelegate 协议 since 5.1.0
@protocol AMapNaviCompositeManagerDelegate <NSObject>

@optional

/**
 * @brief 发生错误时,会调用此方法
 * @param compositeManager 导航SDK综合管理类
 * @param error 错误信息
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager error:(NSError *_Nonnull)error;

/**
 * @brief 算路成功后的回调函数,路径规划页面的算路、导航页面的重算等成功后均会调用此方法
 * @param compositeManager 导航SDK综合管理类
 */
- (void)compositeManagerOnCalculateRouteSuccess:(AMapNaviCompositeManager *_Nonnull)compositeManager;

/**
 * @brief 算路失败后的回调函数,路径规划页面的算路、导航页面的重算等失败后均会调用此方法
 * @param compositeManager 导航SDK综合管理类
 * @param error 错误信息,error.code参照 AMapNaviCalcRouteState .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager onCalculateRouteFailure:(NSError *_Nonnull)error;

/**
 * @brief 开始导航的回调函数
 * @param compositeManager 导航SDK综合管理类
 * @param naviMode 导航类型，参考 AMapNaviMode .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager didStartNavi:(AMapNaviMode)naviMode;

/**
 * @brief SDK需要实时的获取是否正在进行导航信息播报，以便SDK内部控制 "导航播报信息回调函数" 的触发时机，避免出现下一句话打断前一句话的情况. 如果需要自定义"导航语音播报"功能，必须实现此代理
 * @param compositeManager 导航SDK综合管理类
 * @return 返回当前是否正在进行导航信息播报,如一直返回YES，"导航播报信息回调函数"就一直不会触发，如一直返回NO，就会出现语句打断情况，所以请根据实际情况返回。
 */
- (BOOL)compositeManagerIsNaviSoundPlaying:(AMapNaviCompositeManager *_Nonnull)compositeManager;

/**
 * @brief 导航播报信息回调函数,此回调函数需要和compositeManagerIsNaviSoundPlaying:配合使用. 如果需要自定义"导航语音播报"功能，必须实现此代理
 * @param compositeManager 导航SDK综合管理类
 * @param soundString 播报文字
 * @param soundStringType 播报类型,参考 AMapNaviSoundType .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager playNaviSoundString:(NSString *_Nullable)soundString soundStringType:(AMapNaviSoundType)soundStringType;

/**
 * @brief 停止导航语音播报的回调函数，当导航SDK需要停止外部语音播报时，会调用此方法. 如果需要自定义"导航语音播报"功能，必须实现此代理
 * @param compositeManager 导航SDK综合管理类
 */
- (void)compositeManagerStopPlayNaviSound:(AMapNaviCompositeManager *_Nonnull)compositeManager;

/**
 * @brief 当前位置更新回调
 * @param compositeManager 导航SDK综合管理类
 * @param naviLocation 当前位置信息,参考 AMapNaviLocation 类
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager updateNaviLocation:(AMapNaviLocation *_Nullable)naviLocation;

/**
 * @brief 导航到达目的地后的回调函数
 * @param compositeManager 导航SDK综合管理类
 * @param naviMode 导航类型，参考 AMapNaviMode .
 */
- (void)compositeManager:(AMapNaviCompositeManager *_Nonnull)compositeManager didArrivedDestination:(AMapNaviMode)naviMode;

@end

