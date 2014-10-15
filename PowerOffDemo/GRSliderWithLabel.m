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


@implementation UILabel (FSHighlightAnimationAdditions)

- (void)setTextWithChangeAnimation:(NSString*)text
{
    NSLog(@"value changing");
    self.text = text;
    CALayer *maskLayer = [CALayer layer];
    
    // Mask image ends with 0.15 opacity on both sides. Set the background color of the layer
    // to the same value so the layer can extend the mask image.
    maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f] CGColor];
    maskLayer.contents = (id)[[UIImage imageNamed:@"Mask.png"] CGImage];
    
    // Center the mask image on twice the width of the text layer, so it starts to the left
    // of the text layer and moves to its right when we translate it by width.
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(self.frame.size.width * -1, 0.0f, self.frame.size.width * 2, self.frame.size.height);
    
    // Animate the mask layer's horizontal position
    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    maskAnim.byValue = [NSNumber numberWithFloat:self.frame.size.width];
    maskAnim.repeatCount = HUGE_VALF;
    maskAnim.duration = 2.0f;
    [maskLayer addAnimation:maskAnim forKey:@"slideAnim"];
    
    self.layer.mask = maskLayer;
}

@end

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
