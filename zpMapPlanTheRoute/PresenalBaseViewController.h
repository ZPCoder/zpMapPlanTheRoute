//
//  PresenalBaseViewController.h
//  WonderfulTime
//
//  Created by 朱鹏 on 16/9/28.
//  Copyright © 2016年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import <math.h>
#import <MapKit/MapKit.h>
@interface PresenalBaseViewController : UIViewController

@property (nonatomic,retain)UIImageView *backImageView;
@property (nonatomic,retain)UIButton *backBtn;
@property (nonatomic,retain)UIButton *reserveBtn;
@property (nonatomic,retain)UILabel *titleLabel;

@property (nonatomic,retain)MBProgressHUD *progress;
@property (nonatomic,assign)CLLocationCoordinate2D selfCoorDinate;
@property (nonatomic,strong)UITapGestureRecognizer *selfTap;
@property (nonatomic,retain)UIPanGestureRecognizer *pan;


/*
 平移手势回调
 */
-(void)panAction:(UIPanGestureRecognizer *)sender;
/**
 *  返回按钮回调
 *
 *  @param sender
 */


-(void)backBtnAction:(UIButton *)sender;

/**
 *  备用按钮回调
 *
 *  @param sender
 */
-(void)reserveBtnAction:(UIButton *)sender;


/*
 
 弹出提醒框
 
 */

-(void)showAlertViewWithMessag:(NSString *)msg;

/*
 带block回调的弹出框
 */
-(void)showAlertViewWithMessag:(NSString *)msg andMethod:(void(^)())method;

/*
 缩放图片
 */
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;


-(void)loadMoreData;



/*
 
在沙盒里边创建一个文件夹并返回路径，如果存在直接返回路径

 */
-(NSString *)createFileOrBackFilePathWithName:(NSString *)FileName;


//设置旋转中心点
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;

@end
