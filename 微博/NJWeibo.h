//
//  NJWeibo.h
//  06-预习-微博(通过代码自定义cell)
//
//  Created by 李南江 on 14-4-21.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJWeibo : NSObject
@property (nonatomic, copy) NSString *text; // 内容，为wordpress文章的第一段
@property (nonatomic, copy) NSString *icon; // 头像,为作者本人的头像
@property (nonatomic, copy) NSString *name; // 昵称，为作者本人的昵称
@property (nonatomic, copy) NSString *picture; // 配图，为wordpress的特色图
@property (nonatomic, copy) NSString *time; //发帖时间
@property (nonatomic, copy) NSString *title; //标题


- (id)initWithDict:(NSDictionary *)dict;
+ (id)weiboWithDict:(NSDictionary *)dict;
@end
