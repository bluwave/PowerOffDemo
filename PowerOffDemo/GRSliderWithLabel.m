//
//  GRSliderWithLabel.m
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/14/14.
//
//

#import "GRSliderWithLabel.h"
#import "FBShimmeringView.h"

@interface GRSliderWithLabel()
@property(nonatomic, strong) FBShimmeringView *shimmeringView;
@end
@implementation GRSliderWithLabel


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureTextlabel];
        [self.slider addTarget:self action:@selector(stopSliding:) forControlEvents:UIControlEventTouchUpInside];
        [self.slider addTarget:self action:@selector(subSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)configureShimmeringView {
    if (!self.shimmeringView) {
        CGFloat shiftValue = [self thumbRect].size.width+25;
        FBShimmeringView *shimmeringView = self.shimmeringView = [[FBShimmeringView alloc] initWithFrame:(CGRect){shiftValue,self.bounds.origin.y,self.bounds.size.width, self.bounds.size.height}];
        self.shimmeringView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        shimmeringView.contentView = self.textLabel;
        shimmeringView.shimmeringAnimationOpacity = 0;
        shimmeringView.shimmeringOpacity = 1;
        shimmeringView.shimmeringSpeed = 75;
        shimmeringView.shimmeringHighlightWidth = 0.7;
        [self insertSubview:shimmeringView belowSubview:self.textLabel];
        shimmeringView.shimmering = YES;
    }
}

- (void)configureTextlabel {
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = [UIFont systemFontOfSize:20];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.alpha = 0;
    [self addSubview:_textLabel];
    [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_textLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_textLabel.superview attribute:NSLayoutAttributeCenterX multiplier:1.175 constant:1]];

    [self configureShimmeringView];
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
//    NSLog(@"%f", self.value);
    if (self.value == 0) {
        [UIView animateWithDuration:0.3 delay:0.25 options:0 animations:^{
            self.textLabel.alpha = 1;
        } completion:nil];
    }
    else {
        self.textLabel.alpha = 0;
    }
}


@end
