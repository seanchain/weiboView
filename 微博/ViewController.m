//
//  ViewController.m
//  微博
//
//  Created by piglikeyoung on 15/3/3.
//  Copyright (c) 2015年 jinheng. All rights reserved.
//

#import "ViewController.h"
#import "NJWeibo.h"
#import "JHWeiboCell.h"
#import "JHWeiboFrame.h"
#import "HTMLParser.h"
#import "CBStoreHouseRefreshControl.h"
#import "ZuSimpelColor.h"

@interface ViewController ()

@property (strong , nonatomic) NSArray *statusFrames;


@end

@implementation ViewController

NSIndexPath *idxpth;
NSMutableArray *posts;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"沉思·航";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = doubi;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.tableView.backgroundColor = white;
    
    // Let the show begins
    self.storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.tableView target:self refreshAction:@selector(refreshTriggered:) plist:@"csh" color:shiqing lineWidth:1.5 dropHeight:80 scale:1 horizontalRandomness:150 reverseLoadingAnimation:YES internalAnimationFactor:0.5];
    
}

#pragma mark - 数据源
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHWeiboCell *cell = [JHWeiboCell cellWithTableView:tableView];
    
    // 3.设置数据
    cell.weiboFrame = self.statusFrames[indexPath.row];
    
    // 4.返回
    return cell;
    
}

#pragma mark - 懒加载
- (NSArray *)statusFrames
{
    if (_statusFrames == nil) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"statuses.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        
        
        //NSURL *url = [NSURL URLWithString:@"http://chensihang.com/blog/?json=1"];
        //NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSString *str = [NSString stringWithContentsOfFile:@"/Users/seanchain/Desktop/index.txt" encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *arr = [json objectForKey:@"posts"];
        posts = [[NSMutableArray alloc] init];
        NSMutableArray *titles = [[NSMutableArray alloc] init];
        NSMutableArray *thumbnails = [[NSMutableArray alloc] init];
        NSMutableArray *dates = [[NSMutableArray alloc] init];
        for (NSDictionary *contentdata in arr) {
            NSString *temptitle = [contentdata objectForKey:@"title"];
            [titles addObject:temptitle];
            NSString *temparr = [contentdata objectForKey:@"content"];
            [posts addObject:temparr];
            NSString *tempthumbnail = [contentdata objectForKey:@"thumbnail"];
            NSString *tempdate = [contentdata objectForKey:@"modified"];
            [dates addObject:tempdate];
            if (tempthumbnail == nil) {
                [thumbnails addObject:@""];
            }
            else
                [thumbnails addObject:tempthumbnail];
        }
        NSMutableArray *dictarrs = [[NSMutableArray alloc] init];
        int count = 0;
        for (NSString *str in posts){
            HTMLParser *parser = [[HTMLParser alloc] initWithString:str error:nil];
            HTMLNode *node = [parser body];
            NSArray *paras = [node findChildTags:@"p"];
            NSString *text = [[paras objectAtIndex:0] allContents];
            NSMutableDictionary *tempdic = [[NSMutableDictionary alloc] init];
            tempdic[@"name"] = @"陈思行没基础";
            //tempdic[@"icon"] = @"http://www.chensihang.com/CSHiOS/portraits/cs.jpg";
            tempdic[@"icon"] = @"http://localhost:8888/pic/cs.jpg";
            tempdic[@"text"] = text;
            tempdic[@"time"] = dates[count];
            tempdic[@"picture"] = thumbnails[count];
            tempdic[@"title"] = titles[count];
            count ++;
            [dictarrs addObject:tempdic];
        }
        
        dictarrs[0][@"picture"] = @"http://localhost:8888/pic/profile.jpg";
        
        
        for (NSDictionary *dict in dictarrs) {
            // 创建模型
            NJWeibo *weibo = [NJWeibo weiboWithDict:dict];
            // 根据模型数据创建frame模型
            JHWeiboFrame *wbF = [[JHWeiboFrame alloc] init];
            wbF.weibo = weibo;
            [models addObject:wbF];
        }
        self.statusFrames = [models copy];
    }
    return _statusFrames;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    idxpth = indexPath;
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:idxpth];
    if (cell.tag == 0) {
        cell.selected = NO;
    }else{
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
    [self performSegueWithIdentifier:@"newscontent" sender:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destController = segue.destinationViewController;
    [destController setValue:posts[idxpth.row] forKey:@"content"];
}


#pragma mark - 代理方法
// 这个方法比cellForRowAtIndexPath先调用，即创建cell的时候得先知道它的高度，所以高度必须先计算
// 所以在懒加载的时候获取微博的数据立即去计算行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出相应行的frame模型
    JHWeiboFrame *wbf = self.statusFrames[indexPath.row];
    return wbf.cellHeight;
}


-(BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Notifying refresh control of scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [self.storeHouseRefreshControl finishingLoading];
    NSLog(@"Hello, world");
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
