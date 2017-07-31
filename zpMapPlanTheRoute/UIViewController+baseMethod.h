//
//  UIViewController+baseMethod.h
//  WonderfulTime
//
//  Created by 朱鹏 on 2016/10/24.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (baseMethod)

- (CGFloat)autoScaleW:(CGFloat)w;

- (CGFloat)autoScaleH:(CGFloat)h;


- (CGFloat)aScaleW:(CGFloat)w;
- (CGFloat)aScaleH:(CGFloat)h;
//自定义返回动画
-(void)presentViewControllerWithVC:(UIViewController *)VC animated:(BOOL)animated;




@end
