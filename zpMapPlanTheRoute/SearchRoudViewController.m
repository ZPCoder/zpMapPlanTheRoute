//
//  SearchRoudViewController.m
//  WonderfulTime
//
//  Created by 朱鹏 on 2017/1/6.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "SearchRoudViewController.h"
#import "MapSearchTableViewCell.h"
#import "MapDetailViewController.h"

@interface SearchRoudViewController ()<UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>

@property (nonatomic,strong)UIImageView *contentImageView;
@property (nonatomic,strong)UIImageView *signImageView;
@property (nonatomic,strong)UILabel *selfLabel;
@property (nonatomic,strong)UILabel *destensLabel;
@property (nonatomic,strong)UIButton *changeBtn;
@property (nonatomic,strong)UIButton *publicBtn;
@property (nonatomic,strong)UIButton *carBtn;
@property (nonatomic,strong)UIButton *walkBtn;
@property (nonatomic,assign)NSInteger transportType;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)AMapSearchAPI *search;
@property (strong, nonatomic) AMapRoute *route;  //路径规划信息
@property (assign, nonatomic) NSUInteger currentRouteIndex; //当前显示线路的索引值，从0开始
@property (copy, nonatomic) NSArray *routeArray;  //规划的路径数组，collectionView的数据源

@end

@implementation SearchRoudViewController

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, aScaleH(200), kScreenWidth, aScaleH(467))];
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

-(UIImageView *)contentImageView{
    
    if (!_contentImageView) {
        
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, aScaleH(57), kScreenWidth, aScaleH(142))];
        
        _contentImageView.image = [UIImage imageNamed:@"组-4"];
        _contentImageView.backgroundColor = [UIColor whiteColor];
    }
    
    return _contentImageView;
}

-(UIImageView *)signImageView{
    
    if (!_signImageView) {
        _signImageView = [[UIImageView alloc]initWithFrame:CGRectMake(aScaleW(25), aScaleH(79), aScaleW(13), aScaleH(48))];
        _signImageView.image = [UIImage imageNamed:@"查看路线-目的地转换"];
    }
    return _signImageView;
}

-(UILabel *)selfLabel{
    
    if (!_selfLabel) {
        _selfLabel = [[UILabel alloc]initWithFrame:CGRectMake(aScaleW(50), aScaleH(77), aScaleW(200), aScaleH(20))];
        _selfLabel.font = [UIFont systemFontOfSize:autoScaleW(17)];
        _selfLabel.text = @"我的位置";
        
    }
    return _selfLabel;
}

