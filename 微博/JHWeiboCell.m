//
//  JHWeibo.m
//  微博
//
//  Created by piglikeyoung on 15/3/3.
//  Copyright (c) 2015年 jinheng. All rights reserved.
//

#import "JHWeiboCell.h"
#import "NJWeibo.h"
#import "JHWeiboFrame.h"
#import "AFHTTPRequestOperation.h"

#define JHNameFont [UIFont systemFontOfSize:15]
#define JHTextFont [UIFont systemFontOfSize:16]

@interface JHWeiboCell ()

/*
 @property (nonatomic, copy) NSString *text; // 内容，为wordpress文章的第一段
 @property (nonatomic, copy) NSString *icon; // 头像,为作者本人的头像
 @property (nonatomic, copy) NSString *name; // 昵称，为作者本人的昵称
 @property (nonatomic, copy) NSString *picture; // 配图，为wordpress的特色图
 @property (nonatomic, copy) NSString *time; //发帖时间
 @property (nonatomic, copy) NSString *categories; //类型
 */

@property (nonatomic, weak) UIImageView *iconView; //头像
@property (nonatomic, weak) UIImageView *pictureView; //wordpress主题图片
@property (nonatomic, weak) UILabel *nameLabel; //用户名一直为Chen Sihang
@property (nonatomic, weak) UILabel *introLabel; //文章第一段的内容
@property (nonatomic, weak) UILabel *timeLabel; //发帖时间的label
@property (nonatomic, weak) UILabel *categories; //当前博文所属的类型


@end

@implementation JHWeiboCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"status";
    // 1.缓存中取
    JHWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[JHWeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
        // 1.创建头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 2.创建昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = JHNameFont;
//        nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 3.创建发博时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = JHNameFont;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 4.创建正文
        UILabel *introLabel = [[UILabel alloc] init];
        introLabel.font = JHTextFont;
        introLabel.numberOfLines = 0;
        // introLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:introLabel];
        self.introLabel = introLabel;
        
        // 5.创建配图
        UIImageView *pictureView = [[UIImageView alloc] init];
        [self.contentView addSubview:pictureView];
        self.pictureView = pictureView;
    }
    
    return self;
}

-(void)setWeiboFrame:(JHWeiboFrame *)weiboFrame
{
    _weiboFrame = weiboFrame;
    
    // 1.给子控件赋值数据
    [self settingData];
    // 2.设置frame
    [self settingFrame];
}

/**
 *  设置子控件的数据
 */
-(void)settingData
{
    NJWeibo *weibo = self.weiboFrame.weibo;
    
    
    NSString *urlstr = [NSString stringWithFormat:@"http://www.chensihang.com/CSHiOS/portraits/cs.jpg"];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.iconView.image = responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];

    
    
    // 设置头像
    self.iconView.image = [UIImage imageNamed:weibo.icon];
    // 设置昵称
    self.nameLabel.text = weibo.name;
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
    
    // 设置发博时间
    self.timeLabel.text = weibo.time;
    self.timeLabel.textColor = [UIColor grayColor];
    self.timeLabel.font = [UIFont boldSystemFontOfSize:13];
    
    
    // 设置内容
    self.introLabel.text = weibo.text;
    
    // 设置配图
    if (![weibo.picture isEqualToString:@""]) {
        self.pictureView.image = [UIImage imageNamed:weibo.picture];
        NSLog(@"%@", weibo.picture);
        NSString *urlstr = weibo.picture;
        NSURL *url = [NSURL URLWithString:urlstr];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            self.pictureView.image = responseObject;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operation start];
        self.pictureView.hidden = NO;
    }else{
        self.pictureView.hidden = YES;
    }
}


/**
 *  设置子控件的frame
 */
-(void)settingFrame
{
    // 设置头像的frame
    self.iconView.frame = self.weiboFrame.iconF;
    
    // 设置昵称的frame
    self.nameLabel.frame = self.weiboFrame.nameF;
    
    // 设置时间的frame
    self.timeLabel.frame = self.weiboFrame.vipF;
    
    // 设置正文的frame
    self.introLabel.frame = self.weiboFrame.introF;
    
    // 设置配图的frame
    
    if (![self.weiboFrame.weibo.picture isEqualToString:@""]) {// 有配图
        NSLog(@"%@", self.weiboFrame.weibo.picture);
        self.pictureView.frame = self.weiboFrame.pictrueF;
    }
}


@end
