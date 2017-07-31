//
//  MapViewController.h
//  WonderfulTime
//
//  Created by 朱鹏 on 2017/1/5.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPAnnotation.h"

@interface MapViewController : PresenalBaseViewController
@property (nonatomic,strong)NSString *addressStr;
@property (nonatomic)CLLocationCoordinate2D shopCoordinate;
@property (nonatomic,strong)NSString *shopTitleStr;
@end
