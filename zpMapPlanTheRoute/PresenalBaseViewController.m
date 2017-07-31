//
//  PresenalBaseViewController.m
//  WonderfulTime
//
//  Created by 朱鹏 on 16/9/28.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import "PresenalBaseViewController.h"
#import "UIViewController+baseMethod.h"

@interface PresenalBaseViewController ()<UIApplicationDelegate>

@end

@implementation PresenalBaseViewController
-(UITapGestureRecognizer *)selfTap{
    
    if (!_selfTap) {
        
        _selfTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfTapAction:)];
        
    }
    return _selfTap;
}

-(UIImageView *)backImageView{
    
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:_backImageView];
        
    }
    return _backImageView;
}

-(UIButton *)backBtn{
    
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _backBtn.frame = CGRectMake(kScreenWidth*0.05, kScreenHeight*0.041, kScreenWidth*0.1, kScreenHeight*0.04);
        [self.view addSubview:_backBtn];
        
    }
    return _backBtn;
}

-(UIButton *)reserveBtn{
    
    if (!_reserveBtn) {
        _reserveBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_reserveBtn addTarget:self action:@selector(reserveBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_reserveBtn setTitleColor:kwhiteColor forState:(UIControlStateNormal)];
        _reserveBtn.frame = CGRectMake(kScreenWidth*0.85, kScreenHeight*0.04, kScreenWidth*0.1, kScreenHeight*0.042);
        [self.view addSubview:_reserveBtn];
        
    }
    return _reserveBtn;
    
    
}
-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.3, kScreenHeight*0.05, kScreenWidth*0.4, kScreenHeight*0.025)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:autoScaleW(18)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_titleLabel];
  
    }
    
    return _titleLabel;
    
}

-(CLLocationCoordinate2D)selfCoorDinate{
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"userLocation.plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    
    if (array.count !=0) {
//        NSLog(@"地理位置取值成功，%@",array);
        
        NSDictionary *dic = array.lastObject;
        CGFloat latitude =[[dic objectForKey:@"latitude"] floatValue];
        CGFloat longitude =[[dic objectForKey:@"longitude"] floatValue];
        _selfCoorDinate = CLLocationCoordinate2DMake(latitude, longitude);
    }else{
        
        NSLog(@"地理位置取值失败%@",array);
        
    }
    
    return _selfCoorDinate;
}


#pragma mark - 程序开始
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.backImageView.image = [UIImage imageNamed:@"background0fAll"];
    self.titleLabel.text = @"";
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"GR-back"] forState:(UIControlStateNormal)];
    [self.reserveBtn setBackgroundImage:[UIImage imageNamed:@"GR-menu"] forState:(UIControlStateNormal)];
    
    self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:self.pan];
    //    [self getToken];
    
    
    
}

-(void)selfTapAction:(UITapGestureRecognizer *)sender{
    
    
    [self.view endEditing:YES];
}

-(void)panAction:(UIPanGestureRecognizer *)sender{
    //得到手势所作用的视图
    UIView *myView =[sender view];
    //    得到手势的偏移量
    CGPoint movePoint =[sender translationInView:myView];
    //    通过2D仿射变换函数中与平移相关的函数来改变视图的位置
    //    tx:X方向的位移
    //    ty:Y方向的位移
    //    myView.transform = CGAffineTransformMakeTranslation(movePoint.x, 0);
    
    //可滑动范围
    if (movePoint.x>0 &&movePoint.x<kScreenWidth/3) {
        myView.frame =CGRectMake(movePoint.x, 0, kScreenWidth, kScreenHeight);
    }
    
    //    NSLog(@"偏移量%f",movePoint.x);
    
    
    if (sender.state ==UIGestureRecognizerStateEnded || sender.state ==UIGestureRecognizerStateCancelled  ) {//触摸结束后判断
        
        //        NSLog(@"触摸结束");
        
        if (movePoint.x>kScreenWidth/3) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [UIView animateWithDuration:0.3 animations:^{
                myView.frame =CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }];
        }
    }
}


//返回按钮
-(void)backBtnAction:(UIButton *)sender{
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
        
    }];
    
}
//备用按钮
-(void)reserveBtnAction:(UIButton *)sender{
    
    
}



-(void)showAlertViewWithMessag:(NSString *)msg{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        nil;
        
    }];
    
    [alertC addAction:alertAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
    
}
-(void)showAlertViewWithMessag:(NSString *)msg andMethod:(void(^)())method{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"友情提示" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        //判断block是否实现
        if (method) {
            
            method();
            
        }
        
    }];
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    
    [alertC addAction:alertAction];
    [alertC addAction:backAction];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
-(void)loadMoreData{
    
  

}

#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    scaleSize = sqrtf(scaleSize);
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}



//在沙盒里边创建一个文件夹并返回路径，如果存在直接返回路径
-(NSString *)createFileOrBackFilePathWithName:(NSString *)FileName{
    
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@",pathDocuments,FileName];
    if (![[NSFileManager defaultManager]fileExistsAtPath:createPath]) {
        
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }else{
        NSLog(@"有这个文件了");
    }
    return createPath;
}

//设置视图旋转的中心点
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
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
