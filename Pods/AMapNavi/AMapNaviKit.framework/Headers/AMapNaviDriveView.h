//
//  AMapNaviDriveView.h
//  AMapNaviKit
//
//  Created by AutoNavi on 15/12/28.
//  Copyright © 2016年 Amap. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "AMapNaviCommonObj.h"
#import "AMapNaviDriveDataRepresentable.h"
#import "AMapNaviRoutePolylineOption.h"

NS_ASSUME_NONNULL_BEGIN

///驾车导航界面显示模式
typedef NS_ENUM(NSInteger, AMapNaviDriveViewShowMode)
{
    AMapNaviDriveViewShowModeCarPositionLocked = 1, ///< 锁车状态
    AMapNaviDriveViewShowModeOverview = 2,          ///< 全览状态
    AMapNaviDriveViewShowModeNormal = 3,            ///< 普通状态
};

@protocol AMapNaviDriveViewDelegate;

///驾车导航界面.该类实现AMapNaviDriveDataRepresentable协议,可通过 AMapNaviDriveManager 的addDataRepresentative:方法进行注册展示驾车导航过程.
@interface AMapNaviDriveView : UIView<AMapNaviDriveDataRepresentable>

#pragma mark - Delegate

///实现了 AMapNaviDriveViewDelegate 协议的类指针
@property (nonatomic, weak) id<AMapNaviDriveViewDelegate> delegate;

#pragma mark - Options

///是否采用横屏布局,默认NO
@property (nonatomic, assign) BOOL isLandscape;

///导航界面跟随模式,默认AMapNaviViewTrackingModeMapNorth
@property (nonatomic, assign) AMapNaviViewTrackingMode trackingMode;

///导航界面显示模式,默认AMapNaviDriveViewShowModeCarPositionLocked
@property (nonatomic, assign) AMapNaviDriveViewShowMode showMode;

///是否显示界面元素,默认YES
@property (nonatomic, assign) BOOL showUIElements;

///是否显示摄像头,默认YES
@property (nonatomic, assign) BOOL showCamera;

///是否显示路口放大图,默认YES
@property (nonatomic, assign) BOOL showCrossImage;

///是否黑夜模式,默认NO. 对应的地图样式为:白天模式MAMapTypeNavi,黑夜模式MAMapTypeStandardNight.
@property (nonatomic, assign) BOOL showStandardNightType;

///是否显示全览按钮,默认YES
@property (nonatomic, assign) BOOL showBrowseRouteButton;

///是否显示更多按钮,默认YES
@property (nonatomic, assign) BOOL showMoreButton;

///是否显示路况光柱,默认YES
@property (nonatomic, assign) BOOL showTrafficBar;

///是否显示实时交通按钮,默认YES
@property (nonatomic, assign) BOOL showTrafficButton;

///是否显示实时交通图层,默认YES
@property (nonatomic, assign) BOOL showTrafficLayer;

///是否显示转向箭头,默认YES
@property (nonatomic, assign) BOOL showTurnArrow;

#pragma mark - MapView

///是否显示指南针,默认NO
@property (nonatomic, assign) BOOL showCompass;

///锁车状态下地图cameraDegree, 默认30.0, 范围[0,60]
@property (nonatomic, assign) CGFloat cameraDegree;

///当前地图的zoomLevel，修改zoomLevel会进入非锁车状态
@property (nonatomic, assign) CGFloat mapZoomLevel;

///当前地图是否显示比例尺，默认NO
@property (nonatomic, assign) BOOL showScale;

///当前地图比例尺的原点位置，默认(10,10)
@property (nonatomic, assign) CGPoint scaleOrigin;

///当前地图是否开启自定义样式, 默认NO. 设置为YES，将忽略showStandardNightType的设置，并将mapType切换为MAMapTypeStandard. 设置为NO，将根据showStandardNightType恢复mapType. since 5.1.0
@property (nonatomic, assign) BOOL customMapStyleEnabled;

/**
 * @brief 自定义当前地图样式, 目前仅支持自定义标准类型. 默认不生效，调用customMapStyleEnabled=YES使生效. since 5.1.0
 * @param customJson 自定义的JSON格式数据.
 */
