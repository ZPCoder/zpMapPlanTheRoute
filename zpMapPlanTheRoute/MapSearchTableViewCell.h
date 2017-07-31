//
//  MapSearchTableViewCell.h
//  WonderfulTime
//
//  Created by 朱鹏 on 2017/1/6.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

-(void)setCellWithPath:(AMapPath *)path;

-(void)setCellWithTransit:(AMapTransit *)transit;


@end
