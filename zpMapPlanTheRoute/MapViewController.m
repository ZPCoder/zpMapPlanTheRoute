//
//  MapViewController.m
//  WonderfulTime
//
//  Created by 朱鹏 on 2017/1/5.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "SearchRoudViewController.h"
@interface MapViewController ()<MKMapViewDelegate>
@property (nonatomic,strong)MKMapView *mapView;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong)UIButton *selfLocation;
@property (nonatomic,strong)UIImageView *backView;
@property (nonatomic,strong)UILabel *adressLabel;
@property (nonatomic,strong)UIButton *routeBtn;
@property (nonatomic,strong)UIButton *localMapBtn;
@property (nonatomic,strong)UILabel *shopTitleLabel;
@property (nonatomic,strong)ZPAnnotation *zpannotation;

@end

@implementation MapViewController



-(ZPAnnotation *)zpannotation{
    
    if (!_zpannotation) {
        _zpannotation = [[ZPAnnotation alloc]init];
    }
    return _zpannotation;
    
}

-(MKMapView *)mapView{
    
    if (!_mapView) {
        
        _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
        
        //   MKMapTypeStandard  标准地图
        _mapView.userTrackingMode=MKUserTrackingModeFollow;
        
        _mapView.mapType=MKMapTypeStandard;
        //实时显示交通路况
//        _mapView.showsTraffic=YES;
        //设置代理
        _mapView.delegate=self;
        [_mapView addSubview:self.backBtn];
        [_mapView addSubview:self.selfLocation];
        [_mapView addAnnotation:self.zpannotation];
        [_mapView addSubview:self.backView];
        //定位到商户位置
        MKCoordinateSpan span=MKCoordinateSpanMake(0.021251, 0.016093);
        
        [_mapView setRegion:MKCoordinateRegionMake(self.shopCoordinate, span) animated:NO];
       
    }
    return _mapView;
}




-(UIButton *)selfLocation{
    
    if (!_selfLocation) {
        _selfLocation = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _selfLocation.frame = CGRectMake(kScreenWidth*0.0386, kScreenHeight*0.763, kScreenWidth*0.088,kScreenWidth*0.088 );
       
        [_selfLocation setBackgroundImage:[UIImage imageNamed:@"矩形-1"] forState:(UIControlStateNormal)];
        [_selfLocation addTarget:self action:@selector(selfLocationAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _selfLocation;
}

-(UIImageView *)backView{
    
    if (!_backView) {
        
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.828, kScreenWidth, kScreenHeight*(1-0.828))];
        _backView.backgroundColor = kPinkColor;
        _backView.userInteractionEnabled = YES;
        [_backView addSubview:self.adressLabel];
        [_backView addSubview:self.shopTitleLabel];
        [_backView addSubview:self.routeBtn];
        [_backView addSubview:self.localMapBtn];
    
    }
    
    return _backView;
    
}

-(UILabel *)adressLabel{
    
    if (!_adressLabel) {
        _adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.0386, kScreenHeight*(0.885-0.828), kScreenWidth, autoScaleH(20))];
        _adressLabel.textColor = [UIColor whiteColor];
        _adressLabel.font = [UIFont systemFontOfSize:autoScaleW(14)];
        _adressLabel.text = self.addressStr;
    }
    
    return _adressLabel;
}

-(UILabel *)shopTitleLabel{
    
    if (!_shopTitleLabel) {
        
        _shopTitleLabel = [[UILabel  alloc]initWithFrame:CGRectMake(kScreenWidth * 0.0386, kScreenHeight*(0.850-0.828), kScreenWidth, autoScaleH(20))];
        _shopTitleLabel.font = [UIFont systemFontOfSize:autoScaleW(18)];
        _shopTitleLabel.text =self.shopTitleStr;
        _shopTitleLabel.textColor = [UIColor whiteColor];
    }
  
    return _shopTitleLabel;
    
}

-(UIButton *)routeBtn{
    
    if (!_routeBtn) {
        _routeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _routeBtn.frame = CGRectMake(kScreenWidth*0.138, kScreenHeight*(0.932-0.828), kScreenWidth*0.293, kScreenHeight*0.052);
        [_routeBtn setBackgroundImage:[UIImage imageNamed:@"查看路线"] forState:(UIControlStateNormal)];
        [_routeBtn addTarget:self action:@selector(routBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _routeBtn;
}
-(UIButton *)localMapBtn{
    
    if (!_localMapBtn) {
        _localMapBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _localMapBtn.frame = CGRectMake(kScreenWidth*0.569, kScreenHeight*(0.932-0.828), kScreenWidth*0.293, kScreenHeight*0.052);
       [_localMapBtn setBackgroundImage:[UIImage imageNamed:@"本机地图"] forState:(UIControlStateNormal)];
        [_localMapBtn addTarget:self action:@selector(localMapBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _localMapBtn;
}


#pragma mark - 页面开始加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.zpannotation.coordinate = self.shopCoordinate;
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


}
- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}



#pragma mark - 按钮的点击事件

//路径规划
-(void)routBtnAction:(UIButton *)sender{
    
    SearchRoudViewController *searchRoudVC = [[SearchRoudViewController alloc]init];
    searchRoudVC.shopName = self.shopTitleStr;
    searchRoudVC.selfLocationCoordinate = self.selfCoorDinate;
    searchRoudVC.destensCoordinate = self.shopCoordinate;
    [self presentViewControllerWithVC:searchRoudVC animated:YES];
    
    
}

//自身位置
-(void)selfLocationAction:(UIButton *)sender{
    
    MKCoordinateSpan span=MKCoordinateSpanMake(0.021251, 0.016093);
    
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span) animated:YES];
    
}
//本机地图
-(void)localMapBtnAction:(UIButton *)sender{
    
    //起点
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.selfCoorDinate addressDictionary:nil]];
    currentLocation.name = @"我的位置";
    //目的地的位置
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.shopCoordinate addressDictionary:nil]];
    
    
    toLocation.name =self.shopTitleStr;
    
    
    NSArray *items = [NSArray arrayWithObjects:currentLocation, toLocation, nil];
    
    NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES};
    
    //打开苹果自身地图应用，并呈现特定的item
    
    [MKMapItem openMapsWithItems:items launchOptions:options];
    
    
}

//跟踪到用户位置时会调用该方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    self.selfCoorDinate =userLocation.coordinate;
    
 
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    

}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    //    判断是不是用户的大头针数据模型
    if ([annotation isKindOfClass:[ZPAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:_zpannotation reuseIdentifier:@"商铺定位"];
        annotationView.image = [UIImage imageNamed:@"商铺定位"];
        

        return annotationView;
    }
    
 
    return nil;
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
