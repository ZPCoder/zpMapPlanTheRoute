//
//  MapDetailViewController.m
//  WonderfulTime
//
//  Created by 朱鹏 on 2017/1/7.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "MapDetailViewController.h"
#import "ZPAnnotation.h"
#import "LineDashPolyline.h"
#import "MANaviAnnotation.h"
#import "MANaviPolyline.h"
#import "MANaviRoute.h"
#import <MAMapKit/MAMapKit.h>
#import "ErrorInfoUtility.h"

static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;
@interface MapDetailViewController ()<MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)UIButton *selfLocation;
@property (nonatomic,strong)ZPAnnotation *zpannotation;
@property (nonatomic,strong)UILabel *adressLabel;
@property (nonatomic,strong)UILabel *shopTitleLabel;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CLLocationManager *locationManager;
/* 当前路线方案索引值. */
@property (nonatomic) NSInteger currentCourse;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;
@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;
@property (nonatomic,strong) UIView *contentView;//显示数据
@property (nonatomic,assign) NSInteger contentViewType;//显示类型

@end

@implementation MapDetailViewController
-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, autoScaleH(75), kScreenWidth, kScreenHeight*0.4-autoScaleH(75))];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate =self;
          _tableView.dataSource = self;
         _tableView.delaysContentTouches = NO;
        if ([UIDevice currentDevice].systemVersion.intValue >= 8) {
            for (UIView *currentView in _tableView.subviews) {
                if ([currentView isKindOfClass:[UIScrollView class]]) {
                    ((UIScrollView *)currentView).delaysContentTouches = NO;
                    break;
                }
            }
        }
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"MapSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"MapSearchTableViewCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    return _tableView;
}
-(ZPAnnotation *)zpannotation{
    
    if (!_zpannotation) {
        _zpannotation = [[ZPAnnotation alloc]init];
    }
    return _zpannotation;
    
}

-(MAMapView *)mapView{
    
    if (!_mapView) {
        
        _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
        
        //   MKMapTypeStandard  标准地图
        _mapView.userTrackingMode=MAUserTrackingModeNone;
        
        _mapView.mapType=MAMapTypeStandard;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //设置代理
        _mapView.delegate=self;
        [_mapView addSubview:self.selfLocation];
//        [_mapView addAnnotation:self.zpannotation];
        
        
    }
    return _mapView;
}


-(UIButton *)selfLocation{
    
    if (!_selfLocation) {
        _selfLocation = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _selfLocation.frame = CGRectMake(kScreenWidth*0.8734, kScreenHeight*0.017, kScreenWidth*0.088,kScreenWidth*0.088 );
        
        [_selfLocation setBackgroundImage:[UIImage imageNamed:@"矩形-1@3x"] forState:(UIControlStateNormal)];
        [_selfLocation addTarget:self action:@selector(selfLocationAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _selfLocation;
}

-(UILabel *)adressLabel{
    
    if (!_adressLabel) {
        _adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.0386, kScreenHeight*(0.885-0.828), kScreenWidth, autoScaleH(20))];
                _adressLabel.textColor = kGrayColor;
        _adressLabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
        _adressLabel.text = self.descStr;
    }
    
    return _adressLabel;
    
}

-(UILabel *)shopTitleLabel{
    
    if (!_shopTitleLabel) {
        
        _shopTitleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(kScreenWidth * 0.0386, kScreenHeight*(0.025), kScreenWidth, autoScaleH(20))];
        _shopTitleLabel.font = [UIFont systemFontOfSize:autoScaleW(18)];
        _shopTitleLabel.text =self.titleStr;
    }
    
    return _shopTitleLabel;
    
}

