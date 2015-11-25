//
//  YJDImageAlertViewController.m
//  Aipai
//
//  Created by yejingda on 15/11/17.
//  Copyright © 2015年 www.aipai.com. All rights reserved.
//

#import "YJDImageAlertViewController.h"
#import "YJDImageAltertViewBottomButton.h"

#define MAIN_LABEL_HEIGHT             16
#define SUBHEADING_LABEL_HEIGHT       14
#define LABEL_MIDDLE_SPACING          9
#define IMAGE_BUTTOM_HEIGHT           12
#define BOTTOM_BUTTON_WIDTH           160
#define BOTTOM_BUTTON_HEIGHT          40
#define BOTTOM_BUTTON_SPACING         25
//#define IMAGE_SIZE                    120
#define BOTTOM_HEIGHT                 14

@interface YJDImageAlertViewController ()
@property (nonatomic, weak)   NSTimer *delayTimerForHidden;
@property (nonatomic, strong) UIView *currentImageAlertView;
@property (nonatomic, strong) NSString *currentIndentifier;
@property (nonatomic, strong) NSArray *otherViewsArray;
@end

@implementation YJDImageAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)showImageAlertViewInRect:(CGRect)rect ofView:(UIView *)view withIndentifier:(NSString *)indentifier {
    if (_currentImageAlertView) {
        if (![self.currentIndentifier isEqualToString:indentifier]) {
            [self hideImageAlertViewWithAnimated:NO];
        } else {
            return; // if same type then do nothing.
        }
    }
    self.currentIndentifier = indentifier;
    self.currentImageAlertView = [self configImageAlertView];
    
    [self showIndicatorViewInRect:rect ofView:view];
    
}

- (void)showIndicatorViewInRect:(CGRect)rect ofView:(UIView *)containerView
{
    CGRect layoutRect;
    
    layoutRect.size = self.currentImageAlertView.frame.size;
    layoutRect.origin.x = rect.origin.x + (rect.size.width - layoutRect.size.width) / 2;
    layoutRect.origin.y = rect.origin.y + (rect.size.height - layoutRect.size.height) * 0.4;
    
    self.currentImageAlertView.frame = layoutRect;
    
    [containerView addSubview:self.currentImageAlertView];
    
    if ([self.delegate respondsToSelector:@selector(otherViewForImageAlertViewController:withIndentifier:)]) {
        self.otherViewsArray = [self.delegate otherViewForImageAlertViewController:self withIndentifier:self.currentIndentifier];
    }
    for (UIView *view in self.otherViewsArray) {
        [containerView addSubview:view];
    }
}


