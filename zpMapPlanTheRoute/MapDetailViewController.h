//
//  MapDetailViewController.h
//  WonderfulTime
//
//  Created by 朱鹏 on 2017/1/7.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapDetailViewController : PresenalBaseViewController

@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)AMapTransit *transit;
@property (nonatomic,strong)AMapPath *path;
@property (nonatomic,assign)CLLocationCoordinate2D selfLocationCoordinate;
@property (nonatomic,assign)CLLocationCoordinate2D destensCoordinate;
@property (nonatomic,strong)NSString *startName;
@property (nonatomic,strong)NSString *destensName;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)NSString *descStr;

@end
