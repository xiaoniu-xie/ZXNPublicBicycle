//
//  ZXNPublicBicycleController.m
//  ZXNPublicBicycle
//
//  Created by 张小牛 on 2017/7/13.
//  Copyright © 2017年 ZXN. All rights reserved.
//

#define showViewHeight 210

#import "ZXNPublicBicycleController.h"
#import "JSBikeShowView.h"
#import "SelectableOverlay.h"
#import "ZXNLocationGaoDeManager.h"
#import "JSCenterAnnotation.h"
#import "ZXNBicycleToNaviController.h"

@interface ZXNPublicBicycleController ()<MAMapViewDelegate,AMapNaviWalkManagerDelegate>{
    NSMutableArray *all_arrayList;
    ZXNLocationGaoDeManager *currentPosition;
    
    BOOL isShowView;//上部自行车信息框弹出
    BOOL isMoveView;//是否移动地图
    CLLocationCoordinate2D currentCoordinate;
    
    JSCenterAnnotation *centerAnnotaion;
    MAAnnotationView *centerAnnoView;
    
    AMapNaviWalkManager *js_walkManager;
}

@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) JSBikeShowView *showView;
@property (nonatomic,strong) UIButton *btn_local;
@property (nonatomic,assign) CLLocationCoordinate2D startCoordinate;
@property (nonatomic,assign) CLLocationCoordinate2D endCoordinate;


@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@end

@implementation ZXNPublicBicycleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近自行车点";
    [self setUpData];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    js_walkManager.delegate = self;
}
- (void)setUpData{
    all_arrayList = [[NSMutableArray alloc]init];
    
    CLLocationCoordinate2D coor;
    coor.longitude = [self.show_longitude doubleValue];
    coor.latitude = [self.show_latitude doubleValue];
    currentCoordinate = coor;
    
    isMoveView = YES;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nearBicycle" ofType:@"json"]];
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSArray *result = dataDict[@"bicyles"];
    [all_arrayList addObjectsFromArray:result];
    
}
- (void)setUpView{
    ///初始化地图
    self.mapView = [[MAMapView alloc] init];
    ///把地图添加至view
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.mapView.delegate = self;
    self.mapView.zoomLevel = 15;
    self.mapView.showsUserLocation = true;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    [self.mapView addAnnotation:centerAnnotaion];
    [self addAnnotations];
    
    MAUserLocationRepresentation *localPoint = [[MAUserLocationRepresentation alloc] init];
    localPoint.showsHeadingIndicator = YES;
    [self.mapView updateUserLocationRepresentation:localPoint];
    //初始化步行导航
    js_walkManager = [[AMapNaviWalkManager alloc]init];
    js_walkManager.delegate = self;
    
    self.btn_local = [[UIButton alloc]init];
    [self.btn_local setImage:[UIImage imageNamed:@"nav_orientation"] forState:0];
    [self.btn_local addTarget:self action:@selector(local) forControlEvents:1 <<  6];
    [self.view addSubview:self.btn_local];
    [self.btn_local mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.bottom.equalTo(@-16);
    }];
    
}

