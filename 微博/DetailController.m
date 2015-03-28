//
//  DetailController.m
//  微博
//
//  Created by Sean Chain on 3/23/15.
//  Copyright (c) 2015 jinheng. All rights reserved.
//

#import "DetailController.h"
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "YALNavigationBar.h"
#import "ZuSimpelColor.h"
#import "DetailController+ENPopUp.h"

static NSString *const menuCellIdentifier = @"rotationCell";

@interface DetailController ()


@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;

@end

@implementation DetailController

NSArray *commentarr;
NSString *postid;

- (NSArray *)handleComments:(NSArray*)str{
    NSUInteger len = str.count;
    if (len == 0) {
        return @[];
    }
    NSMutableArray *ret = [NSMutableArray new];
    for (int i = 0; i < len; i ++) {
        NSDictionary *dic = @{@"date":str[i][@"date"], @"name":str[i][@"name"], @"content":
                                  str[i][@"content"]};
        [ret addObject:dic];
    }
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiateMenuOptions];
    NSString *content = _dic[@"content"];
    NSArray *comments = _dic[@"comments"];
    postid = _dic[@"id"];
    NSLog(@"%@", postid);
    commentarr = (NSArray*)[self handleComments:comments];
    NSLog(@"%@", commentarr);
    CGRect webframe = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    UIWebView *webview = [[UIWebView alloc] initWithFrame:webframe];
    [self.view addSubview:webview];
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [webview loadHTMLString:content baseURL:baseURL];    
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentMenuButtonTapped:)];
    NSArray *myButtonArray = [[NSArray alloc] initWithObjects:myAddButton, nil];
    myAddButton.tintColor = whitesmoke;
    self.navigationItem.rightBarButtonItems = myButtonArray;
    // Do any additional setup after loading the view.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id destController = segue.destinationViewController;
    [destController setValue:commentarr forKey:@"cmt"];
    NSLog(@"%@", destController);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

#pragma mark - IBAction

- (IBAction)presentMenuButtonTapped:(UIBarButtonItem *)sender {
    // init YALContextMenuTableView tableView
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
}

#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"查看评论",
                        @"发布评论",
                        @"共享",];
    
    self.menuIcons = @[[UIImage imageNamed:@"close.png"],
                       [UIImage imageNamed:@"comments.png"],
                       [UIImage imageNamed:@"newc.png"],
                       [UIImage imageNamed:@"share.png"]];
}


- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
    NSUInteger tap = indexPath.row;
    NSLog(@"Menu dismissed with indexpath = %lu", tap);
    if (tap == 1) {
        [self performSegueWithIdentifier:@"commentHandle" sender:self.view];
    }
    if (tap == 2) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PopUp"];
        vc.view.frame = CGRectMake(0, 0, 270.0f, 200.0f);

        [self presentPopUpViewController:vc with:postid];
    }
}

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView dismisWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    
    return cell;
}


@end
