//
//  JHWeiboFrame.m
//  微博
//
//  Created by piglikeyoung on 15/3/3.
//  Copyright (c) 2015年 jinheng. All rights reserved.
//

#import "JHWeiboFrame.h"
#import "NJWeibo.h"


#define JHNameFont [UIFont systemFontOfSize:15]
#define JHTextFont [UIFont systemFontOfSize:16]
#define TimeFont [UIFont systemFontOfSize:12]

@implementation JHWeiboFrame

-(void)setWeibo:(NJWeibo *)weibo
{
    _weibo = weibo;
    
    
    // 间隙
    CGFloat padding = 10;
    CGFloat margin = 20;
    
    // 设置头像的frame
    CGFloat iconViewX = padding;
    CGFloat iconViewY = padding;
    CGFloat iconViewW = 38;
    CGFloat iconViewH = 38;
    self.iconF = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    // 设置昵称的frame
    // 昵称的x = 头像最大的x + 间隙
    CGFloat nameLabelX = CGRectGetMaxX(self.iconF) + padding;
    // 计算文字的宽高
    CGSize nameSize = [self sizeWithString:_weibo.name font:[UIFont boldSystemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize timeSize = [self sizeWithString:_weibo.time font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat nameLabelH = nameSize.height;
    CGFloat nameLabelW = nameSize.width;
    CGFloat nameLabelY = iconViewY;
    self.nameF = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    // 设置时间的frame
    CGFloat vipViewX = nameLabelX;
    CGFloat vipViewY = nameLabelY + margin;
    CGFloat vipViewW = timeSize.width;
    CGFloat vipViewH = timeSize.height;
    self.vipF = CGRectMake(vipViewX, vipViewY, vipViewW, vipViewH);
    NSLog(@"%f", MAXFLOAT);
    // 设置正文的frame
    CGFloat introLabelX = iconViewX;
    CGFloat introLabelY = CGRectGetMaxY(self.iconF) + padding;
    CGSize textSize =  [self sizeWithString:_weibo.text font:JHTextFont maxSize:CGSizeMake(300, MAXFLOAT)];
    
    CGFloat introLabelW = textSize.width;
    CGFloat introLabelH = textSize.height;
    
    self.introF = CGRectMake(introLabelX, introLabelY, introLabelW, introLabelH);
    // 设置配图的frame
    if (![_weibo.picture isEqualToString:@""]) {// 有配图
        CGFloat pictureViewX = iconViewX;
        CGFloat pictureViewY = CGRectGetMaxY(self.introF) + padding;
        CGFloat pictureViewW = 200;
        CGFloat pictureViewH = 200;
        self.pictrueF = CGRectMake(pictureViewX, pictureViewY, pictureViewW, pictureViewH);
        
        // 计算行高
        self.cellHeight = CGRectGetMaxY(self.pictrueF) + padding;
    }else{
        // 没有配图情况下的行高
        self.cellHeight = CGRectGetMaxY(self.introF) + padding;
    }
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
-(CGSize) sizeWithString:(NSString *)str font:(UIFont *) font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
