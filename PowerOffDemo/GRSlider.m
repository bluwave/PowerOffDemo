//
//  GRSlider.m
//  PowerOffDemo
//
//  Created by Garrett Richards on 10/14/14.
//
//

#import "GRSlider.h"
#import "UIView+DemoAdditions.h"

static const CGFloat GRSliderSpacingFromContainer = 5.0;

@interface GRSlider()
@property(nonatomic, strong) UISlider *slider;
@property(nonatomic, strong) UIImageView *sliderImageView;
@end

@implementation GRSlider
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureBackgroundImageView];
        [self configureSlider];
    }
    return self;
}

- (UIImageView *)sliderImageView {
    if (_sliderImageView) return _sliderImageView;

    for (UIView *v in self.slider.subviews) {
//        NSLog(@"%s v: %@", __func__, v);
        if ([v isKindOfClass:[UIImageView class]]) {
            _sliderImageView = (UIImageView *) v;
            break;
        }
    }
    return _sliderImageView;
}

- (void)configureSlider {
    UISlider *slider = self.slider = [[UISlider alloc] initWithFrame:CGRectMake(GRSliderSpacingFromContainer, GRSliderSpacingFromContainer, (self.bounds.size.width - (3* GRSliderSpacingFromContainer)), self.bounds.size.height - (2 * GRSliderSpacingFromContainer))];
    [slider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [slider setMaximumValue:1];
    [slider setMinimumValue:0];
    [slider setValue:0];
    [slider setContinuous:YES];
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:slider];

}

- (void)configureBackgroundImageView {
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_backgroundImageView setBackgroundColor:UIColor.orangeColor];
    [self addSubview:_backgroundImageView];
    [_backgroundImageView.layer setCornerRadius:self.bounds.size.height / 2];
    [_backgroundImageView.layer setMasksToBounds:YES];

//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    [_backgroundImageView addSubview:blurEffectView];
//    [blurEffectView pinViewToAllSidesOfSuperView];
}

- (void)valueChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
//    FIXME -  trigger this on container view of this control [self toggleDarkOverlayWithAlpha:slider.value];
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [slider setValue:slider.value animated:NO];
    }                completion:nil];
    [self syncScrollViewLeftSideToSlider];

}

- (void)sliderUp:(id)sender {
    UISlider *slider = (UISlider *) sender;
    NSUInteger index = (NSUInteger) (slider.value + 0.25);
    [UIView animateWithDuration:0.27 delay:0.03 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [slider setValue:index animated:YES];
        [self syncScrollViewLeftSideToSlider];
       //    FIXME -  trigger this on container view of this control  [self toggleDarkOverlayWithAlpha:self.slider.value];
    } completion:^(BOOL finished) {
       //    FIXME -  trigger this on container view of this control  [self toggleDarkOverlayWithAlpha:self.slider.value];
    }];

}


- (void)syncScrollViewLeftSideToSlider {
    CGRect trackRect = [self.slider trackRectForBounds:self.slider.bounds];
    CGRect r = [self.slider thumbRectForBounds:self.slider.bounds trackRect:trackRect value:self.slider.value];
    CGRect f = self.backgroundImageView.frame;
    f.origin.x = r.origin.x - (GRSliderSpacingFromContainer / 2);
    f.size.width = self.bounds.size.width - f.origin.x;
    self.backgroundImageView.frame = f;
}
@end