- (void)local{
    //    centerAnnotaion.coordinate = currentCoordinate;
    self.mapView.showsUserLocation = true;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

#pragma mark - 添加大头针和动画
//添加大头针
- (void)addAnnotations{
    NSMutableArray *array_annotations = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in all_arrayList) {
        MAPointAnnotation *annotation =  [[MAPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake([dict[@"gLat" ] doubleValue], [dict[@"gLng"] doubleValue]);
        annotation.title = dict[@"name"];
        annotation.subtitle = [NSString stringWithFormat:@"%@|%@",dict[@"availTotal"],dict[@"emptyTotal"]];
        [array_annotations addObject:annotation];
    }
    [self.mapView addAnnotations:array_annotations];
}


#pragma mark - mapViewDelete
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{
    if (!isMoveView) {
        //不能移动
        centerAnnotaion.lockedToScreen = NO;
    }else{
        centerAnnotaion.lockedToScreen = YES;
    }
}

- (void)mapInitComplete:(MAMapView *)mapView{
    centerAnnotaion = [[JSCenterAnnotation alloc]init];
    centerAnnotaion.coordinate = currentCoordinate;//self.mapView.centerCoordinate;
    centerAnnotaion.lockedScreenPoint = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    centerAnnotaion.lockedToScreen = YES;
    //
    [self.mapView addAnnotation:centerAnnotaion];
    [self.mapView showAnnotations:@[centerAnnotaion] animated:YES];
}
//加载大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation{
    
    if ([annotation isMemberOfClass:[MAUserLocation class]]) {
        
        return nil;
    }
    
    if ([annotation isMemberOfClass:[JSCenterAnnotation class]]) {
        static NSString *reuseCneterid = @"myCenterId";
        MAAnnotationView *annotationView= [self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseCneterid];
        if (!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:reuseCneterid];
        }
        annotationView.image = [UIImage imageNamed:@"homePage_wholeAnchor"];
        annotationView.canShowCallout = NO;
        centerAnnoView = annotationView;
        return annotationView;
    }
    
    static NSString *reuseid = @"myId";
    
    MAAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseid];
    if (!annotationView) {
        annotationView = [[MAAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:reuseid];
    }
    
    annotationView.image = [UIImage imageNamed:@"fixed_point_one_normal"];
    //    annotationView.canShowCallout = YES;
    return annotationView;
}
//单击地图
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    if (isShowView) {
        [self.showView setHidden:YES];
        [self.btn_local setHidden:NO];
    }
    
    self.mapView.zoomLevel = 15;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    
    [self addAnnotations];
    [self.mapView addAnnotation:centerAnnotaion];
    
    isMoveView = YES;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
    if ([view.annotation isMemberOfClass:[MAUserLocation class]]) {
        
        return;
    }
    
    if ([view.annotation isMemberOfClass:[JSCenterAnnotation class]]) {
        
        return;
    }
    
    isMoveView = NO;
    
    //记录下点击的经纬度
    NSString *didAddress = view.annotation.title;
    
    if (!self.showView) {
        self.showView = [[JSBikeShowView alloc]initWithFrame:CGRectZero];
        self.showView.backgroundColor = [UIColor whiteColor];
        self.showView.alpha = 0.9;
        [self.view addSubview:self.showView];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.showView.frame = CGRectMake(0, 64, boundWidth, 0);
        } completion:^(BOOL finished) {
            self.showView.frame = CGRectMake(0, 64, boundWidth, showViewHeight);
        }];
    }
    isShowView = YES;
    [self.showView setHidden:NO];
    [self.btn_local setHidden:YES];
    
    ZXNWeakSelf(self)
    self.showView.gotoOtherPlace = ^(){
        [weakself gotoPlace];
    };
    
    self.showView.label_address.text = view.annotation.title;
    NSArray *counts = [view.annotation.subtitle componentsSeparatedByString:@"|"];
    self.showView.label_availTotal.text = counts[0];
    self.showView.label_emptyTotal.text = counts[1];
    
    
    //步行导航
    self.startCoordinate = centerAnnotaion.coordinate;
    self.endCoordinate = view.annotation.coordinate;
    
    self.startPoint = [AMapNaviPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    
    self.endPoint = [AMapNaviPoint locationWithLatitude:self.endCoordinate.latitude longitude:self.endCoordinate.longitude];
    [js_walkManager calculateWalkRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint]];
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSMutableArray *array_annotations = [[NSMutableArray alloc]init];
    [array_annotations addObject:centerAnnotaion];
    
    for (NSDictionary *dict in all_arrayList) {
        MAPointAnnotation *annotation =  [[MAPointAnnotation alloc]init];
        NSLog(@"%@,%@",dict[@"name"],didAddress);
        if ([dict[@"name"] isEqualToString:didAddress]) {
            annotation.coordinate = CLLocationCoordinate2DMake([dict[@"gLat" ] doubleValue], [dict[@"gLng"] doubleValue]);
            annotation.title = dict[@"name"];
            annotation.subtitle = [NSString stringWithFormat:@"%@|%@",dict[@"availTotal"],dict[@"emptyTotal"]];
            [array_annotations addObject:annotation];
        }
        
    }
    
    [self.mapView addAnnotations:array_annotations];
    [self.mapView showAnnotations:array_annotations edgePadding:UIEdgeInsetsMake(300, 100, 50, 100) animated:YES];

}
#pragma mark - AMapNaviWalkManagerDelegate 导航代理

- (void)walkManagerOnCalculateRouteSuccess:(AMapNaviWalkManager *)walkManager{
    
    NSLog(@"步行路线规划成功！");
    
    if (walkManager.naviRoute == nil){
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    //将路径显示到地图上
    AMapNaviRoute *aRoute = walkManager.naviRoute;
    int count = (int)[[aRoute routeCoordinates] count];
    
    //添加路径Polyline
    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < count; i++)
    {
        AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
        coords[i].latitude = [coordinate latitude];
        coords[i].longitude = [coordinate longitude];
    }
    
    MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
    
    SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
    
    [self.mapView addOverlay:selectablePolyline];
    free(coords);
    
    NSString *subtitle = [NSString stringWithFormat:@"长度:%ld米 | 预估时间:%ld秒 | 分段数:%ld", (long)aRoute.routeLength, (long)aRoute.routeTime, (long)aRoute.routeSegments.count];
    NSLog(@"%@",subtitle);
    
    long walkMinute = walkManager.naviRoute.routeTime / 60;
    NSString *timeDesc = @"1分钟以内";
    if (walkMinute > 1){
        timeDesc = [NSString stringWithFormat:@"%ld分钟",walkMinute];
    }
    self.showView.label_minutes.text = timeDesc;
    self.showView.label_distance.text = [NSString stringWithFormat:@"%.1fkm",(float)aRoute.routeLength/1000];
    
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
    
    if ([overlay isKindOfClass:[SelectableOverlay class]])
    {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        
        return polylineRenderer;
    }
    
    return nil;
}
- (void)selecteOverlayWithRouteID:(NSInteger)routeID{
    
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
         if ([overlay isKindOfClass:[SelectableOverlay class]])
         {
             SelectableOverlay *selectableOverlay = overlay;
             
             /* 获取overlay对应的renderer. */
             MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
             
             if (selectableOverlay.routeID == routeID)
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = YES;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                 overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                 
                 /* 修改overlay覆盖的顺序. */
                 [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
             }
             else
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = NO;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.regularColor;
                 overlayRenderer.strokeColor = selectableOverlay.regularColor;
             }
             
             [overlayRenderer glRender];
         }
     }];
}

- (void)gotoPlace{
    ZXNBicycleToNaviController *js = [[ZXNBicycleToNaviController alloc]init];
    js.startPoint = self.startPoint;
    js.endPoint = self.endPoint;
    js.js_walkManager = js_walkManager;
    [self.navigationController pushViewController:js animated:YES];
}
@end
