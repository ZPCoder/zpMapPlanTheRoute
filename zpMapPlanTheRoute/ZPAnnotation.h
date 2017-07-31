//
//  ZPAnnotation.h
//  precticeLocation
//
//  Created by 朱鹏 on 2016/12/22.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface ZPAnnotation : NSObject<MKAnnotation>

//经纬度
@property (nonatomic)CLLocationCoordinate2D coordinate;
//父标题
@property (nonatomic,copy)NSString *title;
//子标题
@property (nonatomic,copy)NSString *subtitle;


@end
