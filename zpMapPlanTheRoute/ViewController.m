//
//  ViewController.m
//  zpMapPlanTheRoute
//
//  Created by 朱鹏 on 2017/7/31.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTextFeild;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.titleLabel.text = @"请输入地址";
    [self.view bringSubviewToFront:self.addressTextFeild];
    [self.view bringSubviewToFront:self.searchBtn];
}

- (IBAction)searchBtn:(UIButton *)sender {
   
    if (self.addressTextFeild.text.length != 0 ) {
        
        [self geocoder];
    }
}

/**
 地理编码
 */
- (void)geocoder {
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    
    NSString *addressStr = self.addressTextFeild.text;//位置信息
    
    [geocoder geocodeAddressString:addressStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error!=nil || placemarks.count==0) {
            return ;
        }
        //创建placemark对象
        CLPlacemark *placemark=[placemarks firstObject];
        //经度
        CGFloat longitude =placemark.location.coordinate.longitude;
        //纬度
        CGFloat latitude =placemark.location.coordinate.latitude;
        
        NSLog(@"经度：%f，纬度：%f",longitude,latitude);
        
        
        MapViewController *mapVC = [[MapViewController alloc]init];
        
        
        CLLocationCoordinate2D shopCoorDinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        mapVC.shopCoordinate = shopCoorDinate;
        mapVC.shopTitleStr = placemark.name;
        mapVC.addressStr = self.addressTextFeild.text;
        
        [self presentViewControllerWithVC:mapVC animated:YES];
        
        
        
    }]; 
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
