
//
//  CommentController.m
//  微博
//
//  Created by Sean Chain on 3/26/15.
//  Copyright (c) 2015 jinheng. All rights reserved.
//

#import "CommentController.h"
#import "ZuSimpelColor.h"
#import "HTMLParser.h"

@interface CommentController ()

@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 2)];
    //[self.view addSubview:scrollview];
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    NSArray *cary = _cmt;
    NSLog(@"%@", cary);
    CGRect rect  = [[UIApplication sharedApplication] statusBarFrame];
    UIFont *topfont = [UIFont fontWithName:@"SentyTEA-Platinum" size:15];
    UIFont *textfont = [UIFont fontWithName:@"SentyTEA-Platinum" size:17];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    CGFloat padding = w * 0.05;
    CGFloat height = self.navigationController.navigationBar.frame.size.height + rect.size.height;
    if ([cary isEqualToArray:@[]]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, height, w, 40)];
        label.text = @"没有评论内容";
        label.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:label];
    }
    else{
        CGFloat bottonline = height;
        for (int i = 0; i < cary.count; i ++) {
            UILabel *username = [[UILabel alloc] init];
            UILabel *time = [[UILabel alloc] init];
            UILabel *content = [[UILabel alloc] init];
            UILabel *line = [[UILabel alloc] init];
            username.text = cary[i][@"name"];
            time.text = cary[i][@"date"];
            content.text = [self parsePTag:cary[i][@"content"]];
            CGSize size1 = [username.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:topfont,NSFontAttributeName, nil]];
            CGSize size2 = [time.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:topfont,NSFontAttributeName, nil]];
            username.frame = CGRectMake(padding, bottonline + 20,size1.width, size1.height);
            time.frame = CGRectMake(w - padding * 2 - size2.width, username.frame.origin.y, size2.width, size2.height);
            CGSize textSize =  [self sizeWithString:content.text font:textfont maxSize:CGSizeMake(w - padding * 2, MAXFLOAT)];
            content.frame = CGRectMake(padding, CGRectGetMaxY(username.frame) + padding, textSize.width, textSize.height);
            line.frame = CGRectMake(padding, CGRectGetMaxY(content.frame) + padding, w - padding * 2, 1);
            line.backgroundColor = wuwangcao;
            username.font = topfont;
            time.font = topfont;
            content.font = textfont;
            content.numberOfLines = 0;
            time.textColor = gray;
            bottonline = CGRectGetMaxY(line.frame);
            [scrollview addSubview:username];
            [scrollview addSubview:time];
            [scrollview addSubview:content];
            [scrollview addSubview:line];
            [self.view addSubview:scrollview];
        }
    }
}

- (NSString*)parsePTag:(NSString *)str{
    HTMLParser *parser = [[HTMLParser alloc] initWithString:str error:nil];
    HTMLNode *node = [parser body];
    NSArray *paras = [node findChildTags:@"p"];
    NSString *text = [[paras objectAtIndex:0] allContents];
    return text;
}

-(CGSize) sizeWithString:(NSString *)str font:(UIFont *) font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
