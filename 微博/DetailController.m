//
//  DetailController.m
//  微博
//
//  Created by Sean Chain on 3/23/15.
//  Copyright (c) 2015 jinheng. All rights reserved.
//

#import "DetailController.h"

@interface DetailController ()

@end

@implementation DetailController

@synthesize content;
@synthesize webview;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *con = (NSString *)content;
    NSLog(@"%@", con);
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [webview loadHTMLString:(NSString*)content baseURL:baseURL];
    // Do any additional setup after loading the view.
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
