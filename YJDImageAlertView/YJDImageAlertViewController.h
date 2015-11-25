//
//  YJDImageAlertViewController.h
//  Aipai
//
//  Created by yejingda on 15/11/17.
//  Copyright © 2015年 www.aipai.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YJDImageAlertViewController;

@protocol YJDImageAlertViewControllerDelegte <NSObject>

- (UIImage *)imageForAlertViewController:(YJDImageAlertViewController *)imageAlertViewController withIndentifier:(NSString *)indentifier;

- (BOOL)showBottomButtonForAlertViewController:(YJDImageAlertViewController *)imageAlertViewController withIndentifier:(NSString *)indentifier;

@optional
/**
 *  添加文案数组
 *
 *  @param imageAlertViewController
 *  @param indentifier              标识符，用来唯一识别的，
 *
 *  @return <#return value description#>
 */
- (NSArray *)contentsForAlertViewController:(YJDImageAlertViewController *)imageAlertViewController withIndentifier:(NSString *)indentifier;

/**
 *  按钮的文字
 *
 *  @param imageAlertViewController <#imageAlertViewController description#>
 *  @param indentifier              <#indentifier description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)bottomButtonTitleForAlertViewController:(YJDImageAlertViewController *)imageAlertViewController withIndentifier:(NSString *)indentifier;//默认 点击重试
/**
 *  点击按钮时的回调
 *
 *  @param imageAlertViewController <#imageAlertViewController description#>
 *  @param indentifier              <#indentifier description#>
 */
- (void)imageAlertViewController:(YJDImageAlertViewController *)imageAlertViewController didSelectedButtonWithIndentifier:(NSString *)indentifier;//点击按钮的回调

/**
 *  除了图片，标题，按钮之外的，如果你还需要在这个view中，增加其他view的话，在这个回调中添加一个view数组就好了。
 *
 *  @param imageAlertViewController <#imageAlertViewController description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)otherViewForImageAlertViewController:(YJDImageAlertViewController *)imageAlertViewController withIndentifier:(NSString *)indentifier;
@end

@interface YJDImageAlertViewController : NSObject
@property (nonatomic, weak)id<YJDImageAlertViewControllerDelegte> delegate;

- (void)showImageAlertViewInRect:(CGRect)rect ofView:(UIView *)view withIndentifier:(NSString *)indentifier;

- (void)hideImageAlertViewWithAnimated:(BOOL)animated;

@end
