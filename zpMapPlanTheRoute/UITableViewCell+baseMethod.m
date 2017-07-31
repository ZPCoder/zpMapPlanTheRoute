//
//  UITableViewCell+baseMethod.m
//  WonderfulTime
//
//  Created by 朱鹏 on 2016/10/24.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "UITableViewCell+baseMethod.h"
#import <objc/runtime.h>


@implementation UITableViewCell (baseMethod)
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

static char AddressKey;//类似于一个中转站,参考

-(void)setCellHeight:(CGFloat)cellHeight{
    
    NSNumber *t = @(cellHeight);
    // void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
    objc_setAssociatedObject(self, &AddressKey, t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    
}
-(CGFloat)cellHeight{
    
    NSNumber *t = objc_getAssociatedObject(self, &AddressKey);
    return (CGFloat)[t floatValue];
    
}


//将视图转换为UIImage格式
- (UIImage*) imageWithUIView:(UIView*) view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}


@end