-(UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-autoScaleH(70), kScreenWidth, autoScaleH(70))];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.shadowOpacity =0.3;
        _contentView.layer.shadowOffset =CGSizeMake(2, 2);
        [_contentView addSubview:self.shopTitleLabel];
        [_contentView addSubview:self.adressLabel];
        //添加箭头
        UIImageView *jiantouImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*0.5-autoScaleW(5), autoScaleH(5), autoScaleW(10), autoScaleH(10))];
        jiantouImageView.image = [UIImage imageNamed:@"上下"];
        [_contentView addSubview:jiantouImageView];
        //添加横线
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.0386, autoScaleH(70), kScreenWidth*(1-0.0386*2), 0.5)];
        lineLabel.backgroundColor = kGrayColor;
        [_contentView addSubview:lineLabel];
        [_contentView addSubview:self.tableView];
        //添加上下按钮
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        btn.frame = CGRectMake(kScreenWidth*0.5-autoScaleW(20), 0, autoScaleW(40), autoScaleH(20));
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth =1;
        btn.layer.cornerRadius = autoScaleW(4);
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        [btn addTarget:self action:@selector(contentViewBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_contentView addSubview:btn];
        
        //添加亲扫手势
        UIPanGestureRecognizer *swipe =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
        //    扫动方向 (枚举值)
//        swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
//            [_contentView addGestureRecognizer:swipe];
        swipe.delegate =self;

        
    }
    return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.zpannotation.coordinate = self.shopCoordinate;
    CLLocationManager *locationManager=[[CLLocationManager alloc]init];
    self.locationManager=locationManager;
    //请求授权
    [locationManager requestWhenInUseAuthorization];
    [self.view addSubview:self.mapView];
    
    
    //返回按钮
    UIButton *shopBackBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [shopBackBtn setImage:[[UIImage imageNamed:@"形状-1"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    shopBackBtn.frame =  CGRectMake(0,kScreenHeight*0.017, kScreenWidth*0.13, kScreenHeight*0.050);
    [shopBackBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:shopBackBtn];
    [self prefersStatusBarHidden];
    [self addDefaultAnnotations];
    [self presentCurrentCourse];
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

-(void)laterShowVIewAnimation{
    
    /* 缩放地图使其适应polylines的展示. */
    
    [self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.frame =CGRectMake(0, kScreenHeight*0.6, kScreenWidth, kScreenHeight*0.4);
        
    }];
    self.contentViewType = 1;
    
}

//自身位置
-(void)selfLocationAction:(UIButton *)sender{
    
    MACoordinateSpan span=MACoordinateSpanMake(0.021251, 0.016093);
     [self.mapView setRegion:MACoordinateRegionMake(self.selfCoorDinate, span) animated:YES];
   
}

-(void)contentViewBtnAction:(UIButton *)sender{
    
    if (self.contentViewType == 1) {
        self.contentViewType =0;
        [UIView animateWithDuration:0.4 animations:^{
            self.contentView.frame =CGRectMake(0, kScreenHeight-autoScaleH(70), kScreenWidth, autoScaleH(70));
            
        }];
        
    }else{
        
        self.contentViewType =1;
        [UIView animateWithDuration:0.4 animations:^{
            self.contentView.frame =CGRectMake(0, kScreenHeight*0.6, kScreenWidth, kScreenHeight*0.4);
            
        }];
    }
    
    
}

-(void)swipeAction:(UIPanGestureRecognizer *)sender{
 
    
//    得到手势所作用的视图
    UIView *myView =[sender view];
    //    得到手势的偏移量
    CGPoint movePoint =[sender translationInView:myView];
    
     myView.transform =CGAffineTransformTranslate(myView.transform, 0, movePoint.y);
    
    if (self.contentViewType == 1 ) {
        self.contentViewType =0;
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.frame =CGRectMake(0, kScreenHeight-autoScaleH(70), kScreenWidth, autoScaleH(70));
            
        }];
        
    }else{
        self.contentViewType =1;
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.frame =CGRectMake(0, kScreenHeight*0.6, kScreenWidth, kScreenHeight*0.4);
            
        }];
    }
    
    
}
//跟踪到用户位置时会调用该方法
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    self.selfCoorDinate =userLocation.coordinate;

   }


