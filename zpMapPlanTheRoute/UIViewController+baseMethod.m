//
//  UIViewController+baseMethod.m
//  WonderfulTime
//
//  Created by 朱鹏 on 2016/10/24.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "UIViewController+baseMethod.h"

@interface UIViewController ()


@end

@implementation UIViewController (baseMethod)
#pragma mark - ScaleSize



- (CGFloat)autoScaleW:(CGFloat)w{
    
            return w * (kScreenWidth / 414.0f);
       
  }

- (CGFloat)autoScaleH:(CGFloat)h{
       return h * (kScreenHeight / 736.0f);
    
}

- (CGFloat)aScaleW:(CGFloat)w{
    
    return w * (kScreenWidth / 375.0f);
    
}

- (CGFloat)aScaleH:(CGFloat)h{
    return h * (kScreenHeight / 667.0f);
    
}


-(void)presentViewControllerWithVC:(UIViewController *)VC animated:(BOOL)animated{
    
    [VC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentViewController:VC animated:animated completion:nil];
    
}

@end
