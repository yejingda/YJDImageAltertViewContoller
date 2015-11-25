//
//  ViewController.m
//  YJDImageViewController
//
//  Created by yejingda on 15/11/25.
//  Copyright © 2015年 xxxx.com. All rights reserved.
//

#import "ViewController.h"
#import "YJDImageAlertViewController.h"

#define ALERT_VIEW_INDENTIFIER_A  @"ImageAlertViewControllerIndentifierA"

@interface ViewController ()<YJDImageAlertViewControllerDelegte>
@property (nonatomic, strong) YJDImageAlertViewController *imageAlertViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.imageAlertViewController showImageAlertViewInRect:self.view.bounds ofView:self.view withIndentifier:ALERT_VIEW_INDENTIFIER_A];
}

- (YJDImageAlertViewController *)imageAlertViewController {
    if (_imageAlertViewController == nil) {
        _imageAlertViewController = [[YJDImageAlertViewController alloc] init];
        _imageAlertViewController.delegate = self;
    }
    return _imageAlertViewController;
}

#pragma mark - YJDImageAlertViewControllerDelegte

- (BOOL)showBottomButtonForAlertViewController:(YJDImageAlertViewController *)imageAlertViewController withIndentifier:(NSString *)indentifier {
    return YES;
}

- (UIImage *)imageForAlertViewController:(YJDImageAlertViewController *)imageAlertViewController withIndentifier:(NSString *)indentifier {
    return [UIImage imageNamed:@"test_image.jpg"];
}

- (NSArray *)contentsForAlertViewController:(YJDImageAlertViewController *)imageAlertViewController withIndentifier:(NSString *)indentifier {
    if ([indentifier isEqualToString:ALERT_VIEW_INDENTIFIER_A]) {
        return @[@"哈哈，出错了，你打我啊~"];
    }
    return nil;
}

- (NSString *)bottomButtonTitleForAlertViewController:(YJDImageAlertViewController *)imageAlertViewController withIndentifier:(NSString *)indentifier {
    return @"点我，点我";
}

@end
