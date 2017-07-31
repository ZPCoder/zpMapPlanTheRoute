//
//  MapSearchTableViewCell.m
//  WonderfulTime
//
//  Created by 朱鹏 on 2017/1/6.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "MapSearchTableViewCell.h"

@implementation MapSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.numberLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    self.titleLabel.font =[UIFont systemFontOfSize:autoScaleW(16)];
    self.descLabel.font =[UIFont systemFontOfSize:autoScaleW(15)];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)setCellWithPath:(AMapPath *)path{
    
    NSString *titleStr = @"途经";
    NSInteger count = path.steps.count<2?path.steps.count:2;
    
    for (int i=0; i<count; i++) {
        
        NSString *roadStr = path.steps[i].road;
        if (i==0) {
            titleStr = [NSString stringWithFormat:@"%@%@",titleStr,roadStr];
        }else{
            
            titleStr = [NSString stringWithFormat:@"%@和%@",titleStr,roadStr];
        }
       
        
    }
    self.titleLabel.text = titleStr;

    self.descLabel.text = [NSString stringWithFormat:@"%ld分钟 | %.1f公里",path.duration/60,path.distance/1000.0f];
    
}

-(void)setCellWithTransit:(AMapTransit *)transit{
    
    NSString *titleStr = @"";
    NSInteger count = transit.segments.count<2?transit.segments.count:2;
    
    for (int i=0; i<count; i++) {
        
        if (transit.segments[i].buslines.count>0) {
             NSString *roadStr = transit.segments[i].buslines[0].name;
        NSArray *strArr = [roadStr componentsSeparatedByString:@"("];
       
        roadStr = strArr[0];
        
        if (i==0) {
            titleStr = roadStr;
        }else{
            
            titleStr = [NSString stringWithFormat:@"%@ - %@",titleStr,roadStr];
        }
        

        }
               
    }
    
    self.titleLabel.text = titleStr;
    
     self.descLabel.text = [NSString stringWithFormat:@"%ld分钟 | %.1f公里 | 步行%ld米",transit.duration/60,transit.distance/1000.0f,transit.walkingDistance];
    
    
}



@end