- (void)setCustomMapStyle:(NSData *)customJson;

/**
 * @brief 根据web导出数据设置地图样式, 目前仅支持自定义标准类型. 默认不生效，调用customMapStyleEnabled=YES使生效. since 5.1.0
 * @param data 高德web端工具导出的地图样式数据.
 */
- (void)setCustomMapStyleWithWebData:(NSData*)data;

///自定义导航界面自车图标的弹出框view, 设置为nil取消弹框. 注意:弹框功能同MAAnnotationView的customCalloutView, 弹框不会触发 mapView:didAnnotationViewCalloutTapped: 方法. since 5.1.0
@property (nonatomic, strong, nullable) MACustomCalloutView *customCalloutView;

#pragma mark - Polyline Texture

///路线polyline的宽度,设置0恢复默认宽度
@property (nonatomic, assign) CGFloat lineWidth;

///路线polyline的虚线部分宽度,设置0恢复默认宽度
@property (nonatomic, assign) CGFloat dashedLineWidth;

///标准路线Polyline的纹理图片,设置nil恢复默认纹理.纹理图片需满足：长宽相等，且宽度值为2的次幂
@property (nonatomic, copy, nullable) UIImage *normalTexture;

/**
 * @brief 带路况路线Polyline的纹理图片
 *
 *  纹理图片需满足: 长宽相等,且宽度值为2的次幂
 *
 *  例如:@{@(AMapNaviRouteStatusSlow): [UIImage Slow路况下的Image],
 *        @(AMapNaviRouteStatusSeriousJam): [UIImage SeriousJam路况下的Image]}
 *
 *  设置空字典恢复默认纹理,例如: @{}
 */
@property (nonatomic, copy) NSDictionary<NSNumber *, UIImage *> *statusTextures;

#pragma mark - Image

/**
 * @brief 设置摄像头图标
 * @param cameraImage 摄像头图标,设置nil为默认图标
 */
- (void)setCameraImage:(nullable UIImage *)cameraImage;

/**
 * @brief 设置路径起点图标
 * @param startPointImage 起点图标,设置nil为默认图标
 */
- (void)setStartPointImage:(nullable UIImage *)startPointImage;

/**
 * @brief 设置路径途经点图标
 * @param wayPointImage 途经点图标,设置nil为默认图标
 */
- (void)setWayPointImage:(nullable UIImage *)wayPointImage;

/**
 * @brief 设置路径终点图标
 * @param endPointImage 终点图标,设置nil为默认图标
 */
- (void)setEndPointImage:(nullable UIImage *)endPointImage;

/**
 * @brief 设置自车图标
 * @param carImage 自车图标,设置nil为默认图标
 */
- (void)setCarImage:(nullable UIImage *)carImage;

/**
 * @brief 设置自车罗盘图标
 * @param carCompassImage 自车罗盘图标,设置nil为默认图标
 */
- (void)setCarCompassImage:(nullable UIImage *)carCompassImage;

@end

@protocol AMapNaviDriveViewDelegate <NSObject>
@optional

/**
 * @brief 导航界面关闭按钮点击时的回调函数
 * @param driveView 驾车导航界面
 */
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView;

/**
 * @brief 导航界面更多按钮点击时的回调函数
 * @param driveView 驾车导航界面
 */
- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView;

/**
 * @brief 导航界面转向指示View点击时的回调函数
 * @param driveView 驾车导航界面
 */
- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView;

/**
 * @brief 导航界面显示模式改变后的回调函数
 * @param driveView 驾车导航界面
 * @param showMode 显示模式
 */
- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode;

/**
 * @brief 获取导航界面上路线显示样式的回调函数
 * @param driveView 驾车导航界面
 * @param naviRoute 当前界面的路线信息
 * @return AMapNaviRoutePolylineOption 路线显示样式
 */
- (AMapNaviRoutePolylineOption *)driveView:(AMapNaviDriveView *)driveView needUpdatePolylineOptionForRoute:(AMapNaviRoute *)naviRoute;

@end

NS_ASSUME_NONNULL_END
