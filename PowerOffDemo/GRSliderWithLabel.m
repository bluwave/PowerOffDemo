//
//  GRSliderWithLabel.m
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/14/14.
//
//

#import "GRSliderWithLabel.h"

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>




@interface GRSliderWithLabel()

@end
@implementation GRSliderWithLabel


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:frame];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:35];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _textLabel.alpha = 0;
        [self addSubview:_textLabel];
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_textLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_textLabel.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.slider addTarget:self action:@selector(stopSliding:) forControlEvents:UIControlEventTouchUpInside];
        [self.slider addTarget:self action:@selector(subSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_textLabel setTextWithChangeAnimation:@"slide to poweroff"];
        _textLabel.text = @"foobar";
        _textLabel.alpha = 0;
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self bringSubviewToFront:self.textLabel];
    _textLabel.alpha = 1;
}

- (void)subSliderValueChanged:(id)sender {
    [self toggleTextLabel:sender];
}

- (void)stopSliding:(id)sender {
  [self toggleTextLabel:sender];

}

- (void)toggleTextLabel:(id)sender {
//    CGPoint sliderPosition = [self thumbRect].origin;
//    NSLog(@"%s sliderPos: %@", __func__, NSStringFromCGPoint(sliderPosition));
    UISlider *s = (UISlider *) sender;
    if (s.value == 0)
        self.textLabel.alpha = 1;
    else self.textLabel.alpha = 0;
}


@end