-(UILabel *)destensLabel{
    
    if (!_destensLabel) {
        _destensLabel = [[UILabel alloc]initWithFrame:CGRectMake(aScaleW(50), aScaleH(113), aScaleW(200), aScaleH(20))];
        _destensLabel.font = [UIFont systemFontOfSize:autoScaleW(17)];
        _destensLabel.text = self.shopName;
        
    }
    return _destensLabel;
}
-(UIButton *)changeBtn{
    
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _changeBtn.frame =CGRectMake(aScaleW(339), aScaleH(96), aScaleW(10), aScaleH(14));
        [_changeBtn setBackgroundImage:[UIImage imageNamed:@"查看路线往返转换"] forState:(UIControlStateNormal)];
        [_changeBtn addTarget:self action:@selector(changBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    return _changeBtn;
}
-(UIButton *)publicBtn{
    
    if (!_publicBtn) {
        _publicBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _publicBtn.frame =CGRectMake(aScaleW(85), aScaleH(163), aScaleW(40), aScaleH(20));
        [_publicBtn setBackgroundImage:[UIImage imageNamed:@"公交车-1"] forState:(UIControlStateNormal)];
        [_publicBtn addTarget:self action:@selector(publicBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _publicBtn.tag =9001;

    }
    
    return _publicBtn;
}
-(UIButton *)carBtn{
    
    if (!_carBtn) {
        _carBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _carBtn.frame =CGRectMake(aScaleW(171), aScaleH(161), aScaleW(37), aScaleH(20));
        [_carBtn setBackgroundImage:[UIImage imageNamed:@"出租车0"] forState:(UIControlStateNormal)];
        [_carBtn addTarget:self action:@selector(publicBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _carBtn.tag = 9002;
    }
    
    return _carBtn;
}
-(UIButton *)walkBtn{
    
    if (!_walkBtn) {
        _walkBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _walkBtn.frame =CGRectMake(aScaleW(256), aScaleH(158), aScaleW(16), aScaleH(24));
        [_walkBtn setBackgroundImage:[UIImage imageNamed:@"步行-0"] forState:(UIControlStateNormal)];
        [_walkBtn addTarget:self action:@selector(publicBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _walkBtn.tag = 9003;
        
    }
    
    return _walkBtn;
}


#pragma mark - 页面开始加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"查看路线";
    [self.reserveBtn removeFromSuperview];
        [self searchRoutCreateView];
    self.transportType = 1;
    

      [self publicBtnAction:self.publicBtn];
}

-(void)searchRoutCreateView{
    
    [self.view addSubview:self.contentImageView];
    [self.view addSubview:self.signImageView];
    [self.view addSubview:self.selfLabel];
    [self.view addSubview:self.destensLabel];
    [self.view addSubview:self.changeBtn];
    [self.view addSubview:self.publicBtn];
    [self.view addSubview:self.carBtn];
    [self.view addSubview:self.walkBtn];
    [self.view addSubview:self.tableView];
    
    
}


-(void)gaoDeMapSearch{
    
    
    [AMapServices sharedServices].apiKey = @"50da07e6ce5ee36c07aab356a291ec18";
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.city             = @"xian";
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.selfLocationCoordinate.latitude
                                           longitude:self.selfLocationCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destensCoordinate.latitude
                                                longitude:self.destensCoordinate.longitude];
    //    调用 AMapSearchAPI 的 AMapTransitRouteSearch 并发起公交路线规划。
    [self.search AMapTransitRouteSearch:navi];
}

-(void)carMapSearch{
    
    [AMapServices sharedServices].apiKey = @"50da07e6ce5ee36c07aab356a291ec18";
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    
    navi.requireExtension = YES;
    navi.strategy = 5;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.selfLocationCoordinate.latitude
                                           longitude:self.selfLocationCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destensCoordinate.latitude
                                                longitude:self.destensCoordinate.longitude];
    //    调用 AMapSearchAPI 的 AMapTransitRouteSearch 并发起公交路线规划。
   [self.search AMapDrivingRouteSearch:navi];
    
    
}

-(void)walkMapSearch{
    [AMapServices sharedServices].apiKey = @"50da07e6ce5ee36c07aab356a291ec18";
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 提供备选方案*/
    navi.multipath = 1;
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.selfLocationCoordinate.latitude
                                           longitude:self.selfLocationCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destensCoordinate.latitude
                                                longitude:self.destensCoordinate.longitude];
    //    调用 AMapSearchAPI 的 AMapTransitRouteSearch 并发起公交路线规划。
[self.search AMapWalkingRouteSearch:navi];
}

#pragma mark - 按钮的点击事件

-(void)changBtnAction:(UIButton *)sender{
  
//交换
    NSString *tempStr =self.selfLabel.text;
    self.selfLabel.text = self.destensLabel.text;
    self.destensLabel.text = tempStr;
    
    CLLocationCoordinate2D tempCoordinate = self.selfLocationCoordinate;
    self.selfLocationCoordinate = self.destensCoordinate;
    self.destensCoordinate = tempCoordinate;
    
    
    
}
-(void)publicBtnAction:(UIButton *)sender{
    
    
    self.progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progress.color = [UIColor clearColor];
    

    
    switch (sender.tag) {
        case 9001:
        {
            self.transportType =1;
            [sender setBackgroundImage:[UIImage imageNamed:@"公交车1"] forState:(UIControlStateNormal)];
             [self.carBtn setBackgroundImage:[UIImage imageNamed:@"出租车0"] forState:(UIControlStateNormal)];
            [self.walkBtn setBackgroundImage:[UIImage imageNamed:@"步行0"] forState:(UIControlStateNormal)];
            [self   gaoDeMapSearch];
        }
            break;
        case 9002:
        {            self.transportType =2;

            [sender setBackgroundImage:[UIImage imageNamed:@"出租车1"] forState:(UIControlStateNormal)];
            [self.publicBtn setBackgroundImage:[UIImage imageNamed:@"公交车0"] forState:(UIControlStateNormal)];
            [self.walkBtn setBackgroundImage:[UIImage imageNamed:@"步行0"] forState:(UIControlStateNormal)];
            [self carMapSearch];
        }
            break;
        case 9003:
        {            self.transportType =3;

            [sender setBackgroundImage:[UIImage imageNamed:@"步行1"] forState:(UIControlStateNormal)];
            [self.publicBtn setBackgroundImage:[UIImage imageNamed:@"公交车0"] forState:(UIControlStateNormal)];
            [self.carBtn setBackgroundImage:[UIImage imageNamed:@"出租车0"] forState:(UIControlStateNormal)];
            [self walkMapSearch];
        }
            break;
            
        default:
            break;
    }
    
    
}
//-(void)carBtnAction:(UIButton *)sender{
//    
//    
//    
//}
//-(void)walkBtnAction:(UIButton *)sender{
//    
//    
//    
//}

#pragma mark - 表视图代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.routeArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MapSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapSearchTableViewCell" forIndexPath:indexPath];
    if (indexPath.row<10) {
        
         cell.numberLabel.text = [NSString stringWithFormat:@"0%ld",indexPath.row];
    }else{
        
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    }
    switch (self.transportType) {
        case 1:
        {
            AMapTransit *transit = self.routeArray[indexPath.row];
            [cell setCellWithTransit:transit];
        }
            break;
        case 2:
        {
      AMapPath *path =  self.routeArray[indexPath.row];
            [cell setCellWithPath:path];
        }
            break;
        case 3:
        {
            AMapPath *path =  self.routeArray[indexPath.row];
            [cell setCellWithPath:path];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MapDetailViewController *mapDetailVC = [[MapDetailViewController alloc]init];
    mapDetailVC.type = self.transportType;
    mapDetailVC.selfLocationCoordinate = self.selfLocationCoordinate;
    mapDetailVC.destensCoordinate = self.destensCoordinate;
    mapDetailVC.startName = self.selfLabel.text;
    mapDetailVC.destensName = self.destensLabel.text;
    if (self.transportType ==1) {//规划公交路线
        mapDetailVC.transit = self.routeArray[indexPath.row];
        
    }else{//规划驾车和不行路线
        
        mapDetailVC.path = self.routeArray[indexPath.row];
    }
    
    MapSearchTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    mapDetailVC.titleStr = cell.titleLabel.text;
    mapDetailVC.descStr = cell.descLabel.text;
    
    [self presentViewControllerWithVC:mapDetailVC animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}

#pragma mark - 高德地图的回调

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    NSLog(@"route--%@",route);
    
    switch (self.transportType) {
        case 1://公交
        {
            self.routeArray = [NSArray arrayWithArray:response.route.transits];//公交路线数量
//            AMapTransit *transit = self.routeArray[0];//第一条路线
  [self.tableView reloadData];
        }
            break;
        case 2://驾车
        {
            self.routeArray = [NSArray arrayWithArray:response.route.paths]; //路径数组
//            AMapStep *step = path.steps[0]; //这个路径上的导航路段数组
            [self.tableView reloadData];
        }
            break;
        case 3://步行
        {
            self.routeArray = [NSArray arrayWithArray:response.route.paths]; //路径数组
//            AMapStep *step = path.steps[0]; //这个路径上的导航路段数组
            [self.tableView reloadData];
        }
            break;
            
        default:
            
            break;
            
    }
    
    [self.progress removeFromSuperview];
    
}

//当检索失败时，会进入 didFailWithError 回调函数，通过该回调函数获取产生的失败的原因。

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
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
