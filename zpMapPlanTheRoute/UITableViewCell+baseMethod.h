//
//  UITableViewCell+baseMethod.h
//  WonderfulTime
//
//  Created by 朱鹏 on 2016/10/24.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (baseMethod)
- (CGFloat)autoScaleW:(CGFloat)w;

- (CGFloat)autoScaleH:(CGFloat)h;

- (CGFloat)aScaleW:(CGFloat)w;
- (CGFloat)aScaleH:(CGFloat)h;
//将视图转换为UIImage格式
- (UIImage*) imageWithUIView:(UIView*) view;
@property (nonatomic,assign)CGFloat cellHeight;

@end