/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    switch (self.type) {
        case 1:
        {
           self.naviRoute = [MANaviRoute naviRouteForTransit:self.transit startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
            
        }
            break;
        case 2:
        {
            MANaviAnnotationType type = MANaviAnnotationTypeDrive;
            self.naviRoute = [MANaviRoute naviRouteForPath:self.path withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
            
        }
            break;
        case 3:
        {
         
            MANaviAnnotationType type = MANaviAnnotationTypeWalking;
            self.naviRoute = [MANaviRoute naviRouteForPath:self.path withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
            
           
        }
            break;
        default:
            break;
    }

    [self.naviRoute addToMapView:self.mapView];
     [self.mapView addSubview:self.contentView];

    [self performSelector:@selector(laterShowVIewAnimation) withObject:nil afterDelay:1.5];
    
   
}


#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashPattern = @[@10, @15];
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeDrive)
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }else{
            polylineRenderer.strokeColor = RGBColor(120, 128, 229);
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 8;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    
    return nil;
    
}

//设置大头针样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"地铁"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"walk"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"起点"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"终点"];
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}
//添加起、终点图标
- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.selfLocationCoordinate;
    startAnnotation.title      = (NSString *)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle   = self.startName;
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destensCoordinate;
    destinationAnnotation.title      = (NSString *)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = self.destensName;
    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}


#pragma mark - 表视图

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type ==1) {
        return self.transit.segments.count;
 
    }else{
        return self.path.steps.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.textLabel.text =[self titleForIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];
    [cell.textLabel sizeToFit];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font= [UIFont systemFontOfSize:autoScaleW(13)];
    cell.textLabel.text =[self titleForIndexPath:indexPath];
    cell.imageView.image = [self imageForIndexPath:indexPath];
    cell.textLabel.text =[self titleForIndexPath:indexPath];
    cell.imageView.image = [self imageForIndexPath:indexPath];
    return cell;
    
}

-(UIImage *)imageForIndexPath:(NSIndexPath *)indexPath{
    
    UIImage *image = nil;
    if (self.type ==1) {
        AMapSegment *segment = self.transit.segments[indexPath.row];
        AMapRailway *railway = segment.railway;
        AMapTaxi *taxi = segment.taxi;
        AMapBusLine *busline = [segment.buslines firstObject];
        
        if (railway.uid)
        {
            image = [UIImage imageNamed:@"地铁"];
            
        }
        else if (busline)
        {
            image = [UIImage imageNamed:@"bus"];
            
        }
        else if (taxi)
        {
            image = [UIImage imageNamed:@"car"];
        }
        else
        {
            image = [UIImage imageNamed:@"walk"];
            
        }
      
    }else if(self.type ==2 ){
        
         image = [UIImage imageNamed:@"car"];
    }else{
        
        image = [UIImage imageNamed:@"walk"];

    }
    
    
    
    return image;

    
}


- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = nil;
    if (self.type ==1) {
        AMapSegment *segment = self.transit.segments[indexPath.row];
        
        AMapRailway *railway = segment.railway;
        AMapTaxi *taxi = segment.taxi;
        AMapBusLine *busline = [segment.buslines firstObject];
        AMapWalking *walk = segment.walking;
        if (railway.uid)
        {
            //            title = railway.name;
            title = [NSString stringWithFormat:@"乘坐%@，在%@上车，经过%ld站，到达%@下车",railway.name,railway.departureStation.name,railway.viaStops.count,railway.arrivalStation.name];
        }
        else if (busline)
        {
            
            title = [NSString stringWithFormat:@"乘坐%@，在%@上车，经过%ld站，到达%@下车",busline.name,busline.departureStop.name,busline.viaBusStops.count,busline.arrivalStop.name];
        }
        else if (taxi)
        {
            title = [NSString stringWithFormat:@"乘坐出租车，在%@上车，途经%ld米，大约%ld分钟，到达%@下车",taxi.sname,taxi.distance,taxi.duration/60,taxi.tname];
        }
        else
        {
            for (int i = 0; i<walk.steps.count; i++) {
                
                if (i ==0) {
                    title = walk.steps[i].instruction;
                }else{
                    title = [NSString stringWithFormat:@"%@,%@",title,walk.steps[i].instruction];
                }
                
            }
            
        }
        

    }else{
        AMapStep *step = self.path.steps[indexPath.row];
        
        title = step.instruction;
    }
    
    return title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
