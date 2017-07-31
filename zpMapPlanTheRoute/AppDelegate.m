//
//  AppDelegate.m
//  zpMapPlanTheRoute
//
//  Created by 朱鹏 on 2017/7/31.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<CLLocationManagerDelegate>


@property (nonatomic,assign)CLLocationCoordinate2D selfCoordinate2D;


@property (nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self getLocation];
    
    return YES;
}



#pragma mark - 地理定位
-(void)getLocation{
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"用户打开了位置服务");
        
    }else{
        self.selfCoordinate2D = CLLocationCoordinate2DMake(34.329834, 108.943316);
        
        NSLog(@"没有打开位置服务");
        
        NSArray *arr = @[@{@"longitude":@(108.943316),@"latitude":@(34.329834)}];
        
        [self writeLocationToWithArr:arr];
    }
    [self.locationManager startUpdatingLocation];
    
    
}

//经纬度写入本地
- (void)writeLocationToWithArr:(NSArray *)array {
    
    // 沙盒路径
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    // 文件路径
    NSString *fileName=[path stringByAppendingPathComponent:@"userLocation.plist"];
    BOOL isWrite = [array writeToFile:fileName atomically:YES];
    if (isWrite) {
        
        NSLog(@"经纬度信息值保存成功");
        
    }else{
        
        NSLog(@"经纬度信息值保存失败");
    }
}



//地理定位代理
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //当前位置信息
    CLLocation *curLoction = [locations firstObject];
    //经纬度
    CLLocationCoordinate2D cooreinat = curLoction.coordinate;
    NSLog(@"经度：%f，纬度：%f",cooreinat.longitude,cooreinat.latitude);
    NSArray *arr = @[@{@"longitude":@(cooreinat.longitude),@"latitude":@(cooreinat.latitude)}];
    //写入本地
    [self writeLocationToWithArr:arr];
    
}

//定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"定位失败%@",error);
    
}

-(CLLocationManager *)locationManager{
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.distanceFilter = 10;
        _locationManager.desiredAccuracy = 10;
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.delegate =self;
        //        _locationManager.allowsBackgroundLocationUpdates = YES;
        
    }
    return _locationManager;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
