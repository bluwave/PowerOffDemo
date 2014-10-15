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
@property(nonatomic, strong) UIView *bgImageContainer;
@end

@implementation GRSlider
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureBackgroundImageContainer];
        [self configureBackgroundImageView];
        [self configureSlider];
    }
    return self;
}

- (void)configureSlider {
    UISlider *slider = self.slider = [[UISlider alloc] initWithFrame:CGRectMake(GRSliderSpacingFromContainer, GRSliderSpacingFromContainer, (self.bounds.size.width - (3* GRSliderSpacingFromContainer)), self.bounds.size.height - (2 * GRSliderSpacingFromContainer))];
    self.slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [slider setMinimumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage new] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"off.png"] forState:UIControlStateNormal];
    [slider setMaximumValue:1];
    [slider setMinimumValue:0];
    [slider setValue:0];
    [slider setContinuous:YES];
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderDidFinishSliding:) forControlEvents:UIControlEventTouchUpInside];
//    [slider addTarget:self action:@selector(sliderDidStartSliding:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:slider];
}

- (void)configureBackgroundImageContainer {
    _bgImageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _bgImageContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _bgImageContainer.backgroundColor = [UIColor clearColor];
    [_bgImageContainer.layer setCornerRadius:self.bounds.size.height / 2];
    [_bgImageContainer.layer setMasksToBounds:YES];
    [self addSubview:_bgImageContainer];
}

- (void)configureBackgroundImageView {
    _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_backgroundImageView setContentMode:UIViewContentModeScaleToFill];
    _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_backgroundImageView setBackgroundColor:[UIColor lightGrayColor]];
    [_bgImageContainer addSubview:_backgroundImageView];

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_backgroundImageView addSubview:blurEffectView];
    [blurEffectView pinViewToAllSidesOfSuperView];
}

- (void)valueChanged:(id)sender {
    UISlider *slider = (UISlider *) sender;
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        [slider setValue:slider.value animated:NO];
    }                completion:nil];
    [self syncLeftSideContainerToSlider];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)sliderDidFinishSliding:(id)sender {
    UISlider *slider = (UISlider *) sender;
    NSUInteger index = (NSUInteger) (slider.value + 0.25);
    [UIView animateWithDuration:0.27 delay:0.03 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [slider setValue:index animated:YES];
        [self syncLeftSideContainerToSlider];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    } completion:^(BOOL finished) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }];
}

- (void)syncLeftSideContainerToSlider {
    CGRect sliderThumbImgRect = [self thumbRect];
    UIView *container = self.bgImageContainer;
    UIView *innerView = self.backgroundImageView;
    CGRect containerFrame = container.frame;
    CGRect innerFrame = innerView.frame;

    CGFloat x = sliderThumbImgRect.origin.x - (GRSliderSpacingFromContainer / 2);
    if (x < 0) x = 0;
    containerFrame.origin.x = x;
    innerFrame.origin.x = -x;
    containerFrame.size.width = self.bounds.size.width - containerFrame.origin.x;

    container.frame = containerFrame;
    innerView.frame = innerFrame;
}

- (CGRect)thumbRect {
    CGRect trackRect = [self.slider trackRectForBounds:self.slider.bounds];
    CGRect r = [self.slider thumbRectForBounds:self.slider.bounds trackRect:trackRect value:self.slider.value];
    return r;
}

- (CGFloat)value {
    return self.slider.value;
}
@end
