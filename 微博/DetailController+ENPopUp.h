//
//  DetailController+ENPopUp.h
//  微博
//
//  Created by Sean Chain on 3/27/15.
//  Copyright (c) 2015 jinheng. All rights reserved.
//

#import "DetailController.h"

@interface DetailController (ENPopUp)

@property (nonatomic, retain) UIViewController *en_popupViewController;
- (void)presentPopUpViewController:(UIViewController *)popupViewController with:(NSString*)postid;
- (void)presentPopUpViewController:(UIViewController *)popupViewController completion:(void (^)(void))completionBlock;
- (void)dismissPopUpViewController;
- (void)dismissPopUpViewControllerWithcompletion:(void (^)(void))completionBlock;

@end