- (UIView *)configImageAlertView {
    UIView *containerView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    YJDImageAltertViewBottomButton *button = [[YJDImageAltertViewBottomButton alloc] init];
    NSArray *mainTitleArray = nil;
    UIImage *image = nil;
    if ([self.delegate respondsToSelector:@selector(imageForAlertViewController:withIndentifier:)]) {
        image = [self.delegate imageForAlertViewController:self withIndentifier:self.currentIndentifier];
    }
    
    if ([self.delegate respondsToSelector:@selector(contentsForAlertViewController:withIndentifier:)]) {
        mainTitleArray = [self.delegate contentsForAlertViewController:self withIndentifier:self.currentIndentifier];
    }
    
    //计算最大的宽度
    NSMutableArray *mainTitleLabelArray = [[NSMutableArray alloc] init];

    CGFloat maxWidth  = 0.0;
    if ([mainTitleArray count] > 0) {
        for (NSInteger i = 0; i < [mainTitleArray count]; i++) {
            UILabel *label = [self mainTitleLabelWithText:[mainTitleArray objectAtIndex:i]];
            CGSize labelSize = [label sizeThatFits:CGSizeMake(9999, MAIN_LABEL_HEIGHT)];
            
            if (labelSize.width > maxWidth) {
                maxWidth = labelSize.width;
            }
            [mainTitleLabelArray addObject:label];
        }
    }
    
    BOOL showButtomButton = NO;
    if ([self.delegate respondsToSelector:@selector(showBottomButtonForAlertViewController:withIndentifier:)]) {
        showButtomButton = [self.delegate showBottomButtonForAlertViewController:self withIndentifier:self.currentIndentifier];
    }
    
    if (image.size.width > maxWidth && image) {
        maxWidth = image.size.width;
    }
    
    if (BOTTOM_BUTTON_WIDTH > maxWidth && showButtomButton) {
        maxWidth = BOTTOM_BUTTON_WIDTH;
    }
    
    //计算高度
    CGFloat height = 0.0;
    if (image) {
        height = image.size.height + IMAGE_BUTTOM_HEIGHT;
    }
    if ([mainTitleLabelArray count] > 0) {
        height = height + (MAIN_LABEL_HEIGHT + LABEL_MIDDLE_SPACING)* [mainTitleLabelArray count];
        height = height - LABEL_MIDDLE_SPACING;
    }
    
    if (showButtomButton) {
        height = height + BOTTOM_BUTTON_SPACING + BOTTOM_BUTTON_HEIGHT;
    }
    
    height = height + BOTTOM_HEIGHT;
    
    //布局
    containerView.frame = CGRectMake(0.0, 0.0, maxWidth, height);
    if (image) {
        [containerView addSubview:imageView];
        imageView.image = image;
        imageView.frame = CGRectMake((maxWidth - image.size.width) / 2, 0.0, image.size.width, image.size.height);
    }
    
    UILabel *laseMainTitleLabel = nil;
    if ([mainTitleLabelArray count] > 0) {
        laseMainTitleLabel = [mainTitleLabelArray lastObject];
        for (NSInteger i = 0; i < [mainTitleLabelArray count]; i++) {
            UILabel *label = [mainTitleLabelArray objectAtIndex:i];
            [containerView addSubview:label];
            CGSize labelSize = [label sizeThatFits:CGSizeMake(9999, MAIN_LABEL_HEIGHT)];
            label.frame = CGRectMake((maxWidth - labelSize.width) / 2, image.size.height + IMAGE_BUTTOM_HEIGHT + (MAIN_LABEL_HEIGHT + LABEL_MIDDLE_SPACING) * i , labelSize.width, MAIN_LABEL_HEIGHT);
        }
    }
    
    if (showButtomButton) {
        NSString *bottomTitle = @"点击重试";
        if ([self.delegate respondsToSelector:@selector(bottomButtonTitleForAlertViewController:withIndentifier:)]) {
            bottomTitle = [self.delegate bottomButtonTitleForAlertViewController:self withIndentifier:self.currentIndentifier];
        }
        button.title = bottomTitle;
        [button addTarget:self action:@selector(didSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:button];
        button.frame = CGRectMake((CGRectGetWidth(containerView.frame) - BOTTOM_BUTTON_WIDTH) / 2, CGRectGetHeight(containerView.frame) - BOTTOM_BUTTON_HEIGHT - BOTTOM_HEIGHT, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT);
    }
    return containerView;
}

- (UILabel *)mainTitleLabelWithText:(id)text {
    UILabel *label = [[UILabel alloc] init];
    if ([text isKindOfClass:[NSString class]]) {
        label.text = text;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
    }
    if ([text isKindOfClass:[NSMutableAttributedString class]]) {
        label.attributedText = text;
    }
    label.text = text;
    return label;
}


- (void)hideImageAlertViewWithAnimated:(BOOL)animated {
    UIView *currentIndicatorView = self.currentImageAlertView;
    
    if (!currentIndicatorView) {
        return;
    }
    
    self.currentImageAlertView = nil;
    self.delayTimerForHidden = nil;
    
    void (^ completion)(BOOL) = ^(BOOL finished) {
        for (UIView *view in self.otherViewsArray) {
            [view removeFromSuperview];
        }
        _otherViewsArray = nil;
        [currentIndicatorView removeFromSuperview];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            currentIndicatorView.alpha = 0;
        } completion:completion];
    } else {
        completion(YES);
    }
}

- (void)didSelectedButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(imageAlertViewController:didSelectedButtonWithIndentifier:)]) {
        [self.delegate imageAlertViewController:self didSelectedButtonWithIndentifier:self.currentIndentifier];
    }
}

@end
