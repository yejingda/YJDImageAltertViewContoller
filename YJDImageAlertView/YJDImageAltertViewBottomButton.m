//
//  YJDImageAltertViewBottomButton.m
//  Aipai
//
//  Created by yejingda on 15/11/23.
//  Copyright © 2015年 www.aipai.com. All rights reserved.
//

#import "YJDImageAltertViewBottomButton.h"
#define CGOnePixelValue (1.0f / [UIScreen mainScreen].scale)

#define LABEL_HIGHT        15

@interface YJDImageAltertViewBottomButton()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YJDImageAltertViewBottomButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor colorWithRed:1.000 green:0.640 blue:0.017 alpha:1.000];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.bounds;
    CGSize titleLabelSize = [self.titleLabel sizeThatFits:CGSizeMake(9999, LABEL_HIGHT)];
    self.titleLabel.frame = CGRectMake((CGRectGetWidth(rect) - titleLabelSize.width) / 2, (CGRectGetHeight(rect) - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
}



- (void)drawRect:(CGRect)rect {
    rect = CGRectInset(rect, CGOnePixelValue / 2, CGOnePixelValue / 2);
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.highlighted) {
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor);
    } else{
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }
    
    [[UIColor colorWithRed:205.0 / 225.0 green:205.0 / 225.0 blue:205.0 / 225.0 alpha:1.0] setStroke];
    CGContextSetLineWidth(context, CGOnePixelValue);
    
    CGFloat radius = 4.0;
    CGFloat rectX = rect.origin.x;
    CGFloat rectY = rect.origin.y;
    CGContextMoveToPoint(context, radius + rectX, rectY);
    CGContextAddLineToPoint(context, width - radius + rectX, rectY);
    CGContextAddArc(context, width - radius + rectX , radius + rectY, radius, -0.5 * M_PI, 0.0, 0);
    CGContextAddLineToPoint(context, width + rectX, height - radius + rectY);
    CGContextAddArc(context, width - radius + rectX, height - radius + rectY, radius, 0.0, 0.5 * M_PI, 0);
    CGContextAddLineToPoint(context, radius + rectX, height + rectY);
    CGContextAddArc(context, radius + rectX, height - radius + rectY, radius, 0.5 * M_PI, M_PI, 0);
    
    CGContextAddLineToPoint(context, rectX, radius + rectY);
    CGContextAddArc(context, radius + rectX, radius + rectY, radius, M_PI, 1.5 * M_PI, 0);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
